+++
date = "2021-04-14"
title = "Uncool с Atlassian: как справиться с политикой Atlassian"
difficulty = "level-3"
tags = ["atlassian", "Atlassian-Politik", "bamboo", "Docker", "confluence", "docker-compose", "jira", "lizenz", "krise", "politik"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210414-docker-Atlassian-Politik/index.ru.md"
+++
Компания Atlassian прекратила продажу лицензий на небольшие серверы, и я долго думал, как с этим быть. Поскольку я все еще хочу использовать свою установку в течение длительного времени, я предпринял следующие меры:
## Мера 1: Я использую исключительно Docker
Я запускаю все инструменты Atlassian как контейнеры Docker. Старые, собственные установки также могут быть перенесены в установку Docker с помощью дампов баз данных. Затем их можно удобно запустить на intel Nuc или дисковой станции Synology в домашней лаборатории.
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


## Мера 2: Резервные копии баз данных и изображений
Конечно, ежедневное децентрализованное резервное копирование баз данных играет большую роль в моей стратегии аварийного восстановления. Но я также создал резервную копию установочных образов. Образ Docker можно архивировать с помощью следующей команды:
{{< terminal >}}
docker save -o bamboo-7.2.3-image.tar atlassian/bamboo-server

{{</ terminal >}}
Архив можно загрузить в реестр Docker следующим образом.
{{< terminal >}}
ocker load -i bamboo-7.2.3-image.tar

{{</ terminal >}}
Я также сохранил образы Postgres.
## Действие 3: Создание установочного USB-носителя
Я сделал резервную копию документации, всех установочных архивов, каталогов данных Postgres и конфигурации на USB-накопитель. Как я уже сказал, резервное копирование БД на самом деле является наиболее важным, поскольку активированная лицензия также находится в базе данных.
{{< gallery match="images/1/*.png" >}}
