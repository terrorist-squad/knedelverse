+++
date = "2020-02-07"
title = "容器的伟大之处。Docker中的互联网档案馆"
difficulty = "level-3"
tags = ["bookmarks", "Docker", "Internet-Archiv", "Synology", "shiori"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2020/february/20200207-docker-shiori/index.zh.md"
+++
在下面的教程中，你将把一个私有的 "互联网档案 "安装成一个Docker容器。你所需要的就是这个 "Docker-compose "文件。
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
通过 "docker-compose -f your-file.yml up -d "用Docker-Compose启动yml文件后，你可以通过指定的端口访问本地互联网存档，例如http://localhost:18080 。默认登录可以在以下网站找到：https://github.com/go-shiori/shiori/wiki/Usage
```
username: shiori
password: gopher

```
很好!你可以使用你的互联网档案。
{{< gallery match="images/1/*.png" >}}