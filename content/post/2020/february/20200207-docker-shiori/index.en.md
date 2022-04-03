+++
date = "2020-02-07"
title = "Great things with containers: Internet Archive in Docker"
difficulty = "level-3"
tags = ["bookmarks", "Docker", "Internet-Archiv", "Synology", "shiori"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2020/february/20200207-docker-shiori/index.en.md"
+++
In the following tutorial, you will install yourself a private "Internet Archive" as a Docker container. All you need is this "Docker-compose" file:
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
After launching the yml file with docker-compose via "docker-compose -f your-file.yml up -d", you can access the local internet archive via the specified port, for example http://localhost:18080 . The default login can be found on the following website: https://github.com/go-shiori/shiori/wiki/Usage
```
username: shiori
password: gopher

```
Great! You can use your Internet archive:
{{< gallery match="images/1/*.png" >}}
