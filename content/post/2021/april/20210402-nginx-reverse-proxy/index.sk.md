+++
date = "2021-04-02"
title = "Veľké veci s kontajnermi: zvýšenie bezpečnosti služieb Docker pomocou LDAP a NGINX"
difficulty = "level-1"
tags = ["calibre", "calibre-web", "ldap", "logging", "nutzerverwaltung", "peertube", "ssl"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210402-nginx-reverse-proxy/index.sk.md"
+++
Ako používateľ zariadenia Synology Diskstation prevádzkujem v sieti Homelab mnoho služieb. Nasadzujem softvér v Gitlabe, dokumentujem znalosti v Confluence a čítam technické referencie prostredníctvom webového servera Calibre.
{{< gallery match="images/1/*.png" >}}
Všetky sieťové služby komunikujú šifrovane a sú zabezpečené prostredníctvom centrálnej správy používateľov. Dnes ukážem, ako som zabezpečil svoju službu Calibre pomocou šifrovania SSL, protokolovania prístupu a obmedzenia prístupu LDAP. Pre tento tutoriál sú potrebné predchádzajúce znalosti z "[Parádne veci s Atlassian: Používanie všetkých nástrojov Atlassian s LDAP]({{< ref "post/2021/march/20210321-atlassian-ldap" >}} "Parádne veci s Atlassian: Používanie všetkých nástrojov Atlassian s LDAP")" a "[Veľké veci s kontajnermi: Spustenie aplikácie Calibre pomocou nástroja Docker Compose]({{< ref "post/2020/february/20200221-docker-Calibre-pro" >}} "Veľké veci s kontajnermi: Spustenie aplikácie Calibre pomocou nástroja Docker Compose")".
## Môj server LDAP
Ako som už napísal, centrálny server openLDAP prevádzkujem v kontajneri Docker. Vytvoril som aj niekoľko skupín aplikácií.
{{< gallery match="images/2/*.png" >}}

## Zabezpečenie nezabezpečenej aplikácie pomocou reverzného proxy servera
Keďže obraz Docker "linuxserver/calibre-web" nepodporuje šifrovanie SSL a LDAP, vytvorím virtuálnu sieť s názvom "calibreweb" a pred server Calibre umiestnim reverzný proxy server NGINX. Takto vyzerá môj súbor Docker Compose. Všetky budúce protokoly o prístupe sú uložené v adresári log a moje certifikáty s vlastným podpisom sú v adresári certs.
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
Ďalšie užitočné obrazy Docker na domáce použitie nájdete v [Dockerverse]({{< ref "dockerverse" >}} "Dockerverse").
## Konfigurácia Nginx
Súbor "default.conf" obsahuje všetky konfigurácie LDAP a šifrovania. Samozrejme, je potrebné upraviť adresu URL, binddn, certifikáty, porty, heslo a skupinu.
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
Ak teraz spustíte nastavenie príkazom "docker-compose -f ...etc... up", v prístupovom protokole uvidíte aj prístupy prihlásených používateľov:
{{< gallery match="images/3/*.png" >}}
Keďže používatelia LDAP sú len hosťujúci používatelia, práva hosťujúcich používateľov musia byť nastavené v Calibrewebe:
{{< gallery match="images/4/*.png" >}}
Toto nastavenie používam pre nasledujúce služby:* Videotéka (Peertube)* Knižnica (Calibreweb)* Gitlab (CE nepodporuje skupiny, takže sa musíte prihlásiť 2x)
