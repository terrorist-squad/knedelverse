+++
date = "2021-02-28"
title = "Grandes cosas con contenedores: Heimdall como página de inicio"
difficulty = "level-3"
tags = ["dienste", "Docker", "docker-compose", "docker-for-desktop", "heimdall", "homepage", "startseite"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/february/20210228-docker-heimdall/index.es.md"
+++
Ejecuto muchos servicios en mi red de Homelab, por ejemplo LDAP, Gitlab, Atlassian Bamboo, Atlassian Confluence, Atlassian Jira, Jenkins, WordPress, Grafana, Graylog ,ESXI/VMware, Calibre y mucho más. Es fácil perder la cuenta de todo.
{{< gallery match="images/1/*.jpg" >}}

## Paso 1: Crear la carpeta de trabajo
Utilice este comando para crear una carpeta de trabajo temporal:
{{< terminal >}}
mkdir /tmp/bilder

{{</ terminal >}}
Heimdall es un servicio que permite gestionar los marcadores a través de Dashboard. Como uso Docker para el escritorio, sólo necesito poner este archivo Docker Compose en una carpeta local:
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
Este archivo se inicia a través de Docker Compose:
{{< terminal >}}
ocker-compose -f compose-file.yml up -d

{{</ terminal >}}

{{< gallery match="images/2/*.png" >}}
