+++
date = "2021-04-14"
title = "Des choses pas cool avec Atlassian : comment gérer la politique d'Atlassian"
difficulty = "level-3"
tags = ["atlassian", "Atlassian-Politik", "bamboo", "Docker", "confluence", "docker-compose", "jira", "lizenz", "krise", "politik"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210414-docker-Atlassian-Politik/index.fr.md"
+++
Atlassian a cessé de vendre les petites licences serveur et j'ai longuement réfléchi à la manière de gérer cette situation. Comme je veux continuer à utiliser mon installation pendant longtemps, j'ai mis en place les mesures suivantes :
## Mesure 1 : j'utilise exclusivement Docker
J'exploite tous les outils Atlassian sous forme de conteneurs Docker. Même les anciennes installations natives peuvent être transformées en installations Docker via des dumps de bases de données. Celles-ci peuvent ensuite être facilement exploitées sur un intel Nuc ou une station de disque Synology dans le Homelab.
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


## Action 2 : sauvegarder les bases de données et les images
Bien sûr, les sauvegardes quotidiennes et décentralisées des bases de données jouent un rôle important dans ma stratégie de reprise après sinistre. Mais j'ai également sauvegardé les images d'installation. Une image Docker peut être archivée avec la commande suivante :
{{< terminal >}}
docker save -o bamboo-7.2.3-image.tar atlassian/bamboo-server

{{</ terminal >}}
L'archive peut être chargée dans le registre Docker de la manière suivante.
{{< terminal >}}
ocker load -i bamboo-7.2.3-image.tar

{{</ terminal >}}
J'ai également sauvegardé les images Postgres.
## Action 3 : créer une clé USB d'installation
J'ai sauvegardé ma documentation, toutes les archives d'installation, les répertoires de données Postgres et les configurations sur une clé USB. Comme je l'ai dit, la sauvegarde de la base de données est en fait la plus importante, car la licence activée se trouve également dans la base de données.
{{< gallery match="images/1/*.png" >}}
