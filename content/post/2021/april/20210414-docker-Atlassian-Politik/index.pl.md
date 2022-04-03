+++
date = "2021-04-14"
title = "Niefajnie z Atlassian: jak radzić sobie z polityką Atlassian"
difficulty = "level-3"
tags = ["atlassian", "Atlassian-Politik", "bamboo", "Docker", "confluence", "docker-compose", "jira", "lizenz", "krise", "politik"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210414-docker-Atlassian-Politik/index.pl.md"
+++
Atlassian zaprzestał sprzedaży licencji na małe serwery i długo zastanawiałem się, jak sobie z tym poradzić. Ponieważ chcę jeszcze przez długi czas korzystać z mojej instalacji, zastosowałem następujące środki zaradcze:
## Środek 1: Używam wyłącznie Dockera
Wszystkie narzędzia firmy Atlassian uruchamiam jako kontenery Docker. Starsze, natywne instalacje można również przenieść do instalacji Docker za pomocą zrzutów baz danych. Można je następnie wygodnie uruchamiać na stacji dysków intel Nuc lub Synology w domowym laboratorium.
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


## Środek 2: Kopie zapasowe baz danych i obrazów
Oczywiście codzienne, zdecentralizowane kopie zapasowe baz danych odgrywają dużą rolę w mojej strategii odzyskiwania danych po awarii. Utworzyłem też kopię zapasową obrazów instalacyjnych. Obraz Dockera można zarchiwizować za pomocą następującego polecenia:
{{< terminal >}}
docker save -o bamboo-7.2.3-image.tar atlassian/bamboo-server

{{</ terminal >}}
Archiwum można załadować do rejestru Docker w następujący sposób.
{{< terminal >}}
ocker load -i bamboo-7.2.3-image.tar

{{</ terminal >}}
Zapisałem także obrazy Postgres.
## Czynność 3: Utwórz pamięć instalacyjną USB
Wykonałem kopię zapasową dokumentacji, wszystkich archiwów instalacyjnych, katalogów danych Postgres i konfiguracji na nośniku USB. Jak już wspomniałem, najważniejsza jest kopia zapasowa DB, ponieważ aktywowana licencja znajduje się również w bazie danych.
{{< gallery match="images/1/*.png" >}}

