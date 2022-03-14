+++
date = "2021-04-05"
title = "Veľké veci s kontajnermi: Vlastný videoportál s PeerTube"
difficulty = "level-1"
tags = ["diskstation", "peertube", "Synology", "video", "videoportal"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210405-docker-peertube/index.sk.md"
+++
Pomocou služby Peertube si môžete vytvoriť vlastný videoportál. Dnes ukážem, ako som nainštaloval Peertube na svoju diskovú stanicu Synology.
## Krok 1: Príprava spoločnosti Synology
Najprv je potrebné aktivovať prihlásenie SSH na zariadení DiskStation. Ak to chcete urobiť, prejdite na "Ovládací panel" > "Terminál".
{{< gallery match="images/1/*.png" >}}
Potom sa môžete prihlásiť cez "SSH", zadaný port a heslo správcu.
{{< gallery match="images/2/*.png" >}}
Prihlásim sa cez terminál, winSCP alebo Putty a túto konzolu nechám otvorenú na neskôr.
## Krok 2: Príprava priečinka Docker
V adresári Docker vytvorím nový adresár s názvom "Peertube".
{{< gallery match="images/3/*.png" >}}
Potom prejdem do adresára Peertube a vytvorím nový súbor s názvom "peertube.yml" s nasledujúcim obsahom. Pre port je možné nastaviť prednú časť "9000:". Druhý zväzok obsahuje všetky videá, zoznamy skladieb, miniatúry atď., a preto sa musí prispôsobiť.
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
Tento súbor sa spúšťa prostredníctvom nástroja Docker Compose:
{{< terminal >}}
sudo docker-compose -f compose-file-name.yml up -d

{{</ terminal >}}
Potom môžem zavolať svoj server Peertube pomocou IP adresy diskovej stanice a priradeného portu z kroku 2. Skvelé!
{{< gallery match="images/4/*.png" >}}
Používateľské meno je "root" a heslo je "password" (alebo krok 2 / PT_INITIAL_ROOT_PASSWORD).
## Prispôsobenie témy
Vzhľad Peertube sa dá veľmi ľahko prispôsobiť. Ak to chcete urobiť, kliknite na "Administrácia" > "Nastavenia" a "Rozšírené nastavenia".
{{< gallery match="images/5/*.png" >}}
Tam som do poľa CSS zadal nasledujúce údaje:
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

## Rozhranie API pre odpočinok
PeerTube má rozsiahle a dobre zdokumentované Rest API: https://docs.joinpeertube.org/api-rest-reference.html.
{{< gallery match="images/6/*.png" >}}
Pomocou tohto príkazu je možné vyhľadávať videá:
{{< terminal >}}
curl -s "http://pree-tube/api/v1search/videos?search=docker&languageOneOf=de"

{{</ terminal >}}
Napríklad pri odosielaní sa vyžaduje overenie a token relácie:
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

## Môj tip: Prečítajte si článok "Veľké veci s kontajnermi: zvýšenie bezpečnosti služieb Docker pomocou LDAP a NGINX".
