+++
date = "2021-04-05"
title = "Velike stvari s kontejnerji: Lasten video portal s PeerTube"
difficulty = "level-1"
tags = ["diskstation", "peertube", "Synology", "video", "videoportal"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210405-docker-peertube/index.sl.md"
+++
V Peertubu lahko ustvarite svoj lasten video portal. Danes bom pokazal, kako sem Peertube namestil na svojo diskovno postajo Synology.
## Korak 1: Pripravite Synology
Najprej je treba na napravi DiskStation aktivirati prijavo SSH. To storite tako, da greste v "Nadzorna plošča" > "Terminal".
{{< gallery match="images/1/*.png" >}}
Nato se lahko prijavite prek SSH, določenih vrat in skrbniškega gesla.
{{< gallery match="images/2/*.png" >}}
Prijavim se prek terminala, winSCP ali Puttyja in pustim to konzolo odprto za pozneje.
## Korak 2: Pripravite mapo Docker
V imeniku programa Docker ustvarim nov imenik z imenom "Peertube".
{{< gallery match="images/3/*.png" >}}
Nato grem v imenik Peertube in ustvarim novo datoteko z imenom "peertube.yml" z naslednjo vsebino. Za vrata lahko prilagodite sprednji del "9000:". Drugi zvezek vsebuje vse videoposnetke, seznam predvajanja, sličice itd., zato ga je treba prilagoditi.
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
Ta datoteka se zažene prek programa Docker Compose:
{{< terminal >}}
sudo docker-compose -f compose-file-name.yml up -d

{{</ terminal >}}
Nato lahko pokličem strežnik Peertube z IP diskovne postaje in dodeljenimi vrati iz koraka 2. Odlično!
{{< gallery match="images/4/*.png" >}}
Uporabniško ime je "root", geslo pa "password" (ali korak 2 / PT_INITIAL_ROOT_PASSWORD).
## Prilagoditev teme
Videz Peertube je zelo enostavno prilagoditi. To storim tako, da kliknem na "Administracija" > "Nastavitve" in "Napredne nastavitve".
{{< gallery match="images/5/*.png" >}}
Tam sem v polje CSS vnesel naslednje:
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

## API za počitek
PeerTube ima obsežen in dobro dokumentiran vmesnik API Rest: https://docs.joinpeertube.org/api-rest-reference.html.
{{< gallery match="images/6/*.png" >}}
S tem ukazom lahko iščete videoposnetke:
{{< terminal >}}
curl -s "http://pree-tube/api/v1search/videos?search=docker&languageOneOf=de"

{{</ terminal >}}
Za prenos sta na primer potrebna avtentikacija in žeton seje:
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

## Moj nasvet: Preberite članek "Velike stvari s kontejnerji: večja varnost storitev Docker z LDAP in NGINX".
