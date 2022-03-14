+++
date = "2021-04-14"
title = "Não é legal com a Atlassian: como lidar com a política da Atlassian"
difficulty = "level-3"
tags = ["atlassian", "Atlassian-Politik", "bamboo", "Docker", "confluence", "docker-compose", "jira", "lizenz", "krise", "politik"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/april/20210414-docker-Atlassian-Politik/index.pt.md"
+++
A Atlassian deixou de vender as licenças dos pequenos servidores e eu tenho pensado durante muito tempo sobre como lidar com isto. Como ainda quero usar a minha instalação por muito tempo, implementei as seguintes medidas:
## Medida 1: Eu uso exclusivamente o Docker
Eu dirijo todas as ferramentas Atlassian como contentores Docker. Instalações mais antigas e nativas também podem ser transferidas para uma instalação Docker através de lixeiras de banco de dados. Estes podem então ser convenientemente executados em um Núcleo de informação ou em uma estação de disco Synology no Homelab.
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


## Medida 2: Cópias de segurança das bases de dados e imagens
É claro que os backups diários e descentralizados das bases de dados desempenham um grande papel na minha estratégia de recuperação de desastres. Mas eu também fiz backup das imagens da instalação. Uma imagem Docker pode ser arquivada com o seguinte comando:
{{< terminal >}}
docker save -o bamboo-7.2.3-image.tar atlassian/bamboo-server

{{</ terminal >}}
O arquivo pode ser carregado no Docker Registry da seguinte forma.
{{< terminal >}}
ocker load -i bamboo-7.2.3-image.tar

{{</ terminal >}}
Eu também salvei as imagens do Postgres.
## Acção 3: Criar um stick de instalação USB
Eu fiz backup da minha documentação, de todos os arquivos de instalação, dos diretórios de dados Postgres e das configurações em um pendrive. Como eu disse, o backup do BD é na verdade a coisa mais importante, porque a licença ativada também está na base de dados.
{{< gallery match="images/1/*.png" >}}
