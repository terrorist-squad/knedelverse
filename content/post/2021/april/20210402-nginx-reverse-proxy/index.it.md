+++
date = "2021-04-02"
title = "Grandi cose con i container: rendere i servizi Docker più sicuri con LDAP e NGINX"
difficulty = "level-1"
tags = ["calibre", "calibre-web", "ldap", "logging", "nutzerverwaltung", "peertube", "ssl"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210402-nginx-reverse-proxy/index.it.md"
+++
Come utente di Synology Diskstation, eseguo molti servizi sulla mia rete Homelab. Distribuisco software in Gitlab, documento le conoscenze in Confluence e leggo i riferimenti tecnici tramite il server web Calibre.
{{< gallery match="images/1/*.png" >}}
Tutti i servizi di rete comunicano in modo criptato e sono protetti tramite un'amministrazione centrale degli utenti. Oggi mostro come ho protetto il mio servizio Calibre con la crittografia SSL, la registrazione degli accessi e la restrizione di accesso LDAP. La conoscenza preliminare di "[Cose fantastiche con Atlassian: usare tutti gli strumenti Atlassian con LDAP]({{< ref "post/2021/march/20210321-atlassian-ldap" >}} "Cose fantastiche con Atlassian: usare tutti gli strumenti Atlassian con LDAP")" e "[Grandi cose con i container: eseguire Calibre con Docker Compose]({{< ref "post/2020/february/20200221-docker-Calibre-pro" >}} "Grandi cose con i container: eseguire Calibre con Docker Compose")" è richiesta per questo tutorial.
## Il mio server LDAP
Come ho già scritto, eseguo un server openLDAP centrale nel contenitore Docker. Ho anche creato alcuni gruppi di applicazioni.
{{< gallery match="images/2/*.png" >}}

## Proteggere l'applicazione insicura con il reverse proxy
Poiché l'immagine Docker "linuxserver/calibre-web" non supporta la crittografia SSL e LDAP, creo una rete virtuale chiamata "calibreweb" e metto un reverse proxy NGINX davanti al server Calibre. Questo è ciò che il mio file Docker Compose sembra. Tutti i futuri log di accesso sono memorizzati nella directory log e i miei certificati autofirmati sono nella directory certs.
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
Altre immagini Docker utili per uso domestico possono essere trovate nella [Dockerverse]({{< ref "dockerverse" >}} "Dockerverse").
## Configurazione di Nginx
Il file "default.conf" contiene tutte le configurazioni LDAP e di crittografia. Naturalmente, l'URL, il binddn, i certificati, le porte e la password e il gruppo devono essere regolati.
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
Se ora si avvia il setup con "docker-compose -f ...etc... up", si possono anche vedere gli accessi degli utenti loggati nel log di accesso:
{{< gallery match="images/3/*.png" >}}
Poiché gli utenti LDAP sono solo utenti ospiti, i diritti degli utenti ospiti devono essere impostati in Calibreweb:
{{< gallery match="images/4/*.png" >}}
