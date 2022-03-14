+++
date = "2021-02-28"
title = "Store ting med containere: Heimdall som hjemmeside"
difficulty = "level-3"
tags = ["dienste", "Docker", "docker-compose", "docker-for-desktop", "heimdall", "homepage", "startseite"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/february/20210228-docker-heimdall/index.da.md"
+++
Jeg kører mange tjenester i mit Homelab-netværk, f.eks. LDAP, Gitlab, Atlassian Bamboo, Atlassian Confluence, Atlassian Jira, Jenkins, WordPress, Grafana, Graylog, ESXI/VMware, Calibre og meget mere. Det er nemt at miste overblikket over alting.
{{< gallery match="images/1/*.jpg" >}}

## Trin 1: Opret en arbejdsmappe
Brug denne kommando til at oprette en midlertidig arbejdsmappe:
{{< terminal >}}
mkdir /tmp/bilder

{{</ terminal >}}
Heimdall er en tjeneste, der giver dig mulighed for at administrere bogmærker via Dashboard. Da jeg bruger Docker for Desktop, behøver jeg kun at placere denne Docker Compose-fil i en lokal mappe:
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
Denne fil startes via Docker Compose:
{{< terminal >}}
ocker-compose -f compose-file.yml up -d

{{</ terminal >}}

{{< gallery match="images/2/*.png" >}}
