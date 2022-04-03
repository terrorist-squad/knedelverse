+++
date = "2021-02-28"
title = "Stora saker med containrar: Heimdall som startsida"
difficulty = "level-3"
tags = ["dienste", "Docker", "docker-compose", "docker-for-desktop", "heimdall", "homepage", "startseite"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/february/20210228-docker-heimdall/index.sv.md"
+++
Jag kör många tjänster i mitt Homelab-nätverk, till exempel LDAP, Gitlab, Atlassian Bamboo, Atlassian Confluence, Atlassian Jira, Jenkins, WordPress, Grafana, Graylog, ESXI/VMware, Calibre och mycket mer. Det är lätt att tappa bort allt.
{{< gallery match="images/1/*.jpg" >}}

## Steg 1: Skapa en arbetsmapp
Använd det här kommandot för att skapa en tillfällig arbetsmapp:
{{< terminal >}}
mkdir /tmp/bilder

{{</ terminal >}}
Heimdall är en tjänst som låter dig hantera bokmärken via Dashboard. Eftersom jag använder Docker for Desktop behöver jag bara lägga den här Docker Compose-filen i en lokal mapp:
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
Den här filen startas via Docker Compose:
{{< terminal >}}
ocker-compose -f compose-file.yml up -d

{{</ terminal >}}

{{< gallery match="images/2/*.png" >}}

