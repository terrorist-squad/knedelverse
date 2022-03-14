+++
date = "2021-04-14"
title = "Ukøligt med Atlassian: hvordan du håndterer Atlassians politik"
difficulty = "level-3"
tags = ["atlassian", "Atlassian-Politik", "bamboo", "Docker", "confluence", "docker-compose", "jira", "lizenz", "krise", "politik"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210414-docker-Atlassian-Politik/index.da.md"
+++
Atlassian er holdt op med at sælge de små serverlicenser, og jeg har længe tænkt over, hvordan jeg skal håndtere dette. Da jeg stadig ønsker at bruge mit anlæg i lang tid, har jeg gennemført følgende foranstaltninger:
## Foranstaltning 1: Jeg bruger udelukkende Docker
Jeg kører alle Atlassian værktøjer som Docker-containere. Ældre, oprindelige installationer kan også overføres til en Docker-installation via databasedumps. Disse kan så nemt køres på en intel Nuc eller en Synology diskstation i Homelab'et.
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


## Foranstaltning 2: Sikkerhedskopiering af databaser og billeder
Selvfølgelig spiller daglige, decentraliserede database-backups en stor rolle i min katastrofeberedskabsstrategi. Men jeg har også sikkerhedskopieret installationsaftrykkene. Et Docker-aftryk kan arkiveres med følgende kommando:
{{< terminal >}}
docker save -o bamboo-7.2.3-image.tar atlassian/bamboo-server

{{</ terminal >}}
Arkivet kan indlæses i Docker Registry på følgende måde.
{{< terminal >}}
ocker load -i bamboo-7.2.3-image.tar

{{</ terminal >}}
Jeg har også gemt Postgres-aftrykkene.
## Aktion 3: Opret USB-installationsenhed
Jeg har sikkerhedskopieret min dokumentation, alle installationsarkiver, Postgres-datakataloger og konfigurationer til et USB-stik. Som sagt er DB-backuppen faktisk det vigtigste, fordi den aktiverede licens også findes i databasen.
{{< gallery match="images/1/*.png" >}}
