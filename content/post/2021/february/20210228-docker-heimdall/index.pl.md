+++
date = "2021-02-28"
title = "Wspaniałe rzeczy z pojemników: Heimdall jako strona główna"
difficulty = "level-3"
tags = ["dienste", "Docker", "docker-compose", "docker-for-desktop", "heimdall", "homepage", "startseite"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/february/20210228-docker-heimdall/index.pl.md"
+++
W mojej sieci Homelab uruchamiam wiele usług, na przykład LDAP, Gitlab, Atlassian Bamboo, Atlassian Confluence, Atlassian Jira, Jenkins, WordPress, Grafana, Graylog, ESXI/VMware, Calibre i wiele innych. Łatwo jest stracić rachubę wszystkiego.
{{< gallery match="images/1/*.jpg" >}}

## Krok 1: Utwórz folder roboczy
Użyj tego polecenia, aby utworzyć tymczasowy folder roboczy:
{{< terminal >}}
mkdir /tmp/bilder

{{</ terminal >}}
Heimdall to usługa, która pozwala na zarządzanie zakładkami poprzez Dashboard. Ponieważ używam Docker for Desktop, muszę tylko umieścić ten plik Docker Compose w lokalnym folderze:
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
Ten plik jest uruchamiany za pomocą Docker Compose:
{{< terminal >}}
ocker-compose -f compose-file.yml up -d

{{</ terminal >}}

{{< gallery match="images/2/*.png" >}}
