+++
date = "2021-02-28"
title = "Großartiges mit Containern: Heimdall als Startseite"
difficulty = "level-3"
tags = ["dienste", "Docker", "docker-compose", "docker-for-desktop", "heimdall", "homepage", "startseite"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/february/20210228-docker-heimdall/index.de.md"
+++

Ich betreibe viele Dienste in meinem Homelab-Network, zum Beispiel LDAP, Gitlab, Atlassian Bamboo, Atlassian Confluence, Atlassian Jira, Jenkins, WordPress, Grafana, Graylog ,ESXI/VMware, Calibre und vieles mehr. Da kann man schon einmal den Überblick verlieren.
{{< gallery match="images/1/*.jpg" >}}

## Schritt 1: Arbeitsordner erstellen
Mit diesem Befehl erstellen Sie einen temporären Arbeitsordner:
{{< terminal >}}
mkdir /tmp/bilder
{{</ terminal >}}

Heimdall ist ein Dienst, mit den man Bookmarks via Dashboard verwalten kann. Da ich „Docker for Desktop“ nutze, muss ich nur diese Docker-Compose-Datei in einen lokalen Ordner legen:
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

Diese Datei wird via Docker-Compose gestartet:
{{< terminal >}}
ocker-compose -f compose-file.yml up -d
{{</ terminal >}}
{{< gallery match="images/2/*.png" >}}

