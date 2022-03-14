+++
date = "2020-02-07"
title = "Grandes coisas com contentores: Arquivo da Internet em Docker"
difficulty = "level-3"
tags = ["bookmarks", "Docker", "Internet-Archiv", "Synology", "shiori"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2020/february/20200207-docker-shiori/index.pt.md"
+++
No próximo tutorial, você instalará um "arquivo de Internet" privado como um container Docker. Tudo o que você precisa é deste arquivo "Docker-compose":
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
Depois de iniciar o arquivo yml com Docker-Compose via "docker-compose -f your-file.yml up -d", você pode acessar o arquivo local da internet através da porta especificada, por exemplo http://localhost:18080 . O login padrão pode ser encontrado no seguinte site: https://github.com/go-shiori/shiori/wiki/Usage
```
username: shiori
password: gopher

```
Ótimo! Você pode usar o seu arquivo na Internet:
{{< gallery match="images/1/*.png" >}}