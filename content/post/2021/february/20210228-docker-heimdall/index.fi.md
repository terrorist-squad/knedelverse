+++
date = "2021-02-28"
title = "Suuria asioita säiliöillä: Heimdall kotisivuna"
difficulty = "level-3"
tags = ["dienste", "Docker", "docker-compose", "docker-for-desktop", "heimdall", "homepage", "startseite"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/february/20210228-docker-heimdall/index.fi.md"
+++
Käytän monia palveluja Homelab-verkossani, esimerkiksi LDAP, Gitlab, Atlassian Bamboo, Atlassian Confluence, Atlassian Jira, Jenkins, WordPress, Grafana, Graylog ,ESXI/VMware, Calibre ja paljon muuta. On helppo kadottaa kaikki asiat.
{{< gallery match="images/1/*.jpg" >}}

## Vaihe 1: Luo työkansio
Tällä komennolla voit luoda väliaikaisen työkansion:
{{< terminal >}}
mkdir /tmp/bilder

{{</ terminal >}}
Heimdall on palvelu, jonka avulla voit hallita kirjanmerkkejä Dashboardin kautta. Koska käytän Docker for Desktopia, minun tarvitsee vain laittaa tämä Docker Compose -tiedosto paikalliseen kansioon:
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
Tämä tiedosto käynnistetään Docker Composen kautta:
{{< terminal >}}
ocker-compose -f compose-file.yml up -d

{{</ terminal >}}

{{< gallery match="images/2/*.png" >}}
