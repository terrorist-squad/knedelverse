+++
date = "2021-02-28"
title = "Страхотни неща с контейнери: Хеймдал като начална страница"
difficulty = "level-3"
tags = ["dienste", "Docker", "docker-compose", "docker-for-desktop", "heimdall", "homepage", "startseite"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/february/20210228-docker-heimdall/index.bg.md"
+++
Използвам много услуги в моята мрежа Homelab, например LDAP, Gitlab, Atlassian Bamboo, Atlassian Confluence, Atlassian Jira, Jenkins, WordPress, Grafana, Graylog ,ESXI/VMware, Calibre и много други. Лесно е да изгубите представа за всичко.
{{< gallery match="images/1/*.jpg" >}}

## Стъпка 1: Създаване на работна папка
Използвайте тази команда, за да създадете временна работна папка:
{{< terminal >}}
mkdir /tmp/bilder

{{</ terminal >}}
Heimdall е услуга, която ви позволява да управлявате отметките чрез таблото за управление. Тъй като използвам Docker за Desktop, трябва само да поставя този файл Docker Compose в локална папка:
```
version: "2.1"
services:
  heimdall:
    image: linuxserver/heimdall
    container_name: heimdall
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=Europe/Berlin
    volumes:
      - /Users/christianknedel/docker/heimdall/config:/config
    ports:
      - 80:80
      - 443:443
    restart: always

```
Този файл се стартира чрез Docker Compose:
{{< terminal >}}
ocker-compose -f compose-file.yml up -d

{{</ terminal >}}

{{< gallery match="images/2/*.png" >}}
