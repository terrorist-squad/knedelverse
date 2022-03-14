+++
date = "2020-02-07"
title = "Grandes cosas con los contenedores: Internet Archive en Docker"
difficulty = "level-3"
tags = ["bookmarks", "Docker", "Internet-Archiv", "Synology", "shiori"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2020/february/20200207-docker-shiori/index.es.md"
+++
En el siguiente tutorial, instalará un "archivo de Internet" privado como contenedor Docker. Todo lo que necesitas es este archivo "Docker-compose":
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
Después de iniciar el archivo yml con Docker-Compose a través de "docker-compose -f tu-archivo.yml up -d", puede acceder al archivo local de Internet a través del puerto especificado, por ejemplo http://localhost:18080 . El inicio de sesión por defecto se puede encontrar en la siguiente página web: https://github.com/go-shiori/shiori/wiki/Usage
```
username: shiori
password: gopher

```
¡Genial! Puedes utilizar tu archivo de Internet:
{{< gallery match="images/1/*.png" >}}