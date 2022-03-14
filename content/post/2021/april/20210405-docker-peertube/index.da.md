+++
date = "2021-04-05"
title = "Store ting med containere: Egen videoportal med PeerTube"
difficulty = "level-1"
tags = ["diskstation", "peertube", "Synology", "video", "videoportal"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/april/20210405-docker-peertube/index.da.md"
+++
Med Peertube kan du oprette din egen videoportal. I dag viser jeg, hvordan jeg installerede Peertube på min Synology diskstation.
## Trin 1: Forbered Synology
Først skal SSH-login være aktiveret på DiskStationen. Du kan gøre dette ved at gå til "Kontrolpanel" > "Terminal".
{{< gallery match="images/1/*.png" >}}
Derefter kan du logge ind via "SSH", den angivne port og administratoradgangskoden.
{{< gallery match="images/2/*.png" >}}
Jeg logger ind via Terminal, winSCP eller Putty og lader denne konsol være åben til senere.
## Trin 2: Forbered Docker-mappen
Jeg opretter en ny mappe med navnet "Peertube" i Docker-mappen.
{{< gallery match="images/3/*.png" >}}
Derefter går jeg ind i Peertube-mappen og opretter en ny fil med navnet "peertube.yml" med følgende indhold. For porten kan den forreste del "9000:" justeres. Det andet bind indeholder alle videoer, afspilningsliste, miniaturebilleder osv... og skal derfor tilpasses.
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
Denne fil startes via Docker Compose:
{{< terminal >}}
sudo docker-compose -f compose-file-name.yml up -d

{{</ terminal >}}
Derefter kan jeg ringe til min Peertube-server med diskstationens IP-nummer og den tildelte port fra "Trin 2". Fantastisk!
{{< gallery match="images/4/*.png" >}}
Brugernavnet er "root" og adgangskoden er "password" (eller trin 2 / PT_INITIAL_ROOT_PASSWORD).
## Tilpasning af temaer
Det er meget nemt at tilpasse Peertubes udseende. For at gøre dette klikker jeg på "Administration" > "Indstillinger" og "Avancerede indstillinger".
{{< gallery match="images/5/*.png" >}}
Der har jeg indtastet følgende i CSS-feltet:
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

## Rest API
PeerTube har en omfattende og veldokumenteret Rest API: https://docs.joinpeertube.org/api-rest-reference.html.
{{< gallery match="images/6/*.png" >}}
Det er muligt at søge efter videoer med denne kommando:
{{< terminal >}}
curl -s "http://pree-tube/api/v1search/videos?search=docker&languageOneOf=de"

{{</ terminal >}}
Der kræves f.eks. autentificering og et sessionstoken for at uploade en fil:
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

## Mit tip: Læs "Great things with containers: Making Docker services more secure with LDAP and NGINX".
