+++
date = "2020-02-07"
title = "Stora saker med behållare: Internet Archive i Docker"
difficulty = "level-3"
tags = ["bookmarks", "Docker", "Internet-Archiv", "Synology", "shiori"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2020/february/20200207-docker-shiori/index.sv.md"
+++
I följande handledning ska du installera ett privat "Internetarkiv" som en Docker-behållare. Allt du behöver är den här filen "Docker-compose":
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
Efter att ha startat yml-filen med Docker-Compose via "docker-compose -f your-file.yml up -d" kan du komma åt det lokala internetarkivet via den angivna porten, till exempel http://localhost:18080 . Standardinloggningen finns på följande webbplats: https://github.com/go-shiori/shiori/wiki/Usage
```
username: shiori
password: gopher

```
Bra! Du kan använda ditt internetarkiv:
{{< gallery match="images/1/*.png" >}}