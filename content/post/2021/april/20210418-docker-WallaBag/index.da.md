+++
date = "2021-04-18"
title = "Store ting med containere: Egen WallaBag på Synology diskstation"
difficulty = "level-1"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "archiv", "wallabag"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210418-docker-WallaBag/index.da.md"
+++
Wallabag er et program til arkivering af interessante websteder eller artikler. I dag vil jeg vise, hvordan man installerer en Wallabag-tjeneste på Synology diskstationen.
## Mulighed for fagfolk
Som erfaren Synology-bruger kan du naturligvis logge ind med SSH og installere hele opsætningen via Docker Compose-filen.
```
version: '3'
services:
  wallabag:
    image: wallabag/wallabag
    environment:
      - MYSQL_ROOT_PASSWORD=wallaroot
      - SYMFONY__ENV__DATABASE_DRIVER=pdo_mysql
      - SYMFONY__ENV__DATABASE_HOST=db
      - SYMFONY__ENV__DATABASE_PORT=3306
      - SYMFONY__ENV__DATABASE_NAME=wallabag
      - SYMFONY__ENV__DATABASE_USER=wallabag
      - SYMFONY__ENV__DATABASE_PASSWORD=wallapass
      - SYMFONY__ENV__DATABASE_CHARSET=utf8mb4
      - SYMFONY__ENV__DOMAIN_NAME=http://192.168.178.50:8089
      - SYMFONY__ENV__SERVER_NAME="Your wallabag instance"
      - SYMFONY__ENV__FOSUSER_CONFIRMATION=false
      - SYMFONY__ENV__TWOFACTOR_AUTH=false
    ports:
      - "8089:80"
    volumes:
      - ./wallabag/images:/var/www/wallabag/web/assets/images

  db:
    image: mariadb
    environment:
      - MYSQL_ROOT_PASSWORD=wallaroot
    volumes:
      - ./mariadb:/var/lib/mysql

```
Flere nyttige Docker-aftryk til hjemmebrug findes i [Dockerverse]({{< ref "dockerverse" >}} "Dockerverse").
## Trin 1: Forbered wallabag-mappen
Jeg opretter en ny mappe med navnet "wallabag" i Docker-mappen.
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
|TZ| Europe/Berlin	|Tidszone|
|MYSQL_ROOT_PASSWORD	 | wallaroot |Hovedadgangskode for databasen.|
{{</table>}}
Endelig indtaster jeg disse miljøvariabler:Se:
{{< gallery match="images/6/*.png" >}}
Efter disse indstillinger kan Mariadb-serveren startes! Jeg trykker på "Anvend" overalt.
{{< gallery match="images/7/*.png" >}}

## Trin 3: Installer Wallabag
Jeg klikker på fanen "Registration" i Synology Docker-vinduet og søger efter "wallabag". Jeg vælger Docker-image "wallabag/wallabag" og klikker derefter på tagget "latest".
{{< gallery match="images/8/*.png" >}}
Jeg dobbeltklikker på mit wallabag-billede. Derefter klikker jeg på "Avancerede indstillinger" og aktiverer også "Automatisk genstart" her.
{{< gallery match="images/9/*.png" >}}
Jeg vælger fanen "Volume" og klikker på "Add Folder" (tilføj mappe). Der opretter jeg en ny mappe med denne mount-sti "/var/www/wallabag/web/assets/images".
{{< gallery match="images/10/*.png" >}}
Jeg tildeler faste porte til "wallabag"-containeren. Uden faste porte kan det være, at "wallabag-serveren" kører på en anden port efter en genstart. Den første containerport kan slettes. Den anden havn bør huskes.
{{< gallery match="images/11/*.png" >}}
Desuden skal der stadig oprettes et "link" til "mariadb"-containeren. Jeg klikker på fanen "Links" og vælger databasebeholderen. Aliasnavnet skal huskes for wallabag-installationen.
{{< gallery match="images/12/*.png" >}}
{{<table "table table-striped table-bordered">}}
|Umgebungsvariable	|Værdi|
|--- |---|
|MYSQL_ROOT_PASSWORD	|wallaroot|
|SYMFONY__ENV__DATABASE_DRIVER	|pdo_mysql|
|SYMFONY__ENV__DATABASE_HOST	|db|
|SYMFONY__ENV__DATABASE_PORT	|3306|
|SYMFONY__ENV__DATABASE_NAME	||
|SYMFONY__ENV__DATABASE_USER	||
|SYMFONY__ENV__DATABASE_PASSWORD	|wallapass|
|SYMFONY__ENV__DATABASE_CHARSET |utf8mb4|
|SYMFONY__ENV__DOMAIN_NAME	|"http://synology-ip:container-port" <- Ændre venligst|
|SYMFONY__ENV__SERVER_NAME	|"Wallabag - Server"|
|SYMFONY__ENV__FOSUSER_CONFIRMATION	|falsk|
|SYMFONY__ENV__TWOFACTOR_AUTH	|falsk|
{{</table>}}
Endelig indtaster jeg disse miljøvariabler:Se:
{{< gallery match="images/13/*.png" >}}
Beholderen kan nu startes. Det kan tage noget tid at oprette databasen. Adfærden kan observeres via containeroplysningerne.
{{< gallery match="images/14/*.png" >}}
Jeg kalder wallabag-serveren med Synologys IP-adresse og min containerport.
{{< gallery match="images/15/*.png" >}}
Jeg må dog sige, at jeg personligt foretrækker shiori som et internetarkiv.
