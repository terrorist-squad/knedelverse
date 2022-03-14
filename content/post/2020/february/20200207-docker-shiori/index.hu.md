+++
date = "2020-02-07"
title = "Nagyszerű dolgok a konténerekkel: Internet Archive in Docker"
difficulty = "level-3"
tags = ["bookmarks", "Docker", "Internet-Archiv", "Synology", "shiori"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2020/february/20200207-docker-shiori/index.hu.md"
+++
A következő bemutatóban egy privát "internetes archívumot" fog telepíteni Docker konténerként. Mindössze erre a "Docker-compose" fájlra van szükséged:
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
Miután elindítottuk az yml fájlt a Docker-Compose segítségével a "docker-compose -f your-file.yml up -d" paranccsal, elérhetjük a helyi internetes archívumot a megadott porton keresztül, például http://localhost:18080 . Az alapértelmezett bejelentkezés a következő weboldalon található: https://github.com/go-shiori/shiori/wiki/Usage
```
username: shiori
password: gopher

```
Nagyszerű! Használhatja az internetes archívumát:
{{< gallery match="images/1/*.png" >}}