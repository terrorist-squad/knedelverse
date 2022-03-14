+++
date = "2020-02-07"
title = "Lucruri grozave cu containere: Internet Archive în Docker"
difficulty = "level-3"
tags = ["bookmarks", "Docker", "Internet-Archiv", "Synology", "shiori"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2020/february/20200207-docker-shiori/index.ro.md"
+++
În următorul tutorial, veți instala o "arhivă de internet" privată ca un container Docker. Tot ce aveți nevoie este acest fișier "Docker-compose":
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
După ce ați pornit fișierul yml cu Docker-Compose prin "docker-compose -f your-file.yml up -d", puteți accesa arhiva locală de internet prin portul specificat, de exemplu http://localhost:18080 . Autentificarea implicită poate fi găsită pe următorul site web: https://github.com/go-shiori/shiori/wiki/Usage
```
username: shiori
password: gopher

```
Grozav! Puteți utiliza arhiva de internet:
{{< gallery match="images/1/*.png" >}}