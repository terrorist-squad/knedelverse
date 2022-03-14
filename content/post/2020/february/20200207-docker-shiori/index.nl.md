+++
date = "2020-02-07"
title = "Geweldige dingen met containers: Internet Archief in Docker"
difficulty = "level-3"
tags = ["bookmarks", "Docker", "Internet-Archiv", "Synology", "shiori"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2020/february/20200207-docker-shiori/index.nl.md"
+++
In de volgende tutorial installeer je een privé "Internet archief" als een Docker container. Alles wat je nodig hebt is dit "Docker-compose" bestand:
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
Na het starten van het yml-bestand met Docker-Compose via "docker-compose -f uw-bestand.yml up -d", kunt u toegang krijgen tot het lokale internetarchief via de opgegeven poort, bijvoorbeeld http://localhost:18080 . De standaardlogin is te vinden op de volgende website: https://github.com/go-shiori/shiori/wiki/Usage
```
username: shiori
password: gopher

```
Geweldig. U kunt uw Internet archief gebruiken:
{{< gallery match="images/1/*.png" >}}