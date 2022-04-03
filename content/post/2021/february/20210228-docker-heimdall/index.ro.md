+++
date = "2021-02-28"
title = "Lucruri grozave cu containere: Heimdall ca pagină de start"
difficulty = "level-3"
tags = ["dienste", "Docker", "docker-compose", "docker-for-desktop", "heimdall", "homepage", "startseite"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/february/20210228-docker-heimdall/index.ro.md"
+++
Rulez multe servicii în rețeaua mea Homelab, de exemplu LDAP, Gitlab, Atlassian Bamboo, Atlassian Confluence, Atlassian Jira, Jenkins, WordPress, Grafana, Graylog, ESXI/VMware, Calibre și multe altele. Este ușor să pierzi urma tuturor lucrurilor.
{{< gallery match="images/1/*.jpg" >}}

## Pasul 1: Creați dosarul de lucru
Utilizați această comandă pentru a crea un dosar de lucru temporar:
{{< terminal >}}
mkdir /tmp/bilder

{{</ terminal >}}
Heimdall este un serviciu care vă permite să gestionați marcajele prin intermediul tabloului de bord. Deoarece folosesc Docker for Desktop, trebuie doar să pun acest fișier Docker Compose într-un folder local:
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
Acest fișier este pornit prin Docker Compose:
{{< terminal >}}
ocker-compose -f compose-file.yml up -d

{{</ terminal >}}

{{< gallery match="images/2/*.png" >}}

