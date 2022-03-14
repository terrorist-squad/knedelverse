+++
date = "2021-04-14"
title = "Uncool met Atlassian: hoe om te gaan met het Atlassian beleid"
difficulty = "level-3"
tags = ["atlassian", "Atlassian-Politik", "bamboo", "Docker", "confluence", "docker-compose", "jira", "lizenz", "krise", "politik"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/april/20210414-docker-Atlassian-Politik/index.nl.md"
+++
Atlassian is gestopt met de verkoop van de kleine serverlicenties en ik heb lang nagedacht over hoe dit aan te pakken. Aangezien ik mijn installatie nog lange tijd wil gebruiken, heb ik de volgende maatregelen genomen:
## Maatregel 1: ik gebruik uitsluitend Docker
Ik draai alle Atlassian tools als Docker containers. Oudere, native installaties kunnen ook via databasedumps worden overgezet naar een Docker-installatie. Deze kunnen dan handig worden uitgevoerd op een intel Nuc of een Synology diskstation in het Homelab.
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


## Maatregel 2: Backups van de databases en images
Natuurlijk spelen dagelijkse, gedecentraliseerde databaseback-ups een grote rol in mijn strategie voor disaster recovery. Maar ik heb ook een back-up gemaakt van de installatie beelden. Een Docker image kan gearchiveerd worden met het volgende commando:
{{< terminal >}}
docker save -o bamboo-7.2.3-image.tar atlassian/bamboo-server

{{</ terminal >}}
Het archief kan als volgt in de Docker Registry geladen worden.
{{< terminal >}}
ocker load -i bamboo-7.2.3-image.tar

{{</ terminal >}}
Ik heb ook de Postgres images opgeslagen.
## Actie 3: USB installatiestick maken
Ik heb een backup gemaakt van mijn documentatie, alle installatie archieven, de Postgres data directories en configuraties op een USB stick. Zoals ik al zei, de DB backup is eigenlijk het belangrijkste omdat de geactiveerde licentie ook in de database zit.
{{< gallery match="images/1/*.png" >}}
