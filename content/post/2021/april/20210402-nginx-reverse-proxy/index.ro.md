+++
date = "2021-04-02"
title = "Lucruri grozave cu containere: făcând serviciile Docker mai sigure cu LDAP și NGINX"
difficulty = "level-1"
tags = ["calibre", "calibre-web", "ldap", "logging", "nutzerverwaltung", "peertube", "ssl"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210402-nginx-reverse-proxy/index.ro.md"
+++
În calitate de utilizator Synology Diskstation, utilizez multe servicii în rețeaua mea Homelab. Implementez software în Gitlab, documentez cunoștințele în Confluence și citesc referințe tehnice prin intermediul serverului web Calibre.
{{< gallery match="images/1/*.png" >}}
Toate serviciile de rețea comunică în mod criptat și sunt securizate prin intermediul unei administrații centrale a utilizatorilor. Astăzi vă arăt cum am securizat serviciul Calibre cu criptare SSL, logare a accesului și restricție de acces LDAP. Pentru acest tutorial sunt necesare cunoștințe prealabile din "[Lucruri interesante cu Atlassian: Utilizați toate instrumentele Atlassian cu LDAP]({{< ref "post/2021/march/20210321-atlassian-ldap" >}} "Lucruri interesante cu Atlassian: Utilizați toate instrumentele Atlassian cu LDAP")" și "[Lucruri grozave cu containere: Rularea Calibre cu Docker Compose]({{< ref "post/2020/february/20200221-docker-Calibre-pro" >}} "Lucruri grozave cu containere: Rularea Calibre cu Docker Compose")".
## Serverul meu LDAP
După cum am scris deja, în containerul Docker rulează un server central openLDAP. Am creat, de asemenea, câteva grupuri de aplicații.
{{< gallery match="images/2/*.png" >}}

## Asigurați aplicația nesigură cu proxy invers
Deoarece imaginea Docker "linuxserver/calibre-web" nu acceptă criptarea SSL și LDAP, creez o rețea virtuală numită "calibreweb" și pun un proxy invers NGINX în fața serverului Calibre. Iată cum arată fișierul meu Docker Compose. Toate jurnalele de acces viitoare sunt stocate în directorul log, iar certificatele mele autofirmate sunt în directorul certs.
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
Mai multe imagini Docker utile pentru uz casnic pot fi găsite în secțiunea [Dockerverse]({{< ref "dockerverse" >}} "Dockerverse").
## Configurația Nginx
Fișierul "default.conf" conține toate configurațiile LDAP și de criptare. Desigur, trebuie ajustate URL, binddn, certificatele, porturile, precum și parola și grupul.
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
Dacă porniți acum configurarea cu "docker-compose -f ...etc... up", puteți vedea și accesările utilizatorilor conectați în jurnalul de acces:
{{< gallery match="images/3/*.png" >}}
Deoarece utilizatorii LDAP sunt doar utilizatori invitați, drepturile de utilizator invitat trebuie să fie setate în Calibreweb:
{{< gallery match="images/4/*.png" >}}
