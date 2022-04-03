+++
date = "2021-04-05"
title = "Nagyszerű dolgok konténerekkel: Saját videoportál a PeerTube segítségével"
difficulty = "level-1"
tags = ["diskstation", "peertube", "Synology", "video", "videoportal"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210405-docker-peertube/index.hu.md"
+++
A Peertube segítségével létrehozhatja saját videoportálját. Ma megmutatom, hogyan telepítettem a Peertube-ot a Synology lemezállomásomra.
## 1. lépés: A Synology előkészítése
Először is aktiválni kell az SSH bejelentkezést a DiskStationön. Ehhez menjen a "Vezérlőpult" > "Terminál" > "Terminál" menüpontba.
{{< gallery match="images/1/*.png" >}}
Ezután bejelentkezhet az "SSH"-n keresztül, a megadott porton és a rendszergazdai jelszóval.
{{< gallery match="images/2/*.png" >}}
Terminal, winSCP vagy Putty segítségével jelentkezem be, és ezt a konzolt későbbre nyitva hagyom.
## 2. lépés: Docker mappa előkészítése
Létrehozok egy új könyvtárat "Peertube" néven a Docker könyvtárban.
{{< gallery match="images/3/*.png" >}}
Ezután bemegyek a Peertube könyvtárba, és létrehozok egy új fájlt "peertube.yml" néven a következő tartalommal. A porthoz a "9000:" elülső rész állítható be. A második kötet tartalmazza az összes videót, lejátszási listát, miniatűröket stb..., és ezért adaptálni kell.
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
Ez a fájl a Docker Compose segítségével indul:
{{< terminal >}}
sudo docker-compose -f compose-file-name.yml up -d

{{</ terminal >}}
Ezután a Peertube-kiszolgálót a lemezállomás IP-címével és a "2. lépésből" kiosztott porttal tudom hívni. Nagyszerű!
{{< gallery match="images/4/*.png" >}}
A felhasználónév "root", a jelszó pedig "password" (vagy a 2. lépés / PT_INITIAL_ROOT_PASSWORD).
## Téma testreszabása
A Peertube megjelenése nagyon könnyen testre szabható. Ehhez az "Adminisztráció" > "Beállítások" és a "Speciális beállítások" menüpontra kattintok.
{{< gallery match="images/5/*.png" >}}
Ott a CSS mezőbe a következőket írtam be:
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

## Pihenő API
A PeerTube kiterjedt és jól dokumentált Rest API-val rendelkezik: https://docs.joinpeertube.org/api-rest-reference.html.
{{< gallery match="images/6/*.png" >}}
A videók keresése ezzel a paranccsal lehetséges:
{{< terminal >}}
curl -s "http://pree-tube/api/v1search/videos?search=docker&languageOneOf=de"

{{</ terminal >}}
A feltöltéshez például hitelesítésre és munkamenet-tokenre van szükség:
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

## Tippem: Olvassa el a "Nagyszerű dolgok konténerekkel: a Docker-szolgáltatások biztonságosabbá tétele az LDAP és az NGINX segítségével" című részt.
A Peertube-omat fordított proxyval futtatom. Ez azt jelenti, hogy csak LDAP-felhasználók férhetnek hozzá ehhez a szolgáltatáshoz. Ezt a beállítást az "[Nagyszerű dolgok konténerekkel: a Docker szolgáltatások biztonságosabbá tétele LDAP és NGINX segítségével]({{< ref "post/2021/april/20210402-nginx-reverse-proxy" >}} "Nagyszerű dolgok konténerekkel: a Docker szolgáltatások biztonságosabbá tétele LDAP és NGINX segítségével")" alatt dokumentáltam.
