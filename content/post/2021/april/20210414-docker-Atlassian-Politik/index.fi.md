+++
date = "2021-04-14"
title = "Uncool Atlassianin kanssa: miten toimia Atlassianin politiikan kanssa?"
difficulty = "level-3"
tags = ["atlassian", "Atlassian-Politik", "bamboo", "Docker", "confluence", "docker-compose", "jira", "lizenz", "krise", "politik"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210414-docker-Atlassian-Politik/index.fi.md"
+++
Atlassian on lopettanut pienten palvelinlisenssien myynnin, ja olen miettinyt pitkään, miten toimin tämän asian kanssa. Koska haluan käyttää asennustani vielä pitkään, olen toteuttanut seuraavat toimenpiteet:
## Toimenpide 1: Käytän yksinomaan Dockeria
Käytän kaikkia Atlassianin työkaluja Docker-säiliöinä. Vanhemmat, natiivit asennukset voidaan myös siirtää Docker-asennukseen tietokantadumppien avulla. Näitä voidaan sitten käyttää kätevästi intel Nucissa tai Synologyn levyasemalla kotilaboratoriossa.
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


## Toimenpide 2: Tietokantojen ja kuvien varmuuskopiot.
Päivittäisillä hajautetuilla tietokantojen varmuuskopioinneilla on tietenkin suuri merkitys katastrofista toipumista koskevassa strategiassani. Mutta varmuuskopioin myös asennuskuvat. Docker-kuva voidaan arkistoida seuraavalla komennolla:
{{< terminal >}}
docker save -o bamboo-7.2.3-image.tar atlassian/bamboo-server

{{</ terminal >}}
Arkisto voidaan ladata Docker-rekisteriin seuraavasti.
{{< terminal >}}
ocker load -i bamboo-7.2.3-image.tar

{{</ terminal >}}
Olen myös tallentanut Postgres-kuvat.
## Toimenpide 3: Luo USB-asennustikku
Olen varmuuskopioinut dokumentaationi, kaikki asennusarkistot, Postgres-tietohakemistot ja kokoonpanot USB-tikulle. Kuten sanoin, tietokannan varmuuskopiointi on itse asiassa tärkein asia, koska aktivoitu lisenssi on myös tietokannassa.
{{< gallery match="images/1/*.png" >}}

