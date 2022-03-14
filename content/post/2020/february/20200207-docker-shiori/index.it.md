+++
date = "2020-02-07"
title = "Grandi cose con i contenitori: Internet Archive in Docker"
difficulty = "level-3"
tags = ["bookmarks", "Docker", "Internet-Archiv", "Synology", "shiori"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2020/february/20200207-docker-shiori/index.it.md"
+++
Nel seguente tutorial, installerete un "archivio Internet" privato come contenitore Docker. Tutto ciò di cui avete bisogno è questo file "Docker-compose":
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
Dopo aver avviato il file yml con Docker-Compose tramite "docker-compose -f your-file.yml up -d", è possibile accedere all'archivio internet locale tramite la porta specificata, per esempio http://localhost:18080 . Il login di default può essere trovato sul seguente sito web: https://github.com/go-shiori/shiori/wiki/Usage
```
username: shiori
password: gopher

```
Grande! Puoi usare il tuo archivio Internet:
{{< gallery match="images/1/*.png" >}}