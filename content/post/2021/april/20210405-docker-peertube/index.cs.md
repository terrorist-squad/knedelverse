+++
date = "2021-04-05"
title = "Velké věci s kontejnery: Vlastní videoportál s PeerTube"
difficulty = "level-1"
tags = ["diskstation", "peertube", "Synology", "video", "videoportal"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210405-docker-peertube/index.cs.md"
+++
Pomocí služby Peertube si můžete vytvořit vlastní videoportál. Dnes ukážu, jak jsem nainstaloval Peertube na diskovou stanici Synology.
## Krok 1: Příprava společnosti Synology
Nejprve je třeba na zařízení DiskStation aktivovat přihlášení SSH. Chcete-li to provést, přejděte do nabídky "Ovládací panely" > "Terminál".
{{< gallery match="images/1/*.png" >}}
Poté se můžete přihlásit pomocí "SSH", zadaného portu a hesla správce.
{{< gallery match="images/2/*.png" >}}
Přihlašuji se přes Terminál, winSCP nebo Putty a nechávám tuto konzoli otevřenou na později.
## Krok 2: Příprava složky Docker
V adresáři Docker vytvořím nový adresář s názvem "Peertube".
{{< gallery match="images/3/*.png" >}}
Pak přejdu do adresáře Peertube a vytvořím nový soubor s názvem "peertube.yml" s následujícím obsahem. U portu lze nastavit přední část "9000:". Druhý svazek obsahuje všechna videa, playlist, náhledy atd., a proto musí být upraven.
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
Tento soubor se spouští pomocí nástroje Docker Compose:
{{< terminal >}}
sudo docker-compose -f compose-file-name.yml up -d

{{</ terminal >}}
Poté mohu zavolat svůj server Peertube pomocí IP adresy diskové stanice a přiřazeného portu z kroku 2. Skvělé!
{{< gallery match="images/4/*.png" >}}
Uživatelské jméno je "root" a heslo je "password" (nebo krok 2 / PT_INITIAL_ROOT_PASSWORD).
## Přizpůsobení tématu
Vzhled Peertube lze velmi snadno přizpůsobit. Za tímto účelem kliknu na "Správa" > "Nastavení" a "Rozšířená nastavení".
{{< gallery match="images/5/*.png" >}}
Tam jsem do pole CSS zadal následující údaje:
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
PeerTube má rozsáhlé a dobře zdokumentované rozhraní Rest API: https://docs.joinpeertube.org/api-rest-reference.html.
{{< gallery match="images/6/*.png" >}}
Pomocí tohoto příkazu lze vyhledávat videa:
{{< terminal >}}
curl -s "http://pree-tube/api/v1search/videos?search=docker&languageOneOf=de"

{{</ terminal >}}
Například pro odesílání je vyžadováno ověření a token relace:
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

## Můj tip: Přečtěte si článek "Skvělé věci s kontejnery: větší zabezpečení služeb Docker pomocí LDAP a NGINX".
