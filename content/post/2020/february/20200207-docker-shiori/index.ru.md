+++
date = "2020-02-07"
title = "Отличные вещи с контейнерами: Архив Интернета в Docker"
difficulty = "level-3"
tags = ["bookmarks", "Docker", "Internet-Archiv", "Synology", "shiori"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2020/february/20200207-docker-shiori/index.ru.md"
+++
В следующем руководстве вы установите частный "интернет-архив" в виде контейнера Docker. Все, что вам нужно, это файл "Docker-compose":
```
version: '2'
services:
  db:
     image: radhifadlillah/shiori:latest
     container_name: bookmark-archiv-shiori
     volumes:
       - ./shiori-server:/srv/shiori
     ports:
       - "18080:8080"


```
После запуска yml-файла с помощью Docker-Compose через "docker-compose -f your-file.yml up -d", вы можете получить доступ к локальному интернет-архиву через указанный порт, например http://localhost:18080 . Логин по умолчанию можно найти на следующем сайте: https://github.com/go-shiori/shiori/wiki/Usage.
```
username: shiori
password: gopher

```
Отлично! Вы можете использовать свой интернет-архив:
{{< gallery match="images/1/*.png" >}}