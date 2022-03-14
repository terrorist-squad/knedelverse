+++
date = "2021-04-05"
title = "Lucruri grozave cu containere: propriul portal video cu PeerTube"
difficulty = "level-1"
tags = ["diskstation", "peertube", "Synology", "video", "videoportal"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/april/20210405-docker-peertube/index.ro.md"
+++
Cu Peertube vă puteți crea propriul portal video. Astăzi vă arăt cum am instalat Peertube pe stația mea de discuri Synology.
## Pasul 1: Pregătiți Synology
În primul rând, conectarea SSH trebuie să fie activată pe DiskStation. Pentru a face acest lucru, mergeți la "Control Panel" > "Terminal".
{{< gallery match="images/1/*.png" >}}
Apoi vă puteți conecta prin "SSH", portul specificat și parola de administrator.
{{< gallery match="images/2/*.png" >}}
Mă conectez prin Terminal, winSCP sau Putty și las această consolă deschisă pentru mai târziu.
## Pasul 2: Pregătiți dosarul Docker
Creez un nou director numit "Peertube" în directorul Docker.
{{< gallery match="images/3/*.png" >}}
Apoi, mă duc în directorul Peertube și creez un nou fișier numit "peertube.yml" cu următorul conținut. Pentru port, partea frontală "9000:" poate fi ajustată. Al doilea volum conține toate videoclipurile, lista de redare, miniaturi etc... și, prin urmare, trebuie adaptat.
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
Acest fișier este pornit prin Docker Compose:
{{< terminal >}}
sudo docker-compose -f compose-file-name.yml up -d

{{</ terminal >}}
După aceea, pot apela serverul meu Peertube cu IP-ul stației de disc și portul atribuit de la "Pasul 2". Grozav!
{{< gallery match="images/4/*.png" >}}
Numele de utilizator este "root", iar parola este "password" (sau pasul 2 / PT_INITIAL_ROOT_PASSWORD).
## Personalizarea temei
Este foarte ușor să personalizați aspectul Peertube. Pentru a face acest lucru, fac clic pe "Administrare" > "Setări" și "Setări avansate".
{{< gallery match="images/5/*.png" >}}
Acolo am introdus următoarele în câmpul CSS:
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
PeerTube are un API Rest extins și bine documentat: https://docs.joinpeertube.org/api-rest-reference.html.
{{< gallery match="images/6/*.png" >}}
Căutarea de videoclipuri este posibilă cu ajutorul acestei comenzi:
{{< terminal >}}
curl -s "http://pree-tube/api/v1search/videos?search=docker&languageOneOf=de"

{{</ terminal >}}
De exemplu, pentru o încărcare sunt necesare autentificarea și un token de sesiune:
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

## Sfatul meu: Citiți "Lucruri grozave cu containere: cum să faceți serviciile Docker mai sigure cu LDAP și NGINX".
