+++
date = "2021-04-14"
title = "Uncool with Atlassian: jak se vypořádat se zásadami společnosti Atlassian"
difficulty = "level-3"
tags = ["atlassian", "Atlassian-Politik", "bamboo", "Docker", "confluence", "docker-compose", "jira", "lizenz", "krise", "politik"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210414-docker-Atlassian-Politik/index.cs.md"
+++
Atlassian přestal prodávat licence pro malé servery a já jsem dlouho přemýšlel, jak to řešit. Protože chci svou instalaci používat ještě dlouho, provedl jsem následující opatření:
## Opatření 1: Používám výhradně Docker
Všechny nástroje Atlassian používám jako kontejnery Docker. Starší nativní instalace lze do instalace Dockeru přenést také prostřednictvím databázových dumpu. Ty pak lze pohodlně spustit na zařízení intel Nuc nebo na diskové stanici Synology v domácím prostředí.
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


## Opatření 2: Zálohování databází a obrazů
V mé strategii obnovy po havárii samozřejmě hrají velkou roli každodenní decentralizované zálohy databází. Zálohoval jsem však také instalační obrazy. Obraz aplikace Docker lze archivovat pomocí následujícího příkazu:
{{< terminal >}}
docker save -o bamboo-7.2.3-image.tar atlassian/bamboo-server

{{</ terminal >}}
Archiv lze do registru Docker nahrát následujícím způsobem.
{{< terminal >}}
ocker load -i bamboo-7.2.3-image.tar

{{</ terminal >}}
Uložil jsem také obrazy systému Postgres.
## Akce 3: Vytvoření instalační paměti USB
Zálohoval jsem dokumentaci, všechny instalační archivy, datové adresáře Postgresu a konfigurace na USB disk. Jak jsem řekl, záloha DB je vlastně nejdůležitější, protože aktivovaná licence je také v databázi.
{{< gallery match="images/1/*.png" >}}

