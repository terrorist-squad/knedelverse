+++
date = "2021-04-05"
title = "Страхотни неща с контейнери: Собствен видео портал с PeerTube"
difficulty = "level-1"
tags = ["diskstation", "peertube", "Synology", "video", "videoportal"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210405-docker-peertube/index.bg.md"
+++
С Peertube можете да създадете свой собствен видео портал. Днес ще покажа как инсталирах Peertube на моята дискова станция Synology.
## Стъпка 1: Подготовка на Synology
Първо, SSH входът трябва да бъде активиран на DiskStation. За да направите това, отидете в "Контролен панел" > "Терминал
{{< gallery match="images/1/*.png" >}}
След това можете да влезете в системата чрез "SSH", посочения порт и паролата на администратора.
{{< gallery match="images/2/*.png" >}}
Влизам в системата чрез терминал, winSCP или Putty и оставям тази конзола отворена за по-късно.
## Стъпка 2: Подготовка на папката Docker
Създавам нова директория, наречена "Peertube", в директорията на Docker.
{{< gallery match="images/3/*.png" >}}
След това влизам в директорията Peertube и създавам нов файл, наречен "peertube.yml", със следното съдържание. За порта може да се регулира предната част "9000:". Вторият том съдържа всички видеоклипове, списък за възпроизвеждане, миниатюри и т.н. и следователно трябва да бъде адаптиран.
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
Този файл се стартира чрез Docker Compose:
{{< terminal >}}
sudo docker-compose -f compose-file-name.yml up -d

{{</ terminal >}}
След това мога да се обадя на моя Peertube сървър с IP адреса на дисковата станция и назначения порт от "Стъпка 2". Страхотно!
{{< gallery match="images/4/*.png" >}}
Потребителското име е "root", а паролата е "password" (или стъпка 2 / PT_INITIAL_ROOT_PASSWORD).
## Персонализиране на темата
Много е лесно да персонализирате външния вид на Peertube. За да направя това, щраквам върху "Администрация" > "Настройки" и "Разширени настройки".
{{< gallery match="images/5/*.png" >}}
Там въведох следното в полето CSS:
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

## API за почивка
PeerTube разполага с обширен и добре документиран API за почивка: https://docs.joinpeertube.org/api-rest-reference.html.
{{< gallery match="images/6/*.png" >}}
С тази команда е възможно търсене на видеоклипове:
{{< terminal >}}
curl -s "http://pree-tube/api/v1search/videos?search=docker&languageOneOf=de"

{{</ terminal >}}
За качване например се изисква удостоверяване и токен на сесия:
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

## Моят съвет: Прочетете "Страхотни неща с контейнерите: повишаване на сигурността на услугите на Docker с LDAP и NGINX".
