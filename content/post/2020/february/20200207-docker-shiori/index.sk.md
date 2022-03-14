+++
date = "2020-02-07"
title = "Veľké veci s kontajnermi: Internetový archív v aplikácii Docker"
difficulty = "level-3"
tags = ["bookmarks", "Docker", "Internet-Archiv", "Synology", "shiori"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2020/february/20200207-docker-shiori/index.sk.md"
+++
V nasledujúcom návode nainštalujete súkromný "internetový archív" ako kontajner Docker. Všetko, čo potrebujete, je tento súbor "Docker-compose":
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
Po spustení súboru yml pomocou nástroja Docker-Compose pomocou príkazu "docker-compose -f your-file.yml up -d" môžete pristupovať k miestnemu internetovému archívu prostredníctvom zadaného portu, napríklad http://localhost:18080 . Predvolené prihlásenie nájdete na tejto webovej stránke: https://github.com/go-shiori/shiori/wiki/Usage
```
username: shiori
password: gopher

```
Skvelé! Môžete použiť svoj internetový archív:
{{< gallery match="images/1/*.png" >}}