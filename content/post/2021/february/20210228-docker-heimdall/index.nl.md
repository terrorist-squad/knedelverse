+++
date = "2021-02-28"
title = "Grote dingen met containers: Heimdall als startpagina"
difficulty = "level-3"
tags = ["dienste", "Docker", "docker-compose", "docker-for-desktop", "heimdall", "homepage", "startseite"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/february/20210228-docker-heimdall/index.nl.md"
+++
Ik draai veel diensten in mijn Homelab netwerk, bijvoorbeeld LDAP, Gitlab, Atlassian Bamboo, Atlassian Confluence, Atlassian Jira, Jenkins, WordPress, Grafana, Graylog, ESXI/VMware, Calibre en nog veel meer. Het is makkelijk om alles uit het oog te verliezen.
{{< gallery match="images/1/*.jpg" >}}

## Stap 1: Maak een werkmap
Gebruik dit commando om een tijdelijke werkmap te maken:
{{< terminal >}}
mkdir /tmp/bilder

{{</ terminal >}}
Heimdall is een dienst waarmee u bladwijzers kunt beheren via het Dashboard. Aangezien ik Docker voor Desktop gebruik, hoef ik dit Docker Compose bestand alleen in een lokale map te zetten:
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
Dit bestand wordt gestart via Docker Compose:
{{< terminal >}}
ocker-compose -f compose-file.yml up -d

{{</ terminal >}}

{{< gallery match="images/2/*.png" >}}
