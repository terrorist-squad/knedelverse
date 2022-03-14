+++
date = "2021-04-05"
title = "Великие вещи с контейнерами: собственный видеопортал с PeerTube"
difficulty = "level-1"
tags = ["diskstation", "peertube", "Synology", "video", "videoportal"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/april/20210405-docker-peertube/index.ru.md"
+++
С помощью Peertube вы можете создать свой собственный видеопортал. Сегодня я покажу, как я установил Peertube на дисковую станцию Synology.
## Шаг 1: Подготовьте Synology
Во-первых, на DiskStation должен быть активирован вход SSH. Для этого перейдите в "Панель управления" > "Терминал
{{< gallery match="images/1/*.png" >}}
Затем вы можете войти в систему через "SSH", указанный порт и пароль администратора.
{{< gallery match="images/2/*.png" >}}
Я вхожу в систему через Terminal, winSCP или Putty и оставляю эту консоль открытой на потом.
## Шаг 2: Подготовьте папку Docker
Я создаю новый каталог под названием "Peertube" в каталоге Docker.
{{< gallery match="images/3/*.png" >}}
Затем я захожу в каталог Peertube и создаю новый файл под названием "peertube.yml" со следующим содержимым. Для порта можно настроить переднюю часть "9000:". Второй том содержит все видео, список воспроизведения, миниатюры и т.д... и поэтому должен быть адаптирован.
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
Этот файл запускается через Docker Compose:
{{< terminal >}}
sudo docker-compose -f compose-file-name.yml up -d

{{</ terminal >}}
После этого я могу позвонить на свой сервер Peertube, используя IP дисковой станции и назначенный порт из "Шага 2". Отлично!
{{< gallery match="images/4/*.png" >}}
Имя пользователя - "root", а пароль - "password" (или шаг 2 / PT_INITIAL_ROOT_PASSWORD).
## Настройка темы
Очень легко настроить внешний вид Peertube. Для этого я нажимаю "Администрирование" > "Настройки" и "Дополнительные настройки".
{{< gallery match="images/5/*.png" >}}
Там в поле CSS я ввел следующее:
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
PeerTube имеет обширный и хорошо документированный Rest API: https://docs.joinpeertube.org/api-rest-reference.html.
{{< gallery match="images/6/*.png" >}}
С помощью этой команды можно осуществлять поиск видео:
{{< terminal >}}
curl -s "http://pree-tube/api/v1search/videos?search=docker&languageOneOf=de"

{{</ terminal >}}
Аутентификация и маркер сессии требуются, например, для загрузки данных:
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

## Мой совет: прочитайте статью "Отличные вещи с контейнерами: повышение безопасности сервисов Docker с помощью LDAP и NGINX".
