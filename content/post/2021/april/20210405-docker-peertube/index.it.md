+++
date = "2021-04-05"
title = "Grandi cose con i container: il proprio portale video con PeerTube"
difficulty = "level-1"
tags = ["diskstation", "peertube", "Synology", "video", "videoportal"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210405-docker-peertube/index.it.md"
+++
Con Peertube puoi creare il tuo portale video. Oggi mostro come ho installato Peertube sulla mia Synology disk station.
## Passo 1: Preparare Synology
Innanzitutto, il login SSH deve essere attivato sulla DiskStation. Per farlo, andate nel "Pannello di controllo" > "Terminale
{{< gallery match="images/1/*.png" >}}
Poi si può accedere tramite "SSH", la porta specificata e la password dell'amministratore.
{{< gallery match="images/2/*.png" >}}
Mi collego tramite Terminale, winSCP o Putty e lascio questa console aperta per dopo.
## Passo 2: preparare la cartella Docker
Creo una nuova directory chiamata "Peertube" nella directory Docker.
{{< gallery match="images/3/*.png" >}}
Poi vado nella directory di Peertube e creo un nuovo file chiamato "peertube.yml" con il seguente contenuto. Per la porta, la parte anteriore "9000:" può essere regolata. Il secondo volume contiene tutti i video, la playlist, le miniature ecc... e deve quindi essere adattato.
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
Questo file viene avviato tramite Docker Compose:
{{< terminal >}}
sudo docker-compose -f compose-file-name.yml up -d

{{</ terminal >}}
Dopo di che, posso chiamare il mio server Peertube con l'IP della stazione disco e la porta assegnata dal "Passo 2". Grande!
{{< gallery match="images/4/*.png" >}}
Il nome utente è "root" e la password è "password" (o passo 2 / PT_INITIAL_ROOT_PASSWORD).
## Personalizzazione del tema
È molto facile personalizzare l'aspetto di Peertube. Per farlo, clicco su "Amministrazione" > "Impostazioni" e "Impostazioni avanzate".
{{< gallery match="images/5/*.png" >}}
Lì ho inserito quanto segue nel campo CSS:
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
PeerTube ha un'API Rest estesa e ben documentata: https://docs.joinpeertube.org/api-rest-reference.html.
{{< gallery match="images/6/*.png" >}}
La ricerca di video è possibile con questo comando:
{{< terminal >}}
curl -s "http://pree-tube/api/v1search/videos?search=docker&languageOneOf=de"

{{</ terminal >}}
L'autenticazione e un token di sessione sono richiesti per un upload, per esempio:
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

## Il mio consiglio: leggete "Grandi cose con i container: rendere i servizi Docker più sicuri con LDAP e NGINX".
