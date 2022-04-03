+++
date = "2021-04-02"
title = "Gode ting med containere: sikring af Docker-tjenester med LDAP og NGINX"
difficulty = "level-1"
tags = ["calibre", "calibre-web", "ldap", "logging", "nutzerverwaltung", "peertube", "ssl"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210402-nginx-reverse-proxy/index.da.md"
+++
Som Synology Diskstation-bruger kører jeg mange tjenester på mit Homelab-netværk. Jeg implementerer software i Gitlab, dokumenterer viden i Confluence og læser tekniske referencer via Calibre-webserveren.
{{< gallery match="images/1/*.png" >}}
Alle netværkstjenester kommunikerer krypteret og er sikret via en central brugeradministration. I dag viser jeg, hvordan jeg har sikret min Calibre-tjeneste med SSL-kryptering, adgangslogning og LDAP-adgangsbegrænsning. Forudgående kendskab til "[Fede ting med Atlassian: Brug alle Atlassian-værktøjer med LDAP]({{< ref "post/2021/march/20210321-atlassian-ldap" >}} "Fede ting med Atlassian: Brug alle Atlassian-værktøjer med LDAP")" og "[Store ting med containere: Kørsel af Calibre med Docker Compose]({{< ref "post/2020/february/20200221-docker-Calibre-pro" >}} "Store ting med containere: Kørsel af Calibre med Docker Compose")" er påkrævet for denne vejledning.
## Min LDAP-server
Som jeg allerede har skrevet, kører jeg en central openLDAP-server i Docker-containeren. Jeg har også oprettet et par programgrupper.
{{< gallery match="images/2/*.png" >}}

## Sikre usikre applikationer med reverse proxy
Da Docker-aftrykket "linuxserver/calibre-web" ikke understøtter SSL-kryptering og LDAP, opretter jeg et virtuelt netværk kaldet "calibreweb" og sætter en NGINX reverse proxy foran Calibre-serveren. Sådan ser min Docker Compose-fil ud. Alle fremtidige adgangslogfiler gemmes i log-mappen, og mine selvsignerede certifikater ligger i certs-mappen.
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
Flere nyttige Docker-aftryk til hjemmebrug findes i [Dockerverse]({{< ref "dockerverse" >}} "Dockerverse").
## Nginx-konfiguration
Filen "default.conf" indeholder alle LDAP- og krypteringskonfigurationer. Selvfølgelig skal URL, binddn, certifikater, porte, password og gruppe justeres.
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
Hvis du nu starter opsætningen med "docker-compose -f ...etc... up", kan du også se de loggede brugeres adgangsrettigheder i adgangsloggen:
{{< gallery match="images/3/*.png" >}}
Da LDAP-brugerne kun er gæstebrugere, skal gæstebrugerrettighederne være indstillet i Calibreweb:
{{< gallery match="images/4/*.png" >}}
Jeg kører denne opsætning til følgende tjenester:* Videobibliotek (Peertube)* Bibliotek (Calibreweb)* Gitlab (CE understøtter ikke grupper, så man skal logge ind to gange)
