+++
date = "2021-04-14"
title = "Niefajnie z Atlassianem: jak poradzić sobie z polityką Atlassiana"
difficulty = "level-3"
tags = ["atlassian", "Atlassian-Politik", "bamboo", "Docker", "confluence", "docker-compose", "jira", "lizenz", "krise", "politik"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210414-docker-Atlassian-Politik/index.pl.md"
+++
Atlassian przestał sprzedawać licencje na małe serwery i długo zastanawiałem się, jak sobie z tym poradzić. Ponieważ chcę jeszcze długo korzystać z mojej instalacji, zastosowałem następujące środki zaradcze:
## Środek 1: Używam wyłącznie Dockera
Wszystkie narzędzia firmy Atlassian uruchamiam jako kontenery Docker. Starsze, natywne instalacje mogą być również przeniesione do instalacji Docker poprzez zrzuty baz danych. Można je następnie wygodnie uruchamiać na intelowskim komputerze Nuc lub stacji dysków Synology w domowym laboratorium.
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
Oczywiście, codzienne, zdecentralizowane kopie zapasowe baz danych odgrywają dużą rolę w mojej strategii odzyskiwania danych po awarii. Ale wykonałem również kopię zapasową obrazów instalacyjnych. Obraz Dockera może zostać zarchiwizowany za pomocą następującego polecenia:
{{< terminal >}}
docker save -o bamboo-7.2.3-image.tar atlassian/bamboo-server

{{</ terminal >}}
Archiwum można załadować do Docker Registry w następujący sposób.
{{< terminal >}}
ocker load -i bamboo-7.2.3-image.tar

{{</ terminal >}}
Zapisałem również obrazy Postgresa.
## Czynność 3: Utwórz pamięć instalacyjną USB
Utworzyłem kopię zapasową dokumentacji, wszystkich archiwów instalacyjnych, katalogów danych Postgres i konfiguracji na nośniku USB. Jak już mówiłem, backup DB jest w rzeczywistości najważniejszą rzeczą, ponieważ aktywowana licencja jest również w bazie danych.
{{< gallery match="images/1/*.png" >}}
