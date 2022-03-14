+++
date = "2021-04-05"
title = "Great things with containers: Own video portal with PeerTube"
difficulty = "level-1"
tags = ["diskstation", "peertube", "Synology", "video", "videoportal"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/april/20210405-docker-peertube/index.en.md"
+++
With Peertube you can create your own video portal. Today I show how I installed Peertube on my Synology Diskstation.
## Step 1: Prepare Synology
First of all, you need to enable SSH login on Diskstation. To do this, go to the "Control Panel" > "Terminal
{{< gallery match="images/1/*.png" >}}
After that you can log in via "SSH", the specified port and the administrator password.
{{< gallery match="images/2/*.png" >}}
I log in via Terminal, winSCP or Putty and leave this console open for later.
## Step 2: Prepare Docker folder
I create a new directory called "Peertube" in the Docker directory.
{{< gallery match="images/3/*.png" >}}
After that I go into the Peertube directory and create a new file called "peertube.yml" with the following content. For the port, the front part "9000:" can be customized. The second volume contains all videos, playlist, thumbnails etc... and therefore must be adjusted.
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
This file is started via Docker Compose:
{{< terminal >}}
sudo docker-compose -f compose-file-name.yml up -d

{{</ terminal >}}
After that I can call my Peertube server with the IP of the diskstation and the assigned port from "Step 2". Great!
{{< gallery match="images/4/*.png" >}}
The username is "root" and the password is "password" (or step 2 / PT_INITIAL_ROOT_PASSWORD).
## Theme Customization
The appearance of Peertube is very easy to customize. To do this, I click on "Administration" > "Settings" and "Advanced settings".
{{< gallery match="images/5/*.png" >}}
There I entered the following in the CSS field:
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
PeerTube has an extensive and well documented Rest API: https://docs.joinpeertube.org/api-rest-reference.html.
{{< gallery match="images/6/*.png" >}}
Searching for videos is possible with this command:
{{< terminal >}}
curl -s "http://pree-tube/api/v1search/videos?search=docker&languageOneOf=de"

{{</ terminal >}}
Authentication and a session token are required for an upload, for example:
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

## My tip: Read "Great things with containers: making Docker services more secure with LDAP and NGINX".
