+++
date = "2021-04-02"
title = "Hienoja asioita konttien kanssa: Docker-palveluiden turvaaminen LDAP:n ja NGINX:n avulla"
difficulty = "level-1"
tags = ["calibre", "calibre-web", "ldap", "logging", "nutzerverwaltung", "peertube", "ssl"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210402-nginx-reverse-proxy/index.fi.md"
+++
Synology Diskstation -käyttäjänä käytän monia palveluita Homelab-verkossani. Otan ohjelmistoja käyttöön Gitlabissa, dokumentoin tietoa Confluence-ohjelmassa ja luen teknisiä viitteitä Calibre-verkkopalvelimen kautta.
{{< gallery match="images/1/*.png" >}}
Kaikki verkkopalvelut kommunikoivat salatusti ja ne on suojattu keskitetyn käyttäjähallinnan avulla. Tänään näytän, miten suojasin Calibre-palveluni SSL-salauksella, käyttöoikeuksien kirjaamisella ja LDAP-käyttöoikeuksien rajoittamisella. Tässä opetuksessa tarvitaan ennakkotietoja "[Siistejä asioita Atlassianin kanssa: Käytä kaikkia Atlassianin työkaluja LDAP:n kanssa.]({{< ref "post/2021/march/20210321-atlassian-ldap" >}} "Siistejä asioita Atlassianin kanssa: Käytä kaikkia Atlassianin työkaluja LDAP:n kanssa.")" ja "[Suuria asioita konttien avulla: Calibren käyttäminen Docker Composen kanssa]({{< ref "post/2020/february/20200221-docker-Calibre-pro" >}} "Suuria asioita konttien avulla: Calibren käyttäminen Docker Composen kanssa")".
## Oma LDAP-palvelin
Kuten olen jo kirjoittanut, käytän keskitettyä openLDAP-palvelinta Docker-säiliössä. Olen myös luonut muutamia sovellusryhmiä.
{{< gallery match="images/2/*.png" >}}

## Suojaa turvaton sovellus käänteisellä välityspalvelimella
Koska Docker-kuva "linuxserver/calibre-web" ei tue SSL-salausta ja LDAP:tä, luon virtuaaliverkon nimeltä "calibreweb" ja asetan NGINX-käänteisvälityspalvelimen Calibre-palvelimen eteen. Docker Compose -tiedostoni näyttää tältä. Kaikki tulevat lokit tallennetaan log-hakemistoon ja itse allekirjoitetut varmenteet certs-hakemistoon.
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
Lisää hyödyllisiä Docker-kuvia kotikäyttöön löytyy [Dockerverse]({{< ref "dockerverse" >}} "Dockerverse").
## Nginxin konfigurointi
Tiedosto "default.conf" sisältää kaikki LDAP- ja salausmääritykset. URL-osoite, binddn, varmenteet, portit sekä salasana ja ryhmä on tietenkin mukautettava.
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
Jos nyt käynnistät asennuksen komennolla "docker-compose -f ...etc... up", näet myös kirjautuneiden käyttäjien käyttöoikeudet käyttöoikeuslokissa:
{{< gallery match="images/3/*.png" >}}
Koska LDAP-käyttäjät ovat vain vieraskäyttäjiä, vieraskäyttäjän oikeudet on määritettävä Calibrewebissä:
{{< gallery match="images/4/*.png" >}}
Käytän tätä asetusta seuraaville palveluille:* Videokirjasto (Peertube)* Kirjasto (Calibreweb)* Gitlab (CE ei tue ryhmiä, joten sinun on kirjauduttava sisään 2x.)
