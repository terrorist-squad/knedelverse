+++
date = "2021-04-14"
title = "Uncool con Atlassian: cómo lidiar con la política de Atlassian"
difficulty = "level-3"
tags = ["atlassian", "Atlassian-Politik", "bamboo", "Docker", "confluence", "docker-compose", "jira", "lizenz", "krise", "politik"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/april/20210414-docker-Atlassian-Politik/index.es.md"
+++
Atlassian ha dejado de vender las licencias para servidores pequeños y he estado pensando durante mucho tiempo en cómo afrontar esta situación. Como quiero seguir utilizando mi instalación durante mucho tiempo, he aplicado las siguientes medidas:
## Medida 1: Utilizo exclusivamente Docker
Ejecuto todas las herramientas de Atlassian como contenedores Docker. Las instalaciones nativas más antiguas también se pueden transferir a una instalación Docker mediante volcados de bases de datos. Estos pueden ser ejecutados convenientemente en un Nuc Intel o en una estación de disco Synology en el Homelab.
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


## Medida 2: Copias de seguridad de las bases de datos e imágenes
Por supuesto, las copias de seguridad diarias y descentralizadas de las bases de datos desempeñan un papel importante en mi estrategia de recuperación de desastres. Pero también hice una copia de seguridad de las imágenes de instalación. Una imagen Docker puede ser archivada con el siguiente comando:
{{< terminal >}}
docker save -o bamboo-7.2.3-image.tar atlassian/bamboo-server

{{</ terminal >}}
El archivo se puede cargar en el Registro Docker de la siguiente manera.
{{< terminal >}}
ocker load -i bamboo-7.2.3-image.tar

{{</ terminal >}}
También he guardado las imágenes de Postgres.
## Acción 3: Crear una memoria USB de instalación
He hecho una copia de seguridad de mi documentación, de todos los archivos de instalación, de los directorios de datos de Postgres y de las configuraciones en una memoria USB. Como he dicho, la copia de seguridad de la BD es en realidad lo más importante porque la licencia activada también está en la base de datos.
{{< gallery match="images/1/*.png" >}}
