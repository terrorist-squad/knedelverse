+++
date = "2020-02-07"
title = "Velike stvari z zabojniki: Internetni arhiv v Dockerju"
difficulty = "level-3"
tags = ["bookmarks", "Docker", "Internet-Archiv", "Synology", "shiori"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2020/february/20200207-docker-shiori/index.sl.md"
+++
V naslednjem vodniku boste namestili zasebni "internetni arhiv" kot vsebnik Docker. Vse, kar potrebujete, je ta datoteka "Docker-compose":
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
Po zagonu datoteke yml s programom Docker-Compose z ukazom "docker-compose -f your-file.yml up -d" lahko do lokalnega internetnega arhiva dostopate prek določenih vrat, na primer http://localhost:18080 . Privzeta prijava je na voljo na naslednjem spletnem mestu: https://github.com/go-shiori/shiori/wiki/Usage.
```
username: shiori
password: gopher

```
Odlično! Uporabite lahko internetni arhiv:
{{< gallery match="images/1/*.png" >}}