+++
date = "2021-04-05"
title = "Großartiges mit Containern: Eigenes Videoportal mit PeerTube"
difficulty = "level-1"
tags = ["diskstation", "peertube", "Synology", "video", "videoportal"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/april/20210405-docker-peertube/index.de.md"
+++

Mit Peertube kann man ein eigenes Videoportal gestalten. Heute zeige ich, wie ich Peertube auf meiner Synology-Diskstation installiert habe.

## Schritt 1: Synology vorbereiten
Als erstes muss der SSH-Login auf der Diskstation aktiviert werden. Dazu geht man in die „Systemsteuerung“ > „Terminal & SNMP“ und aktiviert dort die „SSH-Dienst aktivieren“-Einstellung.
{{< gallery match="images/1/*.png" >}}

Danach kann man sich via „SSH„, den angegebenen Port und dem Administrator-Password anmelden.
{{< gallery match="images/2/*.png" >}}

Ich logge mich via Terminal, winSCP oder Putty ein und lasse diese Konsole erst einmal für später offen.

## Schritt 2: Docker-Ordner vorbereiten
Ich erstelle ein neues Verzeichnis namens „Peertube“ im Docker-Verzeichnis. 
{{< gallery match="images/3/*.png" >}}

Danach gehe ich in das Peertube-Verzeichnis und erstelle dort neue Datei namens „peertube.yml“ mit folgendem Inhalt. Bei den Port kann der vordere Teil „9000:“ angepasst werden. Das zweite Volumen enthält alle Videos, Playlist, Thumbnails usw… und muss daher angepasst werden.
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

Diese Datei wird via Docker-Compose gestartet:
{{< terminal >}}
sudo docker-compose -f compose-file-name.yml up -d
{{</ terminal >}}

Danach kann ich meinen Peertube-Server mit der IP der Diskstation und dem vergeben Port aus „Schritt 2“ aufrufen. Großartig!
{{< gallery match="images/4/*.png" >}}
Der Username ist „root“ und das Password ist „password“ (oder Schritt 2 / PT_INITIAL_ROOT_PASSWORD).

## Theme-Anpassung
Das Aussehen von Peertube lässt sich kinderleicht anpassen. Dazu klicke ich auf „Administration“ > „Einstellungen“ und „Erweiterte Einstellungen“.
{{< gallery match="images/5/*.png" >}}

Dort habe ich folgendes im CSS-Feld eingetragen:
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

## Rest-API
PeerTube hat eine umfangreiche und gut dokumentiert Rest-API: https://docs.joinpeertube.org/api-rest-reference.html.
{{< gallery match="images/6/*.png" >}}

Das Suchen nach Videos ist mit diesem Befehl möglich:
{{< terminal >}}
curl -s "http://pree-tube/api/v1search/videos?search=docker&languageOneOf=de"
{{</ terminal >}}

Für einen Upload wird eine Authentifizierung und ein Session-Token benötigt, zum Beispiel:
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

## Mein Tipp: „Großartiges mit Containern: Docker-Dienste mit LDAP und NGINX sicherer machen“ lesen
Ich betreibe mein Peertube mit einem Reverse-Proxy. Das heißt, dass nur LDAP-Nutzer auf diesen Dienst zugreifen können. Ich habe dieses Setup unter "[Großartiges mit Containern: Docker-Dienste mit LDAP und NGINX sicherer machen]({{< ref "post/2021/april/20210402-nginx-reverse-proxy" >}} "Großartiges mit Containern: Docker-Dienste mit LDAP und NGINX sicherer machen")" dokumentiert.