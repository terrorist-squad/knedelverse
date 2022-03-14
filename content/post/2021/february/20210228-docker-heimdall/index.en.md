+++
date = "2021-02-28"
title = "Great things with containers: Heimdall as home page"
difficulty = "level-3"
tags = ["dienste", "Docker", "docker-compose", "docker-for-desktop", "heimdall", "homepage", "startseite"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/february/20210228-docker-heimdall/index.en.md"
+++
I run many services in my Homelab network, for example LDAP, Gitlab, Atlassian Bamboo, Atlassian Confluence, Atlassian Jira, Jenkins, WordPress, Grafana, Graylog ,ESXI/VMware, Calibre and much more. It's easy to lose track of everything.
{{< gallery match="images/1/*.jpg" >}}

## Step 1: Create working folder
Use this command to create a temporary working folder:
{{< terminal >}}
mkdir /tmp/bilder

{{</ terminal >}}
Heimdall is a service that allows you to manage bookmarks via dashboard. Since I'm using Docker for Desktop, I just need to put this Docker Compose file in a local folder:
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
This file is started via Docker Compose:
{{< terminal >}}
ocker-compose -f compose-file.yml up -d

{{</ terminal >}}

{{< gallery match="images/2/*.png" >}}
