+++
date = "2021-04-05"
title = "Geweldige dingen met containers: eigen videoportaal met PeerTube"
difficulty = "level-1"
tags = ["diskstation", "peertube", "Synology", "video", "videoportal"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210405-docker-peertube/index.nl.md"
+++
Met Peertube kunt u uw eigen videoportaal maken. Vandaag laat ik zien hoe ik Peertube heb geïnstalleerd op mijn Synology disk station.
## Stap 1: Synology voorbereiden
Eerst moet de SSH-aanmelding op het DiskStation worden geactiveerd. Om dit te doen, ga naar het "Configuratiescherm" > "Terminal
{{< gallery match="images/1/*.png" >}}
Dan kunt u inloggen via "SSH", de opgegeven poort en het beheerderwachtwoord.
{{< gallery match="images/2/*.png" >}}
Ik log in via Terminal, winSCP of Putty en laat deze console open voor later.
## Stap 2: Docker map klaarmaken
Ik maak een nieuwe map aan genaamd "Peertube" in de Docker map.
{{< gallery match="images/3/*.png" >}}
Dan ga ik naar de Peertube directory en maak een nieuw bestand aan genaamd "peertube.yml" met de volgende inhoud. Voor de poort kan het voorste deel "9000:" worden aangepast. Het tweede volume bevat alle video's, afspeellijsten, thumbnails enz... en moet dus worden aangepast.
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
Dit bestand wordt gestart via Docker Compose:
{{< terminal >}}
sudo docker-compose -f compose-file-name.yml up -d

{{</ terminal >}}
Daarna kan ik mijn Peertube server oproepen met het IP van het diskstation en de toegewezen poort uit "Stap 2". Geweldig.
{{< gallery match="images/4/*.png" >}}
De gebruikersnaam is "root" en het wachtwoord is "password" (of stap 2 / PT_INITIAL_ROOT_PASSWORD).
## Thema-aanpassing
Het is heel eenvoudig om het uiterlijk van Peertube aan te passen. Om dit te doen, klik ik op "Beheer" > "Instellingen" en "Geavanceerde instellingen".
{{< gallery match="images/5/*.png" >}}
Daar heb ik in het CSS veld het volgende ingevuld:
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

## Rust-API
PeerTube heeft een uitgebreide en goed gedocumenteerde Rest API: https://docs.joinpeertube.org/api-rest-reference.html.
{{< gallery match="images/6/*.png" >}}
Zoeken naar video's is mogelijk met dit commando:
{{< terminal >}}
curl -s "http://pree-tube/api/v1search/videos?search=docker&languageOneOf=de"

{{</ terminal >}}
Authenticatie en een sessietoken zijn bijvoorbeeld vereist voor een upload:
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

## Mijn tip: Lees "Geweldige dingen met containers: Docker services veiliger maken met LDAP en NGINX".
