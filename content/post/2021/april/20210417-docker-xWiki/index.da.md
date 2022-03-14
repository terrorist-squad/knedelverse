+++
date = "2021-04-17"
title = "Store ting med containere: Kør din egen xWiki på Synology diskstation"
difficulty = "level-1"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "xwiki", "wiki",]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210417-docker-xWiki/index.da.md"
+++
XWiki er en gratis wiki-softwareplatform skrevet i Java og designet med udvidelsesmuligheder i tankerne. I dag viser jeg, hvordan man installerer en xWiki-tjeneste på Synology DiskStation.
## Mulighed for fagfolk
Som erfaren Synology-bruger kan du naturligvis logge ind med SSH og installere hele opsætningen via Docker Compose-filen.
```
version: '3'
services:
  xwiki:
    image: xwiki:10-postgres-tomcat
    restart: always
    ports:
      - 8080:8080
    links:
      - db
    environment:
      DB_HOST: db
      DB_DATABASE: xwiki
      DB_DATABASE: xwiki
      DB_PASSWORD: xwiki
      TZ: 'Europe/Berlin'

  db:
    image: postgres:latest
    restart: always
    volumes:
      - ./postgresql:/var/lib/postgresql/data
    environment:
      - POSTGRES_USER=xwiki
      - POSTGRES_PASSWORD=xwiki
      - POSTGRES_DB=xwiki
      - TZ='Europe/Berlin'

```
Flere nyttige Docker-aftryk til hjemmebrug findes i [Dockerverse]({{< ref "dockerverse" >}} "Dockerverse").
## Trin 1: Forbered wikimappe
Jeg opretter en ny mappe med navnet "wiki" i Docker-mappen.
{{< gallery match="images/1/*.png" >}}

## Trin 2: Installer databasen
Herefter skal der oprettes en database. Jeg klikker på fanen "Registration" i Synology Docker-vinduet og søger efter "postgres". Jeg vælger Docker-image "postgres" og klikker derefter på tagget "latest".
{{< gallery match="images/2/*.png" >}}
Når billedet er downloadet, er det tilgængeligt som et billede. Docker skelner mellem 2 tilstande, container "dynamisk tilstand" og image (fast tilstand). Før vi opretter en container fra billedet, skal der foretages nogle få indstillinger. Jeg dobbeltklikker på mit postgres-aftryk.
{{< gallery match="images/3/*.png" >}}
Derefter klikker jeg på "Avancerede indstillinger" og aktiverer "Automatisk genstart". Jeg vælger fanen "Volume" og klikker på "Add folder" (tilføj mappe). Der opretter jeg en ny database-mappe med denne mount-sti "/var/lib/postgresql/data".
{{< gallery match="images/4/*.png" >}}
Under "Portindstillinger" slettes alle porte. Det betyder, at jeg vælger porten "5432" og sletter den med knappen "-".
{{< gallery match="images/5/*.png" >}}
{{<table "table table-striped table-bordered">}}
|Variabelt navn|Værdi|Hvad er det?|
|--- | --- |---|
|TZ	| Europe/Berlin	|Tidszone|
|POSTGRES_DB	| xwiki |Dette er databasens navn.|
|POSTGRES_USER	| xwiki |Brugernavn til wikidatabasen.|
|POSTGRES_PASSWORD	| xwiki |Adgangskode for wiki-database brugeren.|
{{</table>}}
Endelig indtaster jeg disse fire miljøvariabler:Se:
{{< gallery match="images/6/*.png" >}}
Efter disse indstillinger kan Mariadb-serveren startes! Jeg trykker på "Anvend" overalt.
## Trin 3: Installer xWiki
Jeg klikker på fanen "Registration" i Synology Docker-vinduet og søger efter "xwiki". Jeg vælger Docker-image "xwiki" og klikker derefter på tagget "10-postgres-tomcat".
{{< gallery match="images/7/*.png" >}}
Jeg dobbeltklikker på mit xwiki-billede. Derefter klikker jeg på "Avancerede indstillinger" og aktiverer også "Automatisk genstart" her.
{{< gallery match="images/8/*.png" >}}
Jeg tildeler faste porte til "xwiki"-containeren. Uden faste porte kan det være, at "xwiki-serveren" kører på en anden port efter en genstart.
{{< gallery match="images/9/*.png" >}}
Desuden skal der oprettes et "link" til "postgres"-containeren. Jeg klikker på fanen "Links" og vælger databasebeholderen. Aliasnavnet skal huskes i forbindelse med wiki-installationen.
{{< gallery match="images/10/*.png" >}}
{{<table "table table-striped table-bordered">}}
|Variabelt navn|Værdi|Hvad er det?|
|--- | --- |---|
|TZ |	Europe/Berlin	|Tidszone|
|DB_HOST	| db |Alias-navne / container-link|
|DB_DATABASE	| xwiki	|Data fra trin 2|
|DB_USER	| xwiki	|Data fra trin 2|
|DB_PASSWORD	| xwiki |Data fra trin 2|
{{</table>}}
Endelig indtaster jeg disse miljøvariabler:Se:
{{< gallery match="images/11/*.png" >}}
Beholderen kan nu startes. Jeg kalder xWiki-serveren med Synologys IP-adresse og min containerport.
{{< gallery match="images/12/*.png" >}}