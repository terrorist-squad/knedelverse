+++
date = "2021-04-05"
title = "Stora saker med behållare: Egen videoportal med PeerTube"
difficulty = "level-1"
tags = ["diskstation", "peertube", "Synology", "video", "videoportal"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210405-docker-peertube/index.sv.md"
+++
Med Peertube kan du skapa din egen videoportal. Idag visar jag hur jag installerade Peertube på min Synology diskstation.
## Steg 1: Förbered Synology
Först måste SSH-inloggningen aktiveras på DiskStationen. Detta gör du genom att gå till "Kontrollpanelen" > "Terminal".
{{< gallery match="images/1/*.png" >}}
Därefter kan du logga in via "SSH", den angivna porten och administratörslösenordet.
{{< gallery match="images/2/*.png" >}}
Jag loggar in via Terminal, winSCP eller Putty och lämnar denna konsol öppen för senare.
## Steg 2: Förbered Docker-mappen
Jag skapar en ny katalog som heter "Peertube" i Docker-katalogen.
{{< gallery match="images/3/*.png" >}}
Sedan går jag in i Peertube-katalogen och skapar en ny fil som heter "peertube.yml" med följande innehåll. För porten kan den främre delen "9000:" justeras. Den andra volymen innehåller alla videor, spellistor, miniatyrbilder osv. och måste därför anpassas.
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
Den här filen startas via Docker Compose:
{{< terminal >}}
sudo docker-compose -f compose-file-name.yml up -d

{{</ terminal >}}
Därefter kan jag ringa min Peertube-server med diskstationens IP och den tilldelade porten från "Steg 2". Bra!
{{< gallery match="images/4/*.png" >}}
Användarnamnet är "root" och lösenordet är "password" (eller steg 2 / PT_INITIAL_ROOT_PASSWORD).
## Anpassning av teman
Det är mycket enkelt att anpassa utseendet på Peertube. För att göra detta klickar jag på "Administration" > "Inställningar" och "Avancerade inställningar".
{{< gallery match="images/5/*.png" >}}
Där har jag skrivit in följande i CSS-fältet:
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
PeerTube har ett omfattande och väldokumenterat Rest API: https://docs.joinpeertube.org/api-rest-reference.html.
{{< gallery match="images/6/*.png" >}}
Det här kommandot gör det möjligt att söka efter videor:
{{< terminal >}}
curl -s "http://pree-tube/api/v1search/videos?search=docker&languageOneOf=de"

{{</ terminal >}}
Autentisering och en sessionstoken krävs till exempel för en uppladdning:
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

## Mitt tips: Läs "Great things with containers: making Docker services more secure with LDAP and NGINX".
Jag kör min Peertube med en omvänd proxy. Detta innebär att endast LDAP-användare kan få tillgång till tjänsten. Jag har dokumenterat denna inställning under "[Bra saker med containrar: säkrare Dockertjänster med LDAP och NGINX]({{< ref "post/2021/april/20210402-nginx-reverse-proxy" >}} "Bra saker med containrar: säkrare Dockertjänster med LDAP och NGINX")".
