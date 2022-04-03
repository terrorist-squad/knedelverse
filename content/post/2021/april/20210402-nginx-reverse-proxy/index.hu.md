+++
date = "2021-04-02"
title = "Nagyszerű dolgok konténerekkel: a Docker szolgáltatások biztonságosabbá tétele LDAP és NGINX segítségével"
difficulty = "level-1"
tags = ["calibre", "calibre-web", "ldap", "logging", "nutzerverwaltung", "peertube", "ssl"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210402-nginx-reverse-proxy/index.hu.md"
+++
Synology Diskstation felhasználóként számos szolgáltatást futtatok a Homelab hálózatomon. Szoftvert telepítek a Gitlabban, dokumentálom a tudást a Confluence-ben, és műszaki referenciákat olvasok a Calibre webszerver segítségével.
{{< gallery match="images/1/*.png" >}}
Minden hálózati szolgáltatás titkosítva kommunikál, és központi felhasználói adminisztrációval van biztosítva. Ma bemutatom, hogyan biztosítottam a Calibre szolgáltatásomat SSL titkosítással, hozzáférési naplózással és LDAP hozzáférési korlátozással. Az "[Király dolgok az Atlassiannal: Használja az összes Atlassian eszközt LDAP-pal]({{< ref "post/2021/march/20210321-atlassian-ldap" >}} "Király dolgok az Atlassiannal: Használja az összes Atlassian eszközt LDAP-pal")" és "[Nagyszerű dolgok konténerekkel: Calibre futtatása Docker Compose-szal]({{< ref "post/2020/february/20200221-docker-Calibre-pro" >}} "Nagyszerű dolgok konténerekkel: Calibre futtatása Docker Compose-szal")" előzetes ismerete szükséges ehhez a bemutatóhoz.
## LDAP-kiszolgálóm
Mint már írtam, egy központi openLDAP szervert futtatok a Docker konténerben. Létrehoztam néhány alkalmazási csoportot is.
{{< gallery match="images/2/*.png" >}}

## Biztonságos nem biztonságos alkalmazás fordított proxyval
Mivel a "linuxserver/calibre-web" Docker image nem támogatja az SSL titkosítást és az LDAP-t, létrehozok egy "calibreweb" nevű virtuális hálózatot, és egy NGINX reverse proxy-t teszek a Calibre szerver elé. Így néz ki a Docker Compose fájlom. Az összes jövőbeli hozzáférési napló a log könyvtárban, az önaláírt tanúsítványaim pedig a certs könyvtárban vannak.
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
További hasznos Docker-képek otthoni használatra az [Dockerverse]({{< ref "dockerverse" >}} "Dockerverse").
## Nginx konfiguráció
A "default.conf" fájl tartalmazza az összes LDAP és titkosítási konfigurációt. Természetesen az URL-t, a binddn-t, a tanúsítványokat, a portokat, valamint a jelszót és a csoportot is ki kell igazítani.
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
Ha most a "docker-compose -f ...etc... up" paranccsal indítjuk el a telepítést, akkor a belépett felhasználók hozzáférései is láthatók a hozzáférési naplóban:
{{< gallery match="images/3/*.png" >}}
Mivel az LDAP-felhasználók csak vendégfelhasználók, a Calibrewebben be kell állítani a vendégfelhasználói jogokat:
{{< gallery match="images/4/*.png" >}}
Ezt a beállítást futtatom a következő szolgáltatásokhoz:* Videókönyvtár (Peertube)* Könyvtár (Calibreweb)* Gitlab (A CE nem támogatja a csoportokat, ezért 2x kell bejelentkezni)
