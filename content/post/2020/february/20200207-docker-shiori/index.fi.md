+++
date = "2020-02-07"
title = "Suuria asioita astioiden kanssa: Internet Archive in Docker"
difficulty = "level-3"
tags = ["bookmarks", "Docker", "Internet-Archiv", "Synology", "shiori"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2020/february/20200207-docker-shiori/index.fi.md"
+++
Seuraavassa ohjeessa asennat yksityisen "Internet-arkiston" Docker-säiliönä. Tarvitset vain tämän "Docker-compose"-tiedoston:
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
Kun olet käynnistänyt yml-tiedoston Docker-Composella komennolla "docker-compose -f your-file.yml up -d", voit käyttää paikallista internet-arkistoa määritetyn portin kautta, esimerkiksi http://localhost:18080 . Oletustunnukset löytyvät seuraavalta verkkosivustolta: https://github.com/go-shiori/shiori/wiki/Usage.
```
username: shiori
password: gopher

```
Hienoa! Voit käyttää internet-arkistoasi:
{{< gallery match="images/1/*.png" >}}