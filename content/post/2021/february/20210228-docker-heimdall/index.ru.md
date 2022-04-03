+++
date = "2021-02-28"
title = "Великие дела с контейнерами: Хеймдалль в качестве домашней страницы"
difficulty = "level-3"
tags = ["dienste", "Docker", "docker-compose", "docker-for-desktop", "heimdall", "homepage", "startseite"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/february/20210228-docker-heimdall/index.ru.md"
+++
В моей сети Homelab работает множество сервисов, например, LDAP, Gitlab, Atlassian Bamboo, Atlassian Confluence, Atlassian Jira, Jenkins, WordPress, Grafana, Graylog, ESXI/VMware, Calibre и многое другое. Легко потерять счет всему.
{{< gallery match="images/1/*.jpg" >}}

## Шаг 1: Создайте рабочую папку
Используйте эту команду для создания временной рабочей папки:
{{< terminal >}}
mkdir /tmp/bilder

{{</ terminal >}}
Heimdall - это сервис, позволяющий управлять закладками через Dashboard. Поскольку я использую Docker для Desktop, мне нужно только поместить этот файл Docker Compose в локальную папку:
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
Этот файл запускается через Docker Compose:
{{< terminal >}}
ocker-compose -f compose-file.yml up -d

{{</ terminal >}}

{{< gallery match="images/2/*.png" >}}

