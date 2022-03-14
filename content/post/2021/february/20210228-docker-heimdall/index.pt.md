+++
date = "2021-02-28"
title = "Grandes coisas com contentores: Heimdall como homepage"
difficulty = "level-3"
tags = ["dienste", "Docker", "docker-compose", "docker-for-desktop", "heimdall", "homepage", "startseite"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/february/20210228-docker-heimdall/index.pt.md"
+++
Eu executo muitos serviços na minha rede Homelab, por exemplo LDAP, Gitlab, Atlassian Bamboo, Atlassian Confluence, Atlassian Jira, Jenkins, WordPress, Grafana, Graylog ,ESXI/VMware, Calibre e muito mais. É fácil perder a noção de tudo.
{{< gallery match="images/1/*.jpg" >}}

## Passo 1: Criar pasta de trabalho
Use este comando para criar uma pasta de trabalho temporária:
{{< terminal >}}
mkdir /tmp/bilder

{{</ terminal >}}
Heimdall é um serviço que lhe permite gerir marcadores de página através do Painel de Controle. Como eu uso Docker for Desktop, só preciso colocar este arquivo Docker Compose em uma pasta local:
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
Este arquivo é iniciado através do Docker Compose:
{{< terminal >}}
ocker-compose -f compose-file.yml up -d

{{</ terminal >}}

{{< gallery match="images/2/*.png" >}}
