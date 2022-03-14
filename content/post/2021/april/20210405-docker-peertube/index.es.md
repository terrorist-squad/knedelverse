+++
date = "2021-04-05"
title = "Cosas grandes con contenedores: Portal de vídeo propio con PeerTube"
difficulty = "level-1"
tags = ["diskstation", "peertube", "Synology", "video", "videoportal"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/april/20210405-docker-peertube/index.es.md"
+++
Con Peertube puedes crear tu propio portal de vídeos. Hoy muestro cómo he instalado Peertube en mi estación de disco Synology.
## Paso 1: Preparar el Synology
En primer lugar, se debe activar el inicio de sesión SSH en el DiskStation. Para ello, vaya al "Panel de control" > "Terminal
{{< gallery match="images/1/*.png" >}}
A continuación, puede iniciar la sesión a través de "SSH", el puerto especificado y la contraseña de administrador.
{{< gallery match="images/2/*.png" >}}
Me conecto a través de Terminal, winSCP o Putty y dejo esta consola abierta para más tarde.
## Paso 2: Preparar la carpeta Docker
Creo un nuevo directorio llamado "Peertube" en el directorio Docker.
{{< gallery match="images/3/*.png" >}}
Luego voy al directorio de Peertube y creo un nuevo archivo llamado "peertube.yml" con el siguiente contenido. Para el puerto, se puede ajustar la parte frontal "9000:". El segundo volumen contiene todos los vídeos, la lista de reproducción, las miniaturas, etc., por lo que debe adaptarse.
```
version: "3.7"

services:
  peertube:
    image: chocobozzz/peertube:contain-buster
    container_name: peertube_peertube
    ports:
       - "9000:9000"
    volumes:
      - ./config:/config
      - ./videos:/data
    environment:
      - TZ="Europe/Berlin"
      - PT_INITIAL_ROOT_PASSWORD=password
      - PEERTUBE_WEBSERVER_HOSTNAME=ip
      - PEERTUBE_WEBSERVER_PORT=port
      - PEERTUBE_WEBSERVER_HTTPS=false
      - PEERTUBE_DB_USERNAME=peertube
      - PEERTUBE_DB_PASSWORD=peertube
      - PEERTUBE_DB_HOSTNAME=postgres
      - POSTGRES_DB=peertube
      - POSTGRES_USER=postgres
      - POSTGRES_PASSWORD=postgres
      - PEERTUBE_REDIS_HOSTNAME=redis
      - PEERTUBE_ADMIN_EMAIL=himself@christian-knedel.de
    depends_on:
      - postgres
      - redis
    restart: "always"
    networks:
      - peertube

  postgres:
    restart: always
    image: postgres:12
    container_name: peertube_postgres
    volumes:
      - ./postgresql:/var/lib/postgresql/data
    environment:
      - POSTGRES_USER=peertube
      - POSTGRES_PASSWORD=peertube
      - POSTGRES_DB=peertube
    networks:
      - peertube

  redis:
    image: redis:4-alpine
    container_name: peertube_redis
    volumes:
      - ./redis:/data
    restart: "always"
    networks:
      - peertube
    expose:
      - "6379"

networks:
  peertube:

```
Este archivo se inicia a través de Docker Compose:
{{< terminal >}}
sudo docker-compose -f compose-file-name.yml up -d

{{</ terminal >}}
Después, puedo llamar a mi servidor Peertube con la IP de la estación de disco y el puerto asignado desde el "Paso 2". ¡Genial!
{{< gallery match="images/4/*.png" >}}
El nombre de usuario es "root" y la contraseña es "password" (o paso 2 / PT_INITIAL_ROOT_PASSWORD).
## Personalización del tema
Es muy fácil personalizar la apariencia de Peertube. Para ello, hago clic en "Administración" > "Configuración" y "Configuración avanzada".
{{< gallery match="images/5/*.png" >}}
Allí he introducido lo siguiente en el campo CSS:
```
body#custom-css {
--mainColor: #3598dc;
--mainHoverColor: #3598dc;
--mainBackgroundColor: #FAFAFA;
--mainForegroundColor: #888888;
--menuBackgroundColor: #f5f5f5;
--menuForegroundColor: #888888;
--submenuColor: #fff;
--inputColor: #fff;
--inputPlaceholderColor: #898989;
}

```

## API de descanso
PeerTube cuenta con una extensa y bien documentada API Rest: https://docs.joinpeertube.org/api-rest-reference.html.
{{< gallery match="images/6/*.png" >}}
La búsqueda de vídeos es posible con este comando:
{{< terminal >}}
curl -s "http://pree-tube/api/v1search/videos?search=docker&languageOneOf=de"

{{</ terminal >}}
La autenticación y un token de sesión son necesarios para una carga, por ejemplo:
```
#!/bin/bash
USERNAME="user"
PASSWORD="password"
API_PATH="http://peertube-adresse/api/v1"

client_id=$(curl -s "$API_PATH/oauth-clients/local" | jq -r ".client_id")
client_secret=$(curl -s "$API_PATH/oauth-clients/local" | jq -r ".client_secret")
token=$(curl -s "$API_PATH/users/token" \
  --data client_id="$client_id" \
  --data client_secret="$client_secret" \
  --data grant_type=password \
  --data response_type=code \
  --data username="$USERNAME" \
  --data password="$PASSWORD" \
  | jq -r ".access_token")

curl -s '$API_PATH/videos/upload'-H 'Authorization: Bearer $token' --max-time 11600 --form videofile=@'/scripte/output.mp4' --form name='mein upload' 

```

## Mi consejo: Lea "Grandes cosas con contenedores: hacer más seguros los servicios Docker con LDAP y NGINX".
