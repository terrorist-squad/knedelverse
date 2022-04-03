+++
date = "2021-04-14"
title = "Uncool cu Atlassian: cum să te descurci cu politica Atlassian"
difficulty = "level-3"
tags = ["atlassian", "Atlassian-Politik", "bamboo", "Docker", "confluence", "docker-compose", "jira", "lizenz", "krise", "politik"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210414-docker-Atlassian-Politik/index.ro.md"
+++
Atlassian a încetat să mai vândă licențe pentru servere mici și mă gândesc de mult timp cum să rezolv această problemă. Deoarece doresc să îmi folosesc instalația pentru o perioadă lungă de timp, am implementat următoarele măsuri:
## Măsura 1: Folosesc exclusiv Docker
Execut toate instrumentele Atlassian ca și containere Docker. De asemenea, instalațiile native mai vechi pot fi transferate într-o instalație Docker prin intermediul descărcărilor de baze de date. Acestea pot fi apoi rulate în mod convenabil pe un Intel Nuc sau pe o stație de discuri Synology în Homelab.
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


## Măsura 2: Copii de siguranță ale bazelor de date și ale imaginilor
Desigur, copiile de rezervă zilnice și descentralizate ale bazelor de date joacă un rol important în strategia mea de recuperare în caz de dezastru. Dar am făcut și o copie de rezervă a imaginilor de instalare. O imagine Docker poate fi arhivată cu următoarea comandă:
{{< terminal >}}
docker save -o bamboo-7.2.3-image.tar atlassian/bamboo-server

{{</ terminal >}}
Arhiva poate fi încărcată în Docker Registry după cum urmează.
{{< terminal >}}
ocker load -i bamboo-7.2.3-image.tar

{{</ terminal >}}
Am salvat și imaginile Postgres.
## Acțiunea 3: Creați un stick de instalare USB
Am făcut o copie de rezervă a documentației, a tuturor arhivelor de instalare, a directoarelor de date Postgres și a configurațiilor pe un stick USB. După cum am spus, copia de rezervă a bazei de date este de fapt cel mai important lucru, deoarece licența activată se află, de asemenea, în baza de date.
{{< gallery match="images/1/*.png" >}}

