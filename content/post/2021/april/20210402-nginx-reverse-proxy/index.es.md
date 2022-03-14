+++
date = "2021-04-02"
title = "Grandes cosas con los contenedores: hacer más seguros los servicios de Docker con LDAP y NGINX"
difficulty = "level-1"
tags = ["calibre", "calibre-web", "ldap", "logging", "nutzerverwaltung", "peertube", "ssl"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/april/20210402-nginx-reverse-proxy/index.es.md"
+++
Como usuario de Synology Diskstation, ejecuto muchos servicios en mi red Homelab. Despliego software en Gitlab, documento conocimientos en Confluence y leo referencias técnicas a través del servidor web Calibre.
{{< gallery match="images/1/*.png" >}}
Todos los servicios de red se comunican de forma encriptada y se aseguran a través de una administración central de usuarios. Hoy muestro cómo he asegurado mi servicio Calibre con encriptación SSL, registro de acceso y restricción de acceso LDAP. Para este tutorial se requieren conocimientos previos de "[Cosas geniales con Atlassian: Utilizar todas las herramientas de Atlassian con LDAP]({{< ref "post/2021/march/20210321-atlassian-ldap" >}} "Cosas geniales con Atlassian: Utilizar todas las herramientas de Atlassian con LDAP")" y "[Grandes cosas con contenedores: ejecutar Calibre con Docker Compose]({{< ref "post/2020/february/20200221-docker-Calibre-pro" >}} "Grandes cosas con contenedores: ejecutar Calibre con Docker Compose")".
## Mi servidor LDAP
Como ya he escrito, ejecuto un servidor central openLDAP en el contenedor Docker. También he creado algunos grupos de aplicaciones.
{{< gallery match="images/2/*.png" >}}

## Asegurar una aplicación insegura con un proxy inverso
Como la imagen Docker "linuxserver/calibre-web" no soporta encriptación SSL ni LDAP, creo una red virtual llamada "calibreweb" y pongo un proxy inverso NGINX delante del servidor Calibre. Este es el aspecto de mi archivo Docker Compose. Todos los registros de acceso futuros se almacenan en el directorio log y mis certificados autofirmados están en el directorio certs.
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
Se pueden encontrar más imágenes Docker útiles para uso doméstico en la página web [Dockerverse]({{< ref "dockerverse" >}} "Dockerverse").
## Configuración de Nginx
El archivo "default.conf" contiene todas las configuraciones de LDAP y encriptación. Por supuesto, hay que ajustar la URL, el binddn, los certificados, los puertos y la contraseña y el grupo.
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
Si ahora inicias la configuración con "docker-compose -f ...etc... up", también puedes ver los accesos de los usuarios conectados en el registro de acceso:
{{< gallery match="images/3/*.png" >}}
Dado que los usuarios de LDAP son sólo usuarios invitados, los derechos de los usuarios invitados deben establecerse en Calibreweb:
{{< gallery match="images/4/*.png" >}}
