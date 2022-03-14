+++
date = "2021-02-28"
title = "Velké věci s kontejnery: Heimdall jako domovská stránka"
difficulty = "level-3"
tags = ["dienste", "Docker", "docker-compose", "docker-for-desktop", "heimdall", "homepage", "startseite"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/february/20210228-docker-heimdall/index.cs.md"
+++
Ve své síti Homelab provozuji mnoho služeb, například LDAP, Gitlab, Atlassian Bamboo, Atlassian Confluence, Atlassian Jira, Jenkins, WordPress, Grafana, Graylog , ESXI/VMware, Calibre a mnoho dalších. Je snadné ztratit o všem přehled.
{{< gallery match="images/1/*.jpg" >}}

## Krok 1: Vytvoření pracovní složky
Tento příkaz slouží k vytvoření dočasné pracovní složky:
{{< terminal >}}
mkdir /tmp/bilder

{{</ terminal >}}
Heimdall je služba, která umožňuje spravovat záložky prostřednictvím panelu Dashboard. Protože používám Docker for Desktop, musím tento soubor Docker Compose umístit pouze do místní složky:
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
Tento soubor se spouští pomocí nástroje Docker Compose:
{{< terminal >}}
ocker-compose -f compose-file.yml up -d

{{</ terminal >}}

{{< gallery match="images/2/*.png" >}}
