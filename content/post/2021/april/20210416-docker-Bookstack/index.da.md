+++
date = "2021-04-16"
title = "Store ting med containere: Din egen Bookstack Wiki på Synology DiskStation"
difficulty = "level-1"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "bookstack", "wiki"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/april/20210416-docker-Bookstack/index.da.md"
+++
Bookstack er et "open source"-alternativ til MediaWiki eller Confluence. I dag viser jeg, hvordan man installerer en Bookstack-tjeneste på Synology diskstationen.
## Mulighed for fagfolk
Som erfaren Synology-bruger kan du naturligvis logge ind med SSH og installere hele opsætningen via Docker Compose-filen.
```
version: '3'
services:
  bookstack:
    image: solidnerd/bookstack:0.27.4-1
    restart: always
    ports:
      - 8080:8080
    links:
      - database
    environment:
      DB_HOST: database:3306
      DB_DATABASE: my_wiki
      DB_USERNAME: wikiuser
      DB_PASSWORD: my_wiki_pass
      
  database:
    image: mariadb
    restart: always
    volumes:
       - ./mysql:/var/lib/mysql
    environment:
      MYSQL_ROOT_PASSWORD: my_wiki_pass1
      MYSQL_DATABASE: my_wiki
      MYSQL_USER: wikiuser
      MYSQL_PASSWORD: my_wiki_pass

```
Flere nyttige Docker-aftryk til hjemmebrug findes i [Dockerverse]({{< ref "dockerverse" >}} "Dockerverse").
## Trin 1: Forbered mappen med bogstakken
Jeg opretter en ny mappe med navnet "wiki" i Docker-mappen.
{{< gallery match="images/1/*.png" >}}

## Trin 2: Installer databasen
Herefter skal der oprettes en database. Jeg klikker på fanen "Registration" i Synology Docker-vinduet og søger efter "mariadb". Jeg vælger Docker-image "mariadb" og klikker derefter på tagget "latest".
{{< gallery match="images/2/*.png" >}}
Når billedet er downloadet, er det tilgængeligt som et billede. Docker skelner mellem 2 tilstande, container "dynamisk tilstand" og image (fast tilstand). Før vi opretter en container fra billedet, skal der foretages nogle få indstillinger. Jeg dobbeltklikker på mit mariadb-aftryk.
{{< gallery match="images/3/*.png" >}}
Derefter klikker jeg på "Avancerede indstillinger" og aktiverer "Automatisk genstart". Jeg vælger fanen "Volume" og klikker på "Add Folder" (tilføj mappe). Der opretter jeg en ny database-mappe med denne mount-sti "/var/lib/mysql".
{{< gallery match="images/4/*.png" >}}
Under "Portindstillinger" slettes alle porte. Det betyder, at jeg vælger porten "3306" og sletter den med knappen "-".
{{< gallery match="images/5/*.png" >}}
{{<table "table table-striped table-bordered">}}
|Variabelt navn|Værdi|Hvad er det?|
|--- | --- |---|
|TZ	| Europe/Berlin |Tidszone|
|MYSQL_ROOT_PASSWORD	|  my_wiki_pass |Hovedadgangskode for databasen.|
|MYSQL_DATABASE | 	my_wiki	|Dette er databasens navn.|
|MYSQL_USER	|  wikiuser	|Brugernavn til wikidatabasen.|
|MYSQL_PASSWORD	|  my_wiki_pass	|Adgangskode for wiki-database brugeren.|
{{</table>}}
Endelig indtaster jeg disse miljøvariabler:Se:
{{< gallery match="images/6/*.png" >}}
Efter disse indstillinger kan Mariadb-serveren startes! Jeg trykker på "Anvend" overalt.
## Trin 3: Installer Bookstack
Jeg klikker på fanen "Registration" i Synology Docker-vinduet og søger efter "bookstack". Jeg vælger Docker-image "solidnerd/bookstack" og klikker derefter på tagget "latest".
{{< gallery match="images/7/*.png" >}}
Jeg dobbeltklikker på mit Bookstack-billede. Derefter klikker jeg på "Avancerede indstillinger" og aktiverer også "Automatisk genstart" her.
{{< gallery match="images/8/*.png" >}}
Jeg tildeler faste porte til "bookstack"-containeren. Uden faste porte kan det være, at "bookstack-serveren" kører på en anden port efter en genstart. Den første containerport kan slettes. Den anden havn bør huskes.
{{< gallery match="images/9/*.png" >}}
Desuden skal der stadig oprettes et "link" til "mariadb"-containeren. Jeg klikker på fanen "Links" og vælger databasebeholderen. Aliasnavnet skal huskes i forbindelse med wiki-installationen.
{{< gallery match="images/10/*.png" >}}
{{<table "table table-striped table-bordered">}}
|Variabelt navn|Værdi|Hvad er det?|
|--- | --- |---|
|TZ	| Europe/Berlin |Tidszone|
|DB_HOST	| wiki-db:3306	|Alias-navne / container-link|
|DB_DATABASE	| my_wiki |Data fra trin 2|
|DB_USERNAME	| wikiuser |Data fra trin 2|
|DB_PASSWORD	| my_wiki_pass	|Data fra trin 2|
{{</table>}}
Endelig indtaster jeg disse miljøvariabler:Se:
{{< gallery match="images/11/*.png" >}}
Beholderen kan nu startes. Det kan tage noget tid at oprette databasen. Adfærden kan observeres via containeroplysningerne.
{{< gallery match="images/12/*.png" >}}
Jeg kalder Bookstack-serveren med Synologys IP-adresse og min containerport. Login-navnet er "admin@admin.com" og adgangskoden er "password".
{{< gallery match="images/13/*.png" >}}
