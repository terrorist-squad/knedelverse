+++
date = "2021-04-14"
title = "Uncool az Atlassiannal: hogyan kezeljük az Atlassian szabályzatát?"
difficulty = "level-3"
tags = ["atlassian", "Atlassian-Politik", "bamboo", "Docker", "confluence", "docker-compose", "jira", "lizenz", "krise", "politik"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210414-docker-Atlassian-Politik/index.hu.md"
+++
Az Atlassian leállította a kis szerverlicencek értékesítését, és már régóta gondolkodtam azon, hogyan kezeljem ezt a helyzetet. Mivel még sokáig szeretném használni a telepítésemet, a következő intézkedéseket hajtottam végre:
## 1. intézkedés: Kizárólag Dockert használok
Minden Atlassian eszközt Docker-konténerként futtatok. A régebbi, natív telepítések is átvihetők egy Docker-telepítésbe adatbázis-dömpinggel. Ezek aztán kényelmesen futtathatók egy intel Nuc vagy egy Synology lemezállomáson a Homelabban.
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


## 2. intézkedés: Az adatbázisok és a képek biztonsági mentései
Természetesen a napi, decentralizált adatbázis-biztosítások nagy szerepet játszanak a katasztrófa utáni helyreállítási stratégiámban. De a telepítési képekről is készítettem biztonsági másolatot. Egy Docker-képet a következő paranccsal lehet archiválni:
{{< terminal >}}
docker save -o bamboo-7.2.3-image.tar atlassian/bamboo-server

{{</ terminal >}}
Az archívum a következőképpen tölthető be a Docker Registrybe.
{{< terminal >}}
ocker load -i bamboo-7.2.3-image.tar

{{</ terminal >}}
A Postgres-képeket is elmentettem.
## 3. művelet: USB telepítő pendrive létrehozása
Biztonsági mentést készítettem a dokumentációmról, az összes telepítési archívumról, a Postgres adatkönyvtárakról és a konfigurációkról egy USB-pendrive-ra. Mint mondtam, az adatbázis biztonsági mentése a legfontosabb, mivel az aktivált licenc is az adatbázisban van.
{{< gallery match="images/1/*.png" >}}
