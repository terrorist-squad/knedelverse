+++
date = "2021-04-14"
title = "Безпроблемно с Atlassian: как да се справите с политиката на Atlassian"
difficulty = "level-3"
tags = ["atlassian", "Atlassian-Politik", "bamboo", "Docker", "confluence", "docker-compose", "jira", "lizenz", "krise", "politik"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210414-docker-Atlassian-Politik/index.bg.md"
+++
Atlassian спря да продава лицензите за малки сървъри и аз дълго време мислех как да се справя с това. Тъй като все още искам да използвам инсталацията си дълго време, приложих следните мерки:
## Мярка 1: Използвам изключително Docker
Използвам всички инструменти на Atlassian като контейнери Docker. По-старите, собствени инсталации могат да бъдат прехвърлени в инсталация на Docker чрез сваляне на бази данни. След това те могат да бъдат удобно стартирани на intel Nuc или на дискова станция Synology в домашната лаборатория.
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


## Мярка 2: Резервни копия на базите данни и изображенията
Разбира се, ежедневните децентрализирани резервни копия на бази данни играят важна роля в моята стратегия за възстановяване след бедствие. Но също така създадох резервно копие на инсталационните изображения. Образът на Docker може да бъде архивиран със следната команда:
{{< terminal >}}
docker save -o bamboo-7.2.3-image.tar atlassian/bamboo-server

{{</ terminal >}}
Архивът може да бъде зареден в регистъра на Docker по следния начин.
{{< terminal >}}
ocker load -i bamboo-7.2.3-image.tar

{{</ terminal >}}
Запазих и образите на Postgres.
## Действие 3: Създаване на USB инсталационна флашка
Създадох резервно копие на документацията си, всички инсталационни архиви, директориите с данни и конфигурациите на Postgres на USB памет. Както казах, резервното копие на БД всъщност е най-важното нещо, защото активираният лиценз също е в базата данни.
{{< gallery match="images/1/*.png" >}}

