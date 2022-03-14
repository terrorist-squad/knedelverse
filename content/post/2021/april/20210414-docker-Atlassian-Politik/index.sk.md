+++
date = "2021-04-14"
title = "Uncool with Atlassian: ako sa vysporiadať so zásadami spoločnosti Atlassian"
difficulty = "level-3"
tags = ["atlassian", "Atlassian-Politik", "bamboo", "Docker", "confluence", "docker-compose", "jira", "lizenz", "krise", "politik"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/april/20210414-docker-Atlassian-Politik/index.sk.md"
+++
Spoločnosť Atlassian prestala predávať licencie na malé servery a ja som dlho premýšľal, ako to vyriešiť. Keďže chcem svoju inštaláciu ešte dlho používať, zaviedol som nasledujúce opatrenia:
## Opatrenie 1: Používam výlučne Docker
Všetky nástroje Atlassian používam ako kontajnery Docker. Staršie, pôvodné inštalácie je možné preniesť do inštalácie Docker aj prostredníctvom databázových skládok. Tie potom môžete pohodlne spustiť na zariadení intel Nuc alebo diskovej stanici Synology v domácom laboratóriu.
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


## Opatrenie 2: Zálohovanie databáz a obrazov
Samozrejme, v mojej stratégii obnovy po havárii zohráva veľkú úlohu každodenné decentralizované zálohovanie databáz. Ale zálohoval som aj inštalačné obrazy. Obraz nástroja Docker môžete archivovať pomocou nasledujúceho príkazu:
{{< terminal >}}
docker save -o bamboo-7.2.3-image.tar atlassian/bamboo-server

{{</ terminal >}}
Archív možno načítať do registra Docker takto.
{{< terminal >}}
ocker load -i bamboo-7.2.3-image.tar

{{</ terminal >}}
Uložil som aj obrazy systému Postgres.
## Akcia 3: Vytvorenie inštalačného kľúča USB
Zálohoval som si dokumentáciu, všetky inštalačné archívy, dátové adresáre Postgresu a konfigurácie na USB kľúč. Ako som povedal, zálohovanie DB je v skutočnosti najdôležitejšie, pretože aktivovaná licencia je tiež v databáze.
{{< gallery match="images/1/*.png" >}}
