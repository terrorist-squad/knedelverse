+++
date = "2021-04-02"
title = "Geweldige dingen met containers: Docker-services veiliger maken met LDAP en NGINX"
difficulty = "level-1"
tags = ["calibre", "calibre-web", "ldap", "logging", "nutzerverwaltung", "peertube", "ssl"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210402-nginx-reverse-proxy/index.nl.md"
+++
Als Synology Diskstation gebruiker, draai ik veel diensten op mijn Homelab netwerk. Ik implementeer software in Gitlab, documenteer kennis in Confluence en lees technische referenties via de Calibre webserver.
{{< gallery match="images/1/*.png" >}}
Alle netwerkdiensten communiceren versleuteld en zijn beveiligd via een centraal gebruikersbeheer. Vandaag laat ik zien hoe ik mijn Calibre dienst heb beveiligd met SSL versleuteling, toegang logging en LDAP toegangsbeperking. Voorkennis van "[Leuke dingen met Atlassian: Gebruik alle Atlassian tools met LDAP]({{< ref "post/2021/march/20210321-atlassian-ldap" >}} "Leuke dingen met Atlassian: Gebruik alle Atlassian tools met LDAP")" en "[Geweldige dingen met containers: Calibre draaien met Docker Compose]({{< ref "post/2020/february/20200221-docker-Calibre-pro" >}} "Geweldige dingen met containers: Calibre draaien met Docker Compose")" is vereist voor deze tutorial.
## Mijn LDAP-server
Zoals ik al geschreven heb, draai ik een centrale openLDAP server in de Docker container. Ik heb ook een paar toepassingsgroepen gemaakt.
{{< gallery match="images/2/*.png" >}}

## Onveilige toepassing beveiligen met omgekeerde proxy
Aangezien het "linuxserver/calibre-web" Docker image geen SSL encryptie en LDAP ondersteunt, maak ik een virtueel netwerk aan genaamd "calibreweb" en zet een NGINX reverse proxy voor de Calibre server. Dit is hoe mijn Docker Compose bestand eruit ziet. Alle toekomstige toegangs logs worden opgeslagen in de log directory en mijn zelf-ondertekende certificaten staan in de certs directory.
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
Meer nuttige Docker images voor thuisgebruik zijn te vinden in de [Dockerverse]({{< ref "dockerverse" >}} "Dockerverse").
## Nginx configuratie
Het bestand "default.conf" bevat alle LDAP- en coderingsconfiguraties. Natuurlijk moeten de URL, binddn, certificaten, poorten en het wachtwoord en de groep worden aangepast.
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
Als je nu de setup start met "docker-compose -f ...etc... up", kun je ook de toegangen van de ingelogde gebruikers zien in het toegangslogboek:
{{< gallery match="images/3/*.png" >}}
Omdat de LDAP-gebruikers alleen gastgebruikers zijn, moeten gastgebruikersrechten worden ingesteld in Calibreweb:
{{< gallery match="images/4/*.png" >}}
Ik gebruik deze setup voor de volgende diensten:* Video bibliotheek (Peertube)* Bibliotheek (Calibreweb)* Gitlab (De CE ondersteunt geen groepen, dus je moet 2x inloggen)
