+++
date = "2021-04-14"
title = "Uncooles mit Atlassian: wie gehe ich mit der Atlassian-Politik um"
difficulty = "level-3"
tags = ["atlassian", "Atlassian-Politik", "bamboo", "Docker", "confluence", "docker-compose", "jira", "lizenz", "krise", "politik"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/april/20210414-docker-Atlassian-Politik/index.de.md"
+++

Atlassian hat den Verkauf der kleinen Serverlizenzen eingestellt und ich habe lange überlegt, wie ich damit umgehe. Da ich meine Installation noch lange nutzen will, habe ich folgende Maßnahmen umgesetzt:

## Maßnahme 1: Ich nutze ausschließlich Docker
Ich betreibe alle Atlassian-Tools als Docker-Container. Auch ältere, native Installation lassen sich über Datenbank-Dumps in eine Docker-Installation überführen. Diese lassen sich dann bequem auf einen intel Nuc oder einer Synology-Diskstation im Homelab betreiben.

{{< tabs>}}
{{< tab "Jira">}}
```
version: '2'
services:
  jira:
    image: atlassian/jira-software
    container_name: jira_application
    depends_on:
      - db
    restart: always
    environment:
      TZ: 'Europe/Berlin'
    ports:
      - 8080:8080
    volumes:
      - ./jira-data:/var/atlassian/application-data/jira
    networks:
      - jira-network
      
  db:
    restart: always
    image: postgres:latest
    container_name: jira_db
    volumes:
      - ./postgresql:/var/lib/postgresql/data
    environment:
      - POSTGRES_USER=jira
      - POSTGRES_PASSWORD=jirapass
      - POSTGRES_DB=jira
    networks:
      - jira-network

networks:
  jira-network:

```
{{< /tab >}}

{{< tab"Confluence">}}
```
version: '2'
services:
  confluence:
    container_name: confluence_server
    image: atlassian/confluence-server:latest
    restart: always
    environment:
      TZ: "Europe/Berlin"
    volumes:
      - ./confluence:/var/atlassian/application-data/confluence/
    ports:
      - 8080:8080
    networks:
      - confluence-network
    depends_on:
      - db

  db:
    image: postgres:latest
    container_name: confluence_postgres
    restart: always
    volumes:
      - /postgresql:/var/lib/postgresql/data
    environment:
      - POSTGRES_USER=confluencedb
      - POSTGRES_PASSWORD=confluence-password
      - POSTGRES_DB=confluenceUser
    networks:
      - confluence-network

networks:
  confluence-network:
```
{{< /tab >}}
{{< tab"Bamboo">}}
```
version: '2'

services:
  bamboo:
    container_name: bamboo_server
    image: atlassian/bamboo-server
    restart: always
    environment:
      TZ: "Europe/Berlin"
    volumes:
      - ./bamboo-data:/var/atlassian/application-data/bamboo
    ports:
      - 8080:8080
    networks:
      - bamboo-network
    depends_on:
      - db

  db:
    image: postgres:latest
    container_name: bamboo-postgres
    restart: always
    volumes:
      - ./postgresql:/var/lib/postgresql/data
    environment:
      - POSTGRES_USER=bamboo
      - POSTGRES_PASSWORD=bamboo
      - POSTGRES_DB=bamboo
    networks:
      - bamboo-network

networks:
  bamboo-network:

```
{{< /tab >}}
{{< /tabs >}}

## Maßnahme 2: Backups der Datenbanken und Images
Natürlich spielen tägliche, dezentrale Datenbankbackup eine große Rolle in meiner Disaster-Recovery-Strategie. Aber auch die Installations-Images wurden von mir gesichert. Ein Docker Image lässt sich mit folgendem Befehl archivieren:
{{< terminal >}}
docker save -o bamboo-7.2.3-image.tar atlassian/bamboo-server
{{</ terminal >}}

Das Archiv kann wie folgt in die Docker-Registry geladen werden.

{{< terminal >}}
ocker load -i bamboo-7.2.3-image.tar
{{</ terminal >}}

Auch die Postgres-Images habe ich mir gesichert.

## Maßnahme 3: USB-Installation-Stick erstellen
Ich habe meine Doku, alle Installations-Archive, die Postgres-Datenverzeichnisse und Konfigurationen auf einen USB-Stick gesichert. Wie gesagt, die DB-Sicherung ist eigentlich das wichtigste, weil auch die aktivierte Lizenz in der Datenbank steckt.
{{< gallery match="images/1/*.png" >}}
