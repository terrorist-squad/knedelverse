+++
date = "2021-04-02"
title = "Bra saker med containrar: säkrare Dockertjänster med LDAP och NGINX"
difficulty = "level-1"
tags = ["calibre", "calibre-web", "ldap", "logging", "nutzerverwaltung", "peertube", "ssl"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210402-nginx-reverse-proxy/index.sv.md"
+++
Som Synology Diskstation-användare kör jag många tjänster i mitt Homelab-nätverk. Jag distribuerar programvara i Gitlab, dokumenterar kunskap i Confluence och läser tekniska referenser via Calibre-webbservern.
{{< gallery match="images/1/*.png" >}}
Alla nätverkstjänster kommunicerar krypterat och säkras via en central användaradministration. Idag visar jag hur jag säkrat min Calibre-tjänst med SSL-kryptering, åtkomstloggning och LDAP-åtkomstbegränsning. Förkunskaper om "[Coola saker med Atlassian: Använd alla Atlassian-verktyg med LDAP]({{< ref "post/2021/march/20210321-atlassian-ldap" >}} "Coola saker med Atlassian: Använd alla Atlassian-verktyg med LDAP")" och "[Stora saker med containrar: Kör Calibre med Docker Compose]({{< ref "post/2020/february/20200221-docker-Calibre-pro" >}} "Stora saker med containrar: Kör Calibre med Docker Compose")" krävs för denna handledning.
## Min LDAP-server
Som jag redan har skrivit kör jag en central openLDAP-server i Docker-containern. Jag har också skapat några programgrupper.
{{< gallery match="images/2/*.png" >}}

## Säkra osäkra program med omvänd proxy
Eftersom Docker-avbildningen "linuxserver/calibre-web" inte stöder SSL-kryptering och LDAP skapar jag ett virtuellt nätverk som heter "calibreweb" och lägger en NGINX reverse proxy framför Calibre-servern. Så här ser min Docker Compose-fil ut. Alla framtida åtkomstloggar lagras i loggkatalogen och mina självsignerade certifikat finns i certs-katalogen.
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
Fler användbara Docker-avbildningar för hemmabruk finns i [Dockerverse]({{< ref "dockerverse" >}} "Dockerverse").
## Nginx-konfiguration
Filen "default.conf" innehåller alla LDAP- och krypteringskonfigurationer. Självklart måste URL, binddn, certifikat, portar, lösenord och grupp justeras.
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
Om du nu startar installationen med "docker-compose -f ...etc... up" kan du också se de inloggade användarnas åtkomster i åtkomstloggen:
{{< gallery match="images/3/*.png" >}}
Eftersom LDAP-användarna endast är gästanvändare måste gästanvändarrättigheterna ställas in i Calibreweb:
{{< gallery match="images/4/*.png" >}}
