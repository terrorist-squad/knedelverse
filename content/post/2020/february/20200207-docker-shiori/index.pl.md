+++
date = "2020-02-07"
title = "Wspaniałe rzeczy z pojemnikami: Internet Archive w Dockerze"
difficulty = "level-3"
tags = ["bookmarks", "Docker", "Internet-Archiv", "Synology", "shiori"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2020/february/20200207-docker-shiori/index.pl.md"
+++
W poniższym tutorialu zainstalujesz prywatne "archiwum internetowe" jako kontener Docker. Wszystko czego potrzebujesz to ten plik "Docker-compose":
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
Po uruchomieniu pliku yml za pomocą Docker-Compose przez "docker-compose -f your-file.yml up -d", można uzyskać dostęp do lokalnego archiwum internetowego przez podany port, na przykład http://localhost:18080 . Domyślny login można znaleźć na następującej stronie internetowej: https://github.com/go-shiori/shiori/wiki/Usage
```
username: shiori
password: gopher

```
Świetnie! Możesz wykorzystać swoje archiwum internetowe:
{{< gallery match="images/1/*.png" >}}