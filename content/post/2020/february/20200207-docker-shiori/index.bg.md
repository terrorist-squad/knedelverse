+++
date = "2020-02-07"
title = "Страхотни неща с контейнери: Интернет архив в Docker"
difficulty = "level-3"
tags = ["bookmarks", "Docker", "Internet-Archiv", "Synology", "shiori"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2020/february/20200207-docker-shiori/index.bg.md"
+++
В следващия урок ще инсталирате частен "интернет архив" като контейнер на Docker. Всичко, от което се нуждаете, е този файл "Docker-compose":
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
След като стартирате файла yml с Docker-Compose чрез "docker-compose -f your-file.yml up -d", можете да получите достъп до локалния интернет архив чрез посочения порт, например http://localhost:18080 . Входът по подразбиране може да бъде намерен на следния уебсайт: https://github.com/go-shiori/shiori/wiki/Usage
```
username: shiori
password: gopher

```
Страхотно! Можете да използвате своя интернет архив:
{{< gallery match="images/1/*.png" >}}