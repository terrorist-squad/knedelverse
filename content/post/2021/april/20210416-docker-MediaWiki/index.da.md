+++
date = "2021-04-16"
title = "Store ting med containere: Installation af din egen MediaWiki på Synology diskstation"
difficulty = "level-1"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "mediawiki", "wiki"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/april/20210416-docker-MediaWiki/index.da.md"
+++
MediaWiki er et PHP-baseret wikisystem, der er gratis tilgængeligt som et open source-produkt. I dag viser jeg, hvordan man installerer en MediaWiki-tjeneste på Synology diskstationen.
## Mulighed for fagfolk
Som erfaren Synology-bruger kan du naturligvis logge ind med SSH og installere hele opsætningen via Docker Compose-filen.
```
version: '3'
services:
  mediawiki:
    image: mediawiki
    restart: always
    ports:
      - 8081:80
    links:
      - database
    volumes:
      - ./images:/var/www/html/images
      # After initial setup, download LocalSettings.php to the same directory as
      # this yaml and uncomment the following line and use compose to restart
      # the mediawiki service
      # - ./LocalSettings.php:/var/www/html/LocalSettings.php

  database:
    image: mariadb
    restart: always
    volumes:
       - ./mysql:/var/lib/mysql
    environment:
      # @see https://phabricator.wikimedia.org/source/mediawiki/browse/master/includes/DefaultSettings.php
      MYSQL_ROOT_PASSWORD: my_wiki_pass1
      MYSQL_DATABASE: my_wiki
      MYSQL_USER: wikiuser
      MYSQL_PASSWORD: my_wiki_pass

```
Flere nyttige Docker-aftryk til hjemmebrug findes i [Dockerverse]({{< ref "dockerverse" >}} "Dockerverse").
## Trin 1: Forbered MediaWiki-mappen
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
|TZ	| Europe/Berlin	|Tidszone|
|MYSQL_ROOT_PASSWORD	| my_wiki_pass	|Hovedadgangskode for databasen.|
|MYSQL_DATABASE |	my_wiki	|Dette er databasens navn.|
|MYSQL_USER	| wikiuser |Brugernavn til wikidatabasen.|
|MYSQL_PASSWORD	| my_wiki_pass |Adgangskode for wiki-database brugeren.|
{{</table>}}
Endelig indtaster jeg disse miljøvariabler:Se:
{{< gallery match="images/6/*.png" >}}
Efter disse indstillinger kan Mariadb-serveren startes! Jeg trykker på "Anvend" overalt.
## Trin 3: Installer MediaWiki
Jeg klikker på fanen "Registration" i Synology Docker-vinduet og søger efter "mediawiki". Jeg vælger Docker-image "mediawiki" og klikker derefter på tagget "latest".
{{< gallery match="images/7/*.png" >}}
Jeg dobbeltklikker på mit Mediawiki-billede.
{{< gallery match="images/8/*.png" >}}
Derefter klikker jeg på "Avancerede indstillinger" og aktiverer også "Automatisk genstart" her. Jeg vælger fanen "Volume" og klikker på "Add Folder" (tilføj mappe). Der opretter jeg en ny mappe med denne mount-sti "/var/www/html/images".
{{< gallery match="images/9/*.png" >}}
Jeg tildeler faste porte til "MediaWiki"-containeren. Uden faste porte kan det være, at "MediaWiki-serveren" kører på en anden port efter en genstart.
{{< gallery match="images/10/*.png" >}}
Desuden skal der stadig oprettes et "link" til "mariadb"-containeren. Jeg klikker på fanen "Links" og vælger databasebeholderen. Aliasnavnet skal huskes i forbindelse med wiki-installationen.
{{< gallery match="images/11/*.png" >}}
Endelig indtaster jeg en miljøvariabel "TZ" med værdien "Europe/Berlin".
{{< gallery match="images/12/*.png" >}}
Beholderen kan nu startes. Jeg kalder Mediawiki-serveren med Synologys IP-adresse og min containerport. Under Databaseserver indtaster jeg alias-navnet for databasecontaineren. Jeg indtaster også databasens navn, brugernavn og adgangskode fra "Trin 2".
{{< gallery match="images/13/*.png" >}}