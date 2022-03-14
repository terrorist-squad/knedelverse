+++
date = "2021-04-02"
title = "Great things with containers: making Docker services more secure with LDAP and NGINX"
difficulty = "level-1"
tags = ["calibre", "calibre-web", "ldap", "logging", "nutzerverwaltung", "peertube", "ssl"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/april/20210402-nginx-reverse-proxy/index.en.md"
+++
As a Synology Diskstation user, I run many services on my Homelab network. I deploy software in Gitlab, document knowledge in Confluence and read technical references via the Calibre web server.
{{< gallery match="images/1/*.png" >}}
All network services communicate encrypted and are secured via a central user management.Today I show how I secured my Calibre service with SSL encryption, access logging and LDAP access restriction. This tutorial requires prior knowledge from "[Cool things with Atlassian: Use all Atlassian tools with LDAP]({{< ref "post/2021/march/20210321-atlassian-ldap" >}} "Cool things with Atlassian: Use all Atlassian tools with LDAP")" and "[Great things with containers: running Calibre with Docker Compose]({{< ref "post/2020/february/20200221-docker-Calibre-pro" >}} "Great things with containers: running Calibre with Docker Compose")".
## My LDAP server
As I wrote before, I'm running a central openLDAP server in the Docker container. I have also created a few application groups.
{{< gallery match="images/2/*.png" >}}

## Secure insecure application with reverse proxy
Since the "linuxserver/calibre-web" Docker image does not support SSL encryption and LDAP, I create a virtual network called "calibreweb" and put a NGINX reverse proxy in front of the Calibre server.This is what my Docker Compose file looks like. The log directory is where all future access logs will be stored and the certs directory is where my self-signed certificates reside.
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
More useful Docker images for home use can be found in the [Dockerverse]({{< ref "dockerverse" >}} "Dockerverse").
## Nginx configuration
The "default.conf" file contains all LDAP and encryption configurations. Of course, the URL, binddn, certificates, ports and the password and group must be adjusted.
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
If you now start the setup with "docker-compose -f ...etc... up", you can also see the accesses of the logged in users in the access log:
{{< gallery match="images/3/*.png" >}}
Since the LDAP users are only guest users, guest user rights must be set in Calibreweb:
{{< gallery match="images/4/*.png" >}}
