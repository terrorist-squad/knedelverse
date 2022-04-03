+++
date = "2021-04-14"
title = "Uncool med Atlassian: hur man hanterar Atlassians policy"
difficulty = "level-3"
tags = ["atlassian", "Atlassian-Politik", "bamboo", "Docker", "confluence", "docker-compose", "jira", "lizenz", "krise", "politik"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210414-docker-Atlassian-Politik/index.sv.md"
+++
Atlassian har slutat sälja små serverlicenser och jag har länge funderat på hur jag ska hantera detta. Eftersom jag fortfarande vill använda min anläggning under lång tid har jag vidtagit följande åtgärder:
## Åtgärd 1: Jag använder enbart Docker
Jag kör alla Atlassian-verktyg som Docker-containrar. Äldre, ursprungliga installationer kan också överföras till en Docker-installation via databasdumpar. Dessa kan sedan lämpligen köras på en Intel Nuc eller en Synology diskstation i hemlabbet.
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


## Åtgärd 2: Säkerhetskopiering av databaser och bilder
Naturligtvis spelar dagliga, decentraliserade databasbackuper en stor roll i min strategi för katastrofåterställning. Men jag säkerhetskopierade också installationsavbildningarna. En Docker-avbildning kan arkiveras med följande kommando:
{{< terminal >}}
docker save -o bamboo-7.2.3-image.tar atlassian/bamboo-server

{{</ terminal >}}
Arkivet kan laddas in i Docker Registry på följande sätt.
{{< terminal >}}
ocker load -i bamboo-7.2.3-image.tar

{{</ terminal >}}
Jag har också sparat Postgres-bilderna.
## Åtgärd 3: Skapa ett USB-installationsverktyg
Jag har säkerhetskopierat min dokumentation, alla installationsarkiv, Postgres-datakataloger och konfigurationer till ett USB-minne. Som jag sa är backupen av databasen faktiskt det viktigaste eftersom den aktiverade licensen också finns i databasen.
{{< gallery match="images/1/*.png" >}}

