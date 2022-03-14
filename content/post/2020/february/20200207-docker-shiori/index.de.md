+++
date = "2020-02-07"
title = "Großartiges mit Containern: Internet-Archiv in Docker"
difficulty = "level-3"
tags = ["bookmarks", "Docker", "Internet-Archiv", "Synology", "shiori"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2020/february/20200207-docker-shiori/index.de.md"
+++

Im folgenden Tutorial installieren Sie sich ein privates „Internet-Archiv“ als Docker-Container. Alles was Sie brauchen ist diese „Docker-compose“-Datei:
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

Nach dem Start der Yml-Datei mit Docker-Compose via „docker-compose -f ihre-datei.yml up -d„, können Sie das lokale Internet-Archiv über den angegeben Port aufrufen, zum Beispiel http://localhost:18080 . Der Standard-Login ist auf der folgenden Website zu finden: https://github.com/go-shiori/shiori/wiki/Usage
```
username: shiori
password: gopher
```

Großartig! Sie können Ihr Internetarchiv nutzen:
{{< gallery match="images/1/*.png" >}}