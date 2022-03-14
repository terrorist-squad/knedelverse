+++
date = "2021-04-02"
title = "Страхотни неща с контейнерите: повишаване на сигурността на услугите на Docker с LDAP и NGINX"
difficulty = "level-1"
tags = ["calibre", "calibre-web", "ldap", "logging", "nutzerverwaltung", "peertube", "ssl"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/april/20210402-nginx-reverse-proxy/index.bg.md"
+++
Като потребител на Synology Diskstation използвам много услуги в мрежата на домашната си лаборатория. Разгръщам софтуер в Gitlab, документирам знания в Confluence и чета технически препоръки чрез уеб сървъра Calibre.
{{< gallery match="images/1/*.png" >}}
Всички мрежови услуги комуникират криптирано и са защитени чрез централна потребителска администрация. Днес показвам как защитих услугата си Calibre с SSL криптиране, регистриране на достъпа и ограничаване на достъпа по LDAP. За този урок са необходими предварителни знания от "[Готини неща с Atlassian: Използвайте всички инструменти на Atlassian с LDAP]({{< ref "post/2021/march/20210321-atlassian-ldap" >}} "Готини неща с Atlassian: Използвайте всички инструменти на Atlassian с LDAP")" и "[Страхотни неща с контейнери: стартиране на Calibre с Docker Compose]({{< ref "post/2020/february/20200221-docker-Calibre-pro" >}} "Страхотни неща с контейнери: стартиране на Calibre с Docker Compose")".
## Моят сървър LDAP
Както вече писах, стартирам централен openLDAP сървър в контейнера Docker. Създадох и няколко групи приложения.
{{< gallery match="images/2/*.png" >}}

## Защита на несигурно приложение с обратен прокси сървър
Тъй като образът на Docker "linuxserver/calibre-web" не поддържа SSL криптиране и LDAP, създавам виртуална мрежа, наречена "calibreweb", и поставям обратен прокси сървър NGINX пред сървъра Calibre. Ето как изглежда моят файл Docker Compose. Всички бъдещи логове за достъп се съхраняват в директорията log, а самоподписаните ми сертификати са в директорията certs.
```
version: '3.7'
services:
  nginx: 
    image:  weseek/nginx-auth-ldap:1.13.9-1-alpine
    container_name: calibre-nginx
    environment:
    - 'TZ=Europe/Berlin'
    volumes:
      - ./default.conf:/etc/nginx/conf.d/default.conf
      - ./certs:/etc/certs
      - ./logs:/var/log/nginx
    ports:
      - 8443:443
    networks:
      - calibreweb
    restart: unless-stopped

  calibre-web:
    image: linuxserver/calibre-web
    container_name: calibre-web
    environment:
      - PUID=.....
      - PGID=....
      - TZ=Europe/Berlin
    volumes:
      - /volume/docker/calibre/app.db:/app/calibre-web/app.db
      - /volume/Buecher:/books
    expose:
      - 8083
    restart: unless-stopped
    networks:
      - calibreweb

networks:
  calibreweb:

```
Още полезни образи на Docker за домашна употреба можете да намерите в [Dockerverse]({{< ref "dockerverse" >}} "Dockerverse").
## Конфигурация на Nginx
Файлът "default.conf" съдържа всички конфигурации на LDAP и криптирането. Разбира се, URL адресът, binddn, сертификатите, портовете, както и паролата и групата трябва да бъдат коригирани.
```
# ldap auth configuration
auth_ldap_cache_enabled on;
auth_ldap_cache_expiration_time 10000;
auth_ldap_cache_size 1000;
ldap_server ldap1 {
    url ldaps://ldap.server.local:636/dc=homelab,dc=local?uid?sub?(&(objectClass=inetorgperson));

    binddn "cn=root oder so,dc=homelab,dc=local";
    binddn_passwd "password";
    connect_timeout 5s;
    bind_timeout 5s;
    request_timeout 5s;
    ssl_check_cert: off;
    group_attribute memberUid;
    group_attribute_is_dn off;
    require group "cn=APP-Bibliothek,ou=Groups,dc=homelab,dc=local";
    require valid_user;
}

server {
    listen              443 ssl;
    server_name  localhost;

    ssl_certificate /etc/certs/fullchain.pem;
    ssl_certificate_key /etc/certs/privkey.pem;
    #weitere SSL-Einstellungen

    location / {
        auth_ldap "LDAP-ONLY";
        auth_ldap_servers ldap1;

        proxy_set_header        Host            $http_host;
        proxy_set_header        X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header        X-Scheme        $scheme;
        proxy_pass  http://calibre-web:8083; #<- docker expose port
    }
}


```
Ако сега стартирате настройката с "docker-compose -f ...etc... up", можете да видите и достъпа на влезлите потребители в дневника за достъп:
{{< gallery match="images/3/*.png" >}}
Тъй като LDAP потребителите са само гост потребители, в Calibreweb трябва да се зададат права на гост потребители:
{{< gallery match="images/4/*.png" >}}
