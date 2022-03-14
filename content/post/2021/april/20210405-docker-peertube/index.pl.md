+++
date = "2021-04-05"
title = "Wielkie rzeczy z kontenerów: Własny portal wideo z PeerTube"
difficulty = "level-1"
tags = ["diskstation", "peertube", "Synology", "video", "videoportal"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/april/20210405-docker-peertube/index.pl.md"
+++
Dzięki Peertube możesz stworzyć swój własny portal wideo. Dzisiaj pokażę jak zainstalowałem Peertube na stacji dysków Synology.
## Krok 1: Przygotuj Synology
Najpierw należy aktywować logowanie SSH na serwerze DiskStation. W tym celu należy wejść w "Panel sterowania" > "Terminal
{{< gallery match="images/1/*.png" >}}
Następnie można zalogować się poprzez "SSH", podany port i hasło administratora.
{{< gallery match="images/2/*.png" >}}
Loguję się przez Terminal, winSCP lub Putty i zostawiam tę konsolę otwartą na później.
## Krok 2: Przygotuj folder Docker
Tworzę nowy katalog o nazwie "Peertube" w katalogu Docker.
{{< gallery match="images/3/*.png" >}}
Następnie wchodzę do katalogu Peertube i tworzę nowy plik o nazwie "peertube.yml" z następującą zawartością. Dla portu, przednia część "9000:" może być regulowana. Drugi tom zawiera wszystkie filmy, playlisty, miniaturki itd... i dlatego musi być dostosowany.
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
Ten plik jest uruchamiany za pomocą Docker Compose:
{{< terminal >}}
sudo docker-compose -f compose-file-name.yml up -d

{{</ terminal >}}
Po tym, mogę zadzwonić do mojego serwera Peertube z IP stacji dysków i przypisany port z "Krok 2". Świetnie!
{{< gallery match="images/4/*.png" >}}
Nazwa użytkownika to "root", a hasło to "password" (lub krok 2 / PT_INITIAL_ROOT_PASSWORD).
## Dostosowanie motywu
Wygląd Peertube można bardzo łatwo dostosować do własnych potrzeb. Aby to zrobić, klikam na "Administracja" > "Ustawienia" i "Ustawienia zaawansowane".
{{< gallery match="images/5/*.png" >}}
W polu CSS wpisałem następujące dane:
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
PeerTube ma rozbudowane i dobrze udokumentowane Rest API: https://docs.joinpeertube.org/api-rest-reference.html.
{{< gallery match="images/6/*.png" >}}
Za pomocą tego polecenia można wyszukiwać filmy:
{{< terminal >}}
curl -s "http://pree-tube/api/v1search/videos?search=docker&languageOneOf=de"

{{</ terminal >}}
Uwierzytelnienie i token sesji są wymagane na przykład przy wysyłaniu danych:
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

## Moja rada: Przeczytaj "Wielkie rzeczy z kontenerami: zwiększanie bezpieczeństwa usług Dockera za pomocą LDAP i NGINX".
