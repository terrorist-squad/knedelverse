+++
date = "2020-02-07"
title = "Store ting med beholdere: Internet Archive i Docker"
difficulty = "level-3"
tags = ["bookmarks", "Docker", "Internet-Archiv", "Synology", "shiori"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2020/february/20200207-docker-shiori/index.da.md"
+++
I den følgende vejledning installerer du et privat "internetarkiv" som en Docker-container. Du skal blot bruge denne "Docker-compose"-fil:
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
Når du har startet yml-filen med Docker-Compose via "docker-compose -f your-file.yml up -d", kan du få adgang til det lokale internetarkiv via den angivne port, f.eks. http://localhost:18080 . Standardlogin kan findes på følgende websted: https://github.com/go-shiori/shiori/wiki/Usage
```
username: shiori
password: gopher

```
Fantastisk! Du kan bruge dit internetarkiv:
{{< gallery match="images/1/*.png" >}}