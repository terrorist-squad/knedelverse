+++
date = "2021-02-28"
title = "Velike stvari z zabojniki: Heimdall kot domača stran"
difficulty = "level-3"
tags = ["dienste", "Docker", "docker-compose", "docker-for-desktop", "heimdall", "homepage", "startseite"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/february/20210228-docker-heimdall/index.sl.md"
+++
V svojem omrežju Homelab uporabljam številne storitve, na primer LDAP, Gitlab, Atlassian Bamboo, Atlassian Confluence, Atlassian Jira, Jenkins, WordPress, Grafana, Graylog ,ESXI/VMware, Calibre in številne druge. Zlahka izgubite pregled nad vsem.
{{< gallery match="images/1/*.jpg" >}}

## Korak 1: Ustvarite delovno mapo
S tem ukazom ustvarite začasno delovno mapo:
{{< terminal >}}
mkdir /tmp/bilder

{{</ terminal >}}
Heimdall je storitev, ki vam omogoča upravljanje zaznamkov prek nadzorne plošče. Ker uporabljam Docker za namizje, moram to datoteko Docker Compose postaviti le v lokalno mapo:
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
Ta datoteka se zažene prek programa Docker Compose:
{{< terminal >}}
ocker-compose -f compose-file.yml up -d

{{</ terminal >}}

{{< gallery match="images/2/*.png" >}}
