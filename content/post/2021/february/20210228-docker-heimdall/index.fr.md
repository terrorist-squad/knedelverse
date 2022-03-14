+++
date = "2021-02-28"
title = "Du grand avec des conteneurs : Heimdall comme page d'accueil"
difficulty = "level-3"
tags = ["dienste", "Docker", "docker-compose", "docker-for-desktop", "heimdall", "homepage", "startseite"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/february/20210228-docker-heimdall/index.fr.md"
+++
Je gère de nombreux services dans mon réseau Homelab, par exemple LDAP, Gitlab, Atlassian Bamboo, Atlassian Confluence, Atlassian Jira, Jenkins, WordPress, Grafana, Graylog, ESXI/VMware, Calibre et bien d'autres. Il y a de quoi se perdre.
{{< gallery match="images/1/*.jpg" >}}

## Étape 1 : Créer un dossier de travail
Cette commande permet de créer un dossier de travail temporaire :
{{< terminal >}}
mkdir /tmp/bilder

{{</ terminal >}}
Heimdall est un service qui permet de gérer les marque-pages via le tableau de bord. Comme j'utilise "Docker for Desktop", il me suffit de placer ce fichier Docker Compose dans un dossier local :
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
Ce fichier est lancé via Docker-Compose :
{{< terminal >}}
ocker-compose -f compose-file.yml up -d

{{</ terminal >}}

{{< gallery match="images/2/*.png" >}}
