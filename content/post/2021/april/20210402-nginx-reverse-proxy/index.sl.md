+++
date = "2021-04-02"
title = "Velike stvari s posodami: večja varnost storitev Docker z LDAP in NGINX"
difficulty = "level-1"
tags = ["calibre", "calibre-web", "ldap", "logging", "nutzerverwaltung", "peertube", "ssl"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210402-nginx-reverse-proxy/index.sl.md"
+++
Kot uporabnik Synology Diskstation uporabljam številne storitve v svojem omrežju Homelab. Programsko opremo nameščam v Gitlabu, znanje dokumentiram v Confluence in berem tehnične reference prek spletnega strežnika Calibre.
{{< gallery match="images/1/*.png" >}}
Vse omrežne storitve komunicirajo šifrirano in so zavarovane prek osrednje uporabniške uprave. Danes bom pokazal, kako sem zavaroval svojo storitev Calibre s šifriranjem SSL, beleženjem dostopa in omejitvijo dostopa LDAP. V tem učbeniku je potrebno predhodno znanje iz "[Kul stvari z družbo Atlassian: Uporaba vseh orodij družbe Atlassian s protokolom LDAP]({{< ref "post/2021/march/20210321-atlassian-ldap" >}} "Kul stvari z družbo Atlassian: Uporaba vseh orodij družbe Atlassian s protokolom LDAP")" in "[Velike stvari s posodami: Zagon programa Calibre s programom Docker Compose]({{< ref "post/2020/february/20200221-docker-Calibre-pro" >}} "Velike stvari s posodami: Zagon programa Calibre s programom Docker Compose")".
## Moj strežnik LDAP
Kot sem že napisal, v vsebniku Docker zaženem osrednji strežnik openLDAP. Ustvaril sem tudi nekaj skupin aplikacij.
{{< gallery match="images/2/*.png" >}}

## Varovanje nezanesljive aplikacije z obrnjenim proxyjem
Ker slika Docker "linuxserver/calibre-web" ne podpira šifriranja SSL in LDAP, ustvarim navidezno omrežje z imenom "calibreweb" in pred strežnik Calibre postavim povratni posrednik NGINX. Tako je videti moja datoteka Docker Compose. Vsi prihodnji dnevniki dostopa so shranjeni v imeniku log, moji samopodpisani certifikati pa v imeniku certs.
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
Več uporabnih slik Docker za domačo uporabo najdete v [Dockerverse]({{< ref "dockerverse" >}} "Dockerverse").
## Konfiguracija Nginx
Datoteka "default.conf" vsebuje vse konfiguracije LDAP in šifriranja. Seveda je treba prilagoditi URL, binddn, certifikate, vrata ter geslo in skupino.
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
Če zdaj zaženete namestitev z "docker-compose -f ...etc... up", lahko v dnevniku dostopov vidite tudi dostope prijavljenih uporabnikov:
{{< gallery match="images/3/*.png" >}}
Ker so uporabniki LDAP le gostujoči uporabniki, je treba v Calibrewebu nastaviti pravice gostujočih uporabnikov:
{{< gallery match="images/4/*.png" >}}
