+++
date = "2021-04-02"
title = "De grandes choses avec les conteneurs : sécuriser les services Docker avec LDAP et NGINX"
difficulty = "level-1"
tags = ["calibre", "calibre-web", "ldap", "logging", "nutzerverwaltung", "peertube", "ssl"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/april/20210402-nginx-reverse-proxy/index.fr.md"
+++
En tant qu'utilisateur de Synology Diskstation, j'exploite de nombreux services sur mon réseau Homelab. Je déploie des logiciels dans Gitlab, je documente des connaissances dans Confluence et je lis des références professionnelles via le serveur web Calibre.
{{< gallery match="images/1/*.png" >}}
Aujourd'hui, je montre comment j'ai sécurisé mon service Calibre avec un cryptage SSL, une journalisation des accès et une restriction d'accès LDAP. Pour ce tutoriel, des connaissances préalables de "[Cooles avec Atlassian : utiliser tous les outils Atlassian avec LDAP]({{< ref "post/2021/march/20210321-atlassian-ldap" >}} "Cooles avec Atlassian : utiliser tous les outils Atlassian avec LDAP")" et "[De grandes choses avec les conteneurs : faire fonctionner Calibre avec Docker-Compose]({{< ref "post/2020/february/20200221-docker-Calibre-pro" >}} "De grandes choses avec les conteneurs : faire fonctionner Calibre avec Docker-Compose")" sont nécessaires.
## Mon serveur LDAP
Comme je l'ai déjà écrit, j'exploite un serveur openLDAP central dans un conteneur Docker. J'ai également créé quelques groupes d'applications.
{{< gallery match="images/2/*.png" >}}

## Sécuriser une application non sécurisée avec un reverse proxy
Comme l'image docker "linuxserver/calibre-web" ne supporte pas le cryptage SSL ni LDAP, je crée un réseau virtuel appelé "calibreweb" et je place un proxy inverse NGINX devant le serveur Calibre.Voici à quoi ressemble mon fichier composite Docker. Tous les futurs journaux d'accès sont stockés dans le répertoire Log et mes certificats auto-signés se trouvent dans le répertoire Certs.
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
Vous trouverez d'autres images Docker utiles pour une utilisation à domicile dans le [Dockerverse]({{< ref "dockerverse" >}} "Dockerverse").
## Configuration de Nginx
Le fichier "default.conf" contient toutes les configurations LDAP et de cryptage. Il faut bien sûr adapter l'URL, binddn, les certificats, les ports et le mot de passe et le groupe.
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
Si l'on démarre maintenant le setup avec "docker-compose -f ...etc... up", on peut également voir les accès des utilisateurs connectés dans le journal d'accès :
{{< gallery match="images/3/*.png" >}}
Comme les utilisateurs LDAP ne sont que des utilisateurs invités, les droits d'utilisateur invité doivent être définis dans Calibreweb :
{{< gallery match="images/4/*.png" >}}
