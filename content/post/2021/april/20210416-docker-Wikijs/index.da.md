+++
date = "2021-04-16"
title = "Store ting med containere: Installation af Wiki.js på Synology Diskstation"
difficulty = "level-1"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "wikijs", "wiki"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210416-docker-Wikijs/index.da.md"
+++
Wiki.js er en kraftfuld open source-wikisoftware, der gør dokumentation til en fornøjelse med sin enkle grænseflade. I dag viser jeg, hvordan man installerer en Wiki.js-tjeneste på Synology DiskStation.
## Mulighed for fagfolk
Som erfaren Synology-bruger kan du naturligvis logge ind med SSH og installere hele opsætningen via Docker Compose-filen.
```
version: '3'
services:
  wikijs:
    image: requarks/wiki:latest
    restart: always
    ports:
      - 8082:3000
    links:
      - database
    environment:
      DB_TYPE: mysql
      DB_HOST: database
      DB_PORT: 3306
      DB_NAME: my_wiki
      DB_USER: wikiuser
      DB_PASS: my_wiki_pass
      TZ: 'Europe/Berlin'

  database:
    image: mysql
    restart: always
    expose:
      - 3306
    volumes:
       - ./mysql:/var/lib/mysql
    environment:
      MYSQL_ROOT_PASSWORD: my_wiki_pass
      MYSQL_DATABASE: my_wiki
      MYSQL_USER: wikiuser
      MYSQL_PASSWORD: my_wiki_pass

```
Du kan finde flere nyttige Docker-images til hjemmebrug i Dockerverse.
## Trin 1: Forbered wikimappe
Jeg opretter en ny mappe med navnet "wiki" i Docker-mappen.
{{< gallery match="images/1/*.png" >}}

## Trin 2: Installer databasen
Herefter skal der oprettes en database. Jeg klikker på fanen "Registration" i Synology Docker-vinduet og søger efter "mysql". Jeg vælger Docker-image "mysql" og klikker derefter på tagget "latest".
{{< gallery match="images/2/*.png" >}}
Når billedet er downloadet, er det tilgængeligt som et billede. Docker skelner mellem 2 tilstande, container "dynamisk tilstand" og image (fast tilstand). Før vi opretter en container fra billedet, skal der foretages nogle få indstillinger. Jeg dobbeltklikker på mit mysql-aftryk.
{{< gallery match="images/3/*.png" >}}
Derefter klikker jeg på "Avancerede indstillinger" og aktiverer "Automatisk genstart". Jeg vælger fanen "Volume" og klikker på "Add Folder" (tilføj mappe). Der opretter jeg en ny database-mappe med denne mount-sti "/var/lib/mysql".
{{< gallery match="images/4/*.png" >}}
Under "Portindstillinger" slettes alle porte. Det betyder, at jeg vælger porten "3306" og sletter den med knappen "-".
{{< gallery match="images/5/*.png" >}}
{{<table "table table-striped table-bordered">}}
|Variabelt navn|Værdi|Hvad er det?|
|--- | --- |---|
|TZ	| Europe/Berlin |Tidszone|
|MYSQL_ROOT_PASSWORD	| my_wiki_pass |Hovedadgangskode for databasen.|
|MYSQL_DATABASE |	my_wiki |Dette er databasens navn.|
|MYSQL_USER	| wikiuser |Brugernavn til wikidatabasen.|
|MYSQL_PASSWORD |	my_wiki_pass	|Adgangskode for wiki-database brugeren.|
{{</table>}}
Endelig indtaster jeg disse fire miljøvariabler:Se:
{{< gallery match="images/6/*.png" >}}
Efter disse indstillinger kan Mariadb-serveren startes! Jeg trykker på "Anvend" overalt.
## Trin 3: Installer Wiki.js
Jeg klikker på fanen "Registrering" i Synology Docker-vinduet og søger efter "wiki". Jeg vælger Docker-image "requarks/wiki" og klikker derefter på tagget "latest".
{{< gallery match="images/7/*.png" >}}
Jeg dobbeltklikker på mit WikiJS-billede. Derefter klikker jeg på "Avancerede indstillinger" og aktiverer også "Automatisk genstart" her.
{{< gallery match="images/8/*.png" >}}
Jeg tildeler faste porte til "WikiJS"-containeren. Uden faste porte kan det være, at "bookstack-serveren" kører på en anden port efter en genstart.
{{< gallery match="images/9/*.png" >}}
Desuden skal der stadig oprettes et "link" til "mysql"-containeren. Jeg klikker på fanen "Links" og vælger databasebeholderen. Aliasnavnet skal huskes i forbindelse med wiki-installationen.
{{< gallery match="images/10/*.png" >}}
{{<table "table table-striped table-bordered">}}
|Variabelt navn|Værdi|Hvad er det?|
|--- | --- |---|
|TZ	| Europe/Berlin	|Tidszone|
|DB_HOST	| wiki-db	|Alias-navne / container-link|
|DB_TYPE	| mysql	||
|DB_PORT	| 3306	 ||
|DB_PASSWORD	| my_wiki	|Data fra trin 2|
|DB_USER	| wikiuser |Data fra trin 2|
|DB_PASS	| my_wiki_pass	|Data fra trin 2|
{{</table>}}
Endelig indtaster jeg disse miljøvariabler:Se:
{{< gallery match="images/11/*.png" >}}
Beholderen kan nu startes. Jeg kalder Wiki.js-serveren med Synologys IP-adresse og min containerport/3000.
{{< gallery match="images/12/*.png" >}}
