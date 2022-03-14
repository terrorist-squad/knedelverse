+++
date = "2021-02-28"
title = "Nagyszerű dolgok konténerekkel: Heimdall mint honlap"
difficulty = "level-3"
tags = ["dienste", "Docker", "docker-compose", "docker-for-desktop", "heimdall", "homepage", "startseite"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/february/20210228-docker-heimdall/index.hu.md"
+++
Sok szolgáltatást futtatok a Homelab hálózatomban, például LDAP, Gitlab, Atlassian Bamboo, Atlassian Confluence, Atlassian Jira, Jenkins, WordPress, Grafana, Graylog ,ESXI/VMware, Calibre és még sok más. Könnyű elveszíteni a fonalat.
{{< gallery match="images/1/*.jpg" >}}

## 1. lépés: Munkamappa létrehozása
Ezzel a paranccsal létrehozhat egy ideiglenes munkamappát:
{{< terminal >}}
mkdir /tmp/bilder

{{</ terminal >}}
A Heimdall egy olyan szolgáltatás, amely lehetővé teszi a könyvjelzők kezelését a Dashboardon keresztül. Mivel Docker for Desktopot használok, csak ezt a Docker Compose fájlt kell egy helyi mappába helyeznem:
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
Ez a fájl a Docker Compose segítségével indul:
{{< terminal >}}
ocker-compose -f compose-file.yml up -d

{{</ terminal >}}

{{< gallery match="images/2/*.png" >}}
