+++
date = "2021-02-28"
title = "Grandi cose con i contenitori: Heimdall come homepage"
difficulty = "level-3"
tags = ["dienste", "Docker", "docker-compose", "docker-for-desktop", "heimdall", "homepage", "startseite"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/february/20210228-docker-heimdall/index.it.md"
+++
Eseguo molti servizi nella mia rete Homelab, per esempio LDAP, Gitlab, Atlassian Bamboo, Atlassian Confluence, Atlassian Jira, Jenkins, WordPress, Grafana, Graylog, ESXI/VMware, Calibre e molto altro. È facile perdere il conto di tutto.
{{< gallery match="images/1/*.jpg" >}}

## Passo 1: creare la cartella di lavoro
Usa questo comando per creare una cartella di lavoro temporanea:
{{< terminal >}}
mkdir /tmp/bilder

{{</ terminal >}}
Heimdall è un servizio che permette di gestire i segnalibri tramite Dashboard. Dato che uso Docker for Desktop, ho solo bisogno di mettere questo file Docker Compose in una cartella locale:
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
Questo file viene avviato tramite Docker Compose:
{{< terminal >}}
ocker-compose -f compose-file.yml up -d

{{</ terminal >}}

{{< gallery match="images/2/*.png" >}}
