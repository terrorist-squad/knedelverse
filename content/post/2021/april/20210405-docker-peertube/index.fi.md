+++
date = "2021-04-05"
title = "Suuria asioita säiliöillä: Oma videoportaali PeerTube:lla"
difficulty = "level-1"
tags = ["diskstation", "peertube", "Synology", "video", "videoportal"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/april/20210405-docker-peertube/index.fi.md"
+++
Peertuben avulla voit luoda oman videoportaalin. Tänään näytän, miten asensin Peertuben Synology-levyasemaani.
## Vaihe 1: Synologyn valmistelu
Ensin SSH-kirjautuminen on aktivoitava DiskStationissa. Tee tämä menemällä "Ohjauspaneeli" > "Pääte" > "Pääte".
{{< gallery match="images/1/*.png" >}}
Tämän jälkeen voit kirjautua sisään SSH:n, määritetyn portin ja järjestelmänvalvojan salasanan kautta.
{{< gallery match="images/2/*.png" >}}
Kirjaudun sisään terminaalin, winSCP:n tai Puttyn kautta ja jätän tämän konsolin auki myöhempää käyttöä varten.
## Vaihe 2: Valmistele Docker-kansio
Luon Docker-hakemistoon uuden hakemiston nimeltä "Peertube".
{{< gallery match="images/3/*.png" >}}
Sitten menen Peertube-hakemistoon ja luon uuden tiedoston nimeltä "peertube.yml", jonka sisältö on seuraava. Portin etuosaa "9000:" voidaan säätää. Toinen osa sisältää kaikki videot, soittolistan, pikkukuvat jne... ja sitä on siksi mukautettava.
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
Tämä tiedosto käynnistetään Docker Composen kautta:
{{< terminal >}}
sudo docker-compose -f compose-file-name.yml up -d

{{</ terminal >}}
Tämän jälkeen voin soittaa Peertube-palvelimelle levyaseman IP-osoitteella ja vaiheessa 2 määritetyllä portilla. Hienoa!
{{< gallery match="images/4/*.png" >}}
Käyttäjänimi on "root" ja salasana "password" (tai vaihe 2 / PT_INITIAL_ROOT_PASSWORD).
## Teeman mukauttaminen
Peertuben ulkoasua on erittäin helppo muokata. Tätä varten napsautan "Hallinta" > "Asetukset" ja "Lisäasetukset".
{{< gallery match="images/5/*.png" >}}
Siellä olen syöttänyt CSS-kenttään seuraavat tiedot:
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
PeerTubella on laaja ja hyvin dokumentoitu Rest API: https://docs.joinpeertube.org/api-rest-reference.html.
{{< gallery match="images/6/*.png" >}}
Videoiden etsiminen on mahdollista tällä komennolla:
{{< terminal >}}
curl -s "http://pree-tube/api/v1search/videos?search=docker&languageOneOf=de"

{{</ terminal >}}
Esimerkiksi lataaminen edellyttää tunnistautumista ja istuntotunnusta:
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

## Vinkkini: Lue "Suuria asioita konteilla: Docker-palveluiden turvaaminen LDAP:n ja NGINX:n avulla".
