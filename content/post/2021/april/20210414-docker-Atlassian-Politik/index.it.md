+++
date = "2021-04-14"
title = "Uncool con Atlassian: come affrontare la politica di Atlassian"
difficulty = "level-3"
tags = ["atlassian", "Atlassian-Politik", "bamboo", "Docker", "confluence", "docker-compose", "jira", "lizenz", "krise", "politik"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210414-docker-Atlassian-Politik/index.it.md"
+++
Atlassian ha smesso di vendere le licenze per piccoli server e ho pensato a lungo a come affrontare la cosa. Dal momento che voglio ancora utilizzare la mia installazione per molto tempo, ho implementato le seguenti misure:
## Misura 1: uso esclusivamente Docker
Eseguo tutti gli strumenti Atlassian come contenitori Docker. Le vecchie installazioni native possono anche essere trasferite a un'installazione Docker attraverso i dump dei database. Questi possono poi essere eseguiti comodamente su un intel Nuc o una stazione disco Synology nell'Homelab.
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


## Misura 2: backup dei database e delle immagini
Naturalmente, i backup quotidiani e decentralizzati dei database giocano un ruolo importante nella mia strategia di disaster recovery. Ma ho anche fatto il backup delle immagini di installazione. Un'immagine Docker può essere archiviata con il seguente comando:
{{< terminal >}}
docker save -o bamboo-7.2.3-image.tar atlassian/bamboo-server

{{</ terminal >}}
L'archivio può essere caricato nel registro Docker come segue.
{{< terminal >}}
ocker load -i bamboo-7.2.3-image.tar

{{</ terminal >}}
Ho anche salvato le immagini di Postgres.
## Azione 3: creare una chiavetta di installazione USB
Ho fatto il backup della mia documentazione, tutti gli archivi di installazione, le directory dei dati Postgres e le configurazioni su una chiavetta USB. Come ho detto, il backup del DB è in realtà la cosa più importante perché la licenza attivata è anche nel database.
{{< gallery match="images/1/*.png" >}}
