+++
date = "2021-04-02"
title = "Großartiges mit Containern: Docker-Dienste mit LDAP und NGINX sicherer machen"
difficulty = "level-1"
tags = ["calibre", "calibre-web", "ldap", "logging", "nutzerverwaltung", "peertube", "ssl"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/april/20210402-nginx-reverse-proxy/index.de.md"
+++

Als Synology-Diskstation-Nutzer, betreibe ich viele Dienste in meinem Homelab-Netzwerk. Ich deploye Software in Gitlab, dokumentiere Wissen in Confluence und lese Fachreferenzen über den Calibre-Webserver. 
{{< gallery match="images/1/*.png" >}}

Alle Netzwerk-Dienste kommunizieren verschlüsselt und sind über eine zentrale Nutzerverwaltung abgesichert.

Heute zeige ich, wie ich meinen Calibre-Dienst mit SSL-Verschlüsslung, Access-Logging und LDAP-Zugangsbeschränkung abgesichert habe. Für dieses Tutorial wird Vorwissen aus „[Cooles mit Atlassian: Alle Atlassian – Tools mit LDAP nutzen]({{< ref "post/2021/march/20210321-atlassian-ldap" >}} "Cooles mit Atlassian: Alle Atlassian – Tools mit LDAP nutzen")“ und „[Großartiges mit Containern: Calibre mit Docker-Compose betreiben]({{< ref "post/2020/february/20200221-docker-Calibre-pro" >}} "Großartiges mit Containern: Calibre mit Docker-Compose betreiben")“ benötigt.




## Mein LDAP-Server
Wie ich bereits geschrieben habe, betreibe ich einen zentralen openLDAP-Server im Docker-Container. Außerdem habe ich mir noch ein paar Applikations-Gruppen angelegt.
{{< gallery match="images/2/*.png" >}}

## Unsichere Applikation mit Reverse-Proxy absichern
Da das „linuxserver/calibre-web“-Docker-Image keine SSL-Verschlüsslung und kein LDAP unterstützt, erzeuge ich ein virtuelles Netzwerk namens „calibreweb“ und schalte einen NGINX-Reverse-Proxy vor dem Calibre-Server.

So sieht meine Docker-Compose-Datei aus. Im Log-Verzeichnis werden alle zukünftigen Access-Logs abgelegt und im Certs-Verzeichnis liegen meine selbstsignierten Zertifikate.
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
Weitere nützliche Docker-Images für den Heimgebrauch finden Sie im [Dockerverse]({{< ref "dockerverse" >}} "Dockerverse").

## Nginx-Konfiguration

Die „default.conf"-Datei enthält alle LDAP- und Verschlüsselungs-Konfigurationen. Selbstverständlich muss die URL, binddn, Zertifikate, ports und das Passwort und die Gruppe angepasst werden.
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

Wenn man nun das Setup mit „docker-compose -f …usw… up“ startet, kann man auch die Zugriffe der eingeloggten Nutzer im Access-Log sehen:
{{< gallery match="images/3/*.png" >}}

Da die LDAP-Nutzer nur Gast-Nutzer sind, müssen Gast-Nutzerrechte in Calibreweb gesetzt werden:
{{< gallery match="images/4/*.png" >}}

Ich betreibe diese Setup für folgende Dienste:

* Videothek (Peertube)
* Bibliothek (Calibreweb)
* Gitlab (Die CE-unterstützt keine Gruppen, darum muss man sich 2x einloggen)