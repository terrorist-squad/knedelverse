+++
date = "2020-02-07"
title = "Skvělé věci s kontejnery: Internetový archiv v Dockeru"
difficulty = "level-3"
tags = ["bookmarks", "Docker", "Internet-Archiv", "Synology", "shiori"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2020/february/20200207-docker-shiori/index.cs.md"
+++
V následujícím návodu nainstalujete soukromý "internetový archiv" jako kontejner Docker. Potřebujete pouze tento soubor "Docker-compose":
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
Po spuštění souboru yml pomocí nástroje Docker-Compose pomocí příkazu "docker-compose -f your-file.yml up -d" můžete přistupovat k místnímu internetovému archivu prostřednictvím zadaného portu, například http://localhost:18080 . Výchozí přihlašovací údaje naleznete na této webové stránce: https://github.com/go-shiori/shiori/wiki/Usage.
```
username: shiori
password: gopher

```
Skvělé! Můžete použít svůj internetový archiv:
{{< gallery match="images/1/*.png" >}}
