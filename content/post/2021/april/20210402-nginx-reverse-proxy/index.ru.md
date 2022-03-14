+++
date = "2021-04-02"
title = "Великие вещи с контейнерами: повышение безопасности сервисов Docker с помощью LDAP и NGINX"
difficulty = "level-1"
tags = ["calibre", "calibre-web", "ldap", "logging", "nutzerverwaltung", "peertube", "ssl"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/april/20210402-nginx-reverse-proxy/index.ru.md"
+++
Являясь пользователем Synology Diskstation, я запускаю множество служб в своей сети Homelab. Я развертываю программное обеспечение в Gitlab, документирую знания в Confluence и читаю технические ссылки через веб-сервер Calibre.
{{< gallery match="images/1/*.png" >}}
Все сетевые службы обмениваются зашифрованными данными и защищены с помощью централизованного администрирования пользователей. Сегодня я покажу, как я защитил свою службу Calibre с помощью SSL-шифрования, протоколирования доступа и ограничения доступа LDAP. Для этого учебника необходимы предварительные знания по "[Крутые вещи с Atlassian: используйте все инструменты Atlassian с помощью LDAP]({{< ref "post/2021/march/20210321-atlassian-ldap" >}} "Крутые вещи с Atlassian: используйте все инструменты Atlassian с помощью LDAP")" и "[Великие вещи с контейнерами: Запуск Calibre с помощью Docker Compose]({{< ref "post/2020/february/20200221-docker-Calibre-pro" >}} "Великие вещи с контейнерами: Запуск Calibre с помощью Docker Compose")".
## Мой сервер LDAP
Как я уже писал, я запускаю центральный сервер openLDAP в контейнере Docker. Я также создал несколько групп приложений.
{{< gallery match="images/2/*.png" >}}

## Защита небезопасного приложения с помощью обратного прокси-сервера
Поскольку образ Docker "linuxserver/calibre-web" не поддерживает шифрование SSL и LDAP, я создаю виртуальную сеть под названием "calibreweb" и ставлю обратный прокси NGINX перед сервером Calibre. Вот как выглядит мой файл Docker Compose. Все будущие журналы доступа хранятся в каталоге log, а мои самоподписанные сертификаты - в каталоге certs.
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
Более полезные образы Docker для домашнего использования можно найти в [Dockerverse]({{< ref "dockerverse" >}} "Dockerverse").
## Конфигурация Nginx
Файл "default.conf" содержит все конфигурации LDAP и шифрования. Конечно, URL, binddn, сертификаты, порты, а также пароль и группа должны быть настроены.
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
Если теперь запустить установку с помощью команды "docker-compose -f ...etc... up", то в журнале доступа можно увидеть доступы зарегистрированных пользователей:
{{< gallery match="images/3/*.png" >}}
Поскольку пользователи LDAP являются только гостевыми пользователями, права гостевого пользователя должны быть установлены в Calibreweb:
{{< gallery match="images/4/*.png" >}}
