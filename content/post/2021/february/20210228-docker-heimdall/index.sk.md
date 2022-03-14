+++
date = "2021-02-28"
title = "Veľké veci s kontajnermi: Heimdall ako domovská stránka"
difficulty = "level-3"
tags = ["dienste", "Docker", "docker-compose", "docker-for-desktop", "heimdall", "homepage", "startseite"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/february/20210228-docker-heimdall/index.sk.md"
+++
V sieti Homelab prevádzkujem mnoho služieb, napríklad LDAP, Gitlab, Atlassian Bamboo, Atlassian Confluence, Atlassian Jira, Jenkins, WordPress, Grafana, Graylog , ESXI/VMware, Calibre a mnoho ďalších. Je ľahké stratiť prehľad o všetkom.
{{< gallery match="images/1/*.jpg" >}}

## Krok 1: Vytvorenie pracovného priečinka
Pomocou tohto príkazu vytvorte dočasný pracovný priečinok:
{{< terminal >}}
mkdir /tmp/bilder

{{</ terminal >}}
Heimdall je služba, ktorá vám umožňuje spravovať záložky prostredníctvom panela Dashboard. Keďže používam Docker for Desktop, stačí, ak tento súbor Docker Compose umiestnim do lokálneho priečinka:
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
Tento súbor sa spúšťa prostredníctvom nástroja Docker Compose:
{{< terminal >}}
ocker-compose -f compose-file.yml up -d

{{</ terminal >}}

{{< gallery match="images/2/*.png" >}}
