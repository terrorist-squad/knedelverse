+++
date = "2020-02-07"
title = "Du grand avec les conteneurs : Archives Internet dans Docker"
difficulty = "level-3"
tags = ["bookmarks", "Docker", "Internet-Archiv", "Synology", "shiori"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2020/february/20200207-docker-shiori/index.fr.md"
+++
Dans le tutoriel suivant, vous allez installer une "archive Internet" privée en tant que conteneur Docker. Tout ce dont vous avez besoin est ce fichier "Docker-compose" :
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
Après avoir lancé le fichier yml avec Docker-Compose via "docker-compose -f votre-fichier.yml up -d", vous pouvez accéder à l'archive Internet locale via le port indiqué, par exemple http://localhost:18080 . Le login standard se trouve sur le site web suivant : https://github.com/go-shiori/shiori/wiki/Usage
```
username: shiori
password: gopher

```
C'est génial ! Vous pouvez utiliser vos archives Internet :
{{< gallery match="images/1/*.png" >}}
