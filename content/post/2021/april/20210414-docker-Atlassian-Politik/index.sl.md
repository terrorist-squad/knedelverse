+++
date = "2021-04-14"
title = "Neprijetno z družbo Atlassian: kako ravnati s politiko družbe Atlassian"
difficulty = "level-3"
tags = ["atlassian", "Atlassian-Politik", "bamboo", "Docker", "confluence", "docker-compose", "jira", "lizenz", "krise", "politik"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210414-docker-Atlassian-Politik/index.sl.md"
+++
Atlassian je prenehal prodajati licence za majhne strežnike in dolgo sem razmišljal, kako to rešiti. Ker želim še dolgo uporabljati svojo namestitev, sem izvedel naslednje ukrepe:
## Ukrep 1: Uporabljam izključno Docker
Vsa Atlassianova orodja uporabljam kot vsebnike Docker. Starejše izvirne namestitve lahko prenesete v namestitev Docker tudi z izpisi podatkovnih zbirk. Te lahko nato priročno zaženete na računalniku intel Nuc ali diskovni postaji Synology v domačem laboratoriju.
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


## Ukrep 2: Varnostne kopije podatkovnih zbirk in slik
Seveda imajo v moji strategiji za obnovitev po nesreči veliko vlogo dnevne decentralizirane varnostne kopije podatkovnih zbirk. Vendar sem naredil tudi varnostno kopijo namestitvenih slik. Sliko Docker lahko arhivirate z naslednjim ukazom:
{{< terminal >}}
docker save -o bamboo-7.2.3-image.tar atlassian/bamboo-server

{{</ terminal >}}
Arhiv lahko naložite v register Docker na naslednji način.
{{< terminal >}}
ocker load -i bamboo-7.2.3-image.tar

{{</ terminal >}}
Shranil sem tudi slike Postgresa.
## Ukrep 3: Ustvarite namestitveni ključek USB
Dokumentacijo, vse namestitvene arhive, podatkovne imenike Postgresa in konfiguracije sem varnostno kopiral na ključ USB. Kot sem rekel, je varnostna kopija DB pravzaprav najpomembnejša, saj je aktivirana licenca tudi v zbirki podatkov.
{{< gallery match="images/1/*.png" >}}

