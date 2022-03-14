+++
date = "2021-04-18"
title = "Geweldige dingen met containers: Eigen WallaBag op het Synology-schijfstation"
difficulty = "level-1"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "archiv", "wallabag"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210418-docker-WallaBag/index.nl.md"
+++
Wallabag is een programma voor het archiveren van interessante websites of artikelen. Vandaag laat ik zien hoe je een Wallabag service installeert op het Synology disk station.
## Optie voor professionals
Als ervaren Synology gebruiker kunt u natuurlijk inloggen met SSH en de hele setup installeren via Docker Compose bestand.
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
Meer nuttige Docker images voor thuisgebruik zijn te vinden in de [Dockerverse]({{< ref "dockerverse" >}} "Dockerverse").
## Stap 1: Maak de map klaar
Ik maak een nieuwe map genaamd "wallabag" in de Docker map.
{{< gallery match="images/1/*.png" >}}

## Stap 2: Database installeren
Daarna moet een database worden gecreëerd. Ik klik op het tabblad "Registratie" in het Synology Docker venster en zoek naar "mariadb". Ik selecteer de Docker image "mariadb" en klik dan op de tag "latest".
{{< gallery match="images/2/*.png" >}}
Na het downloaden van de afbeelding, is de afbeelding beschikbaar als een afbeelding. Docker maakt onderscheid tussen 2 staten, container "dynamische staat" en image (vaste staat). Voordat we een container van de image maken, moeten een paar instellingen worden gemaakt. Ik dubbelklik op mijn mariadb image.
{{< gallery match="images/3/*.png" >}}
Dan klik ik op "Geavanceerde instellingen" en activeer de "Automatische herstart". Ik selecteer de tab "Volume" en klik op "Map toevoegen". Daar maak ik een nieuwe database map aan met dit mount pad "/var/lib/mysql".
{{< gallery match="images/4/*.png" >}}
Onder "Poortinstellingen" worden alle poorten gewist. Dit betekent dat ik de "3306" poort selecteer en deze verwijder met de "-" knop.
{{< gallery match="images/5/*.png" >}}
{{<table "table table-striped table-bordered">}}
|Naam variabele|Waarde|Wat is het?|
|--- | --- |---|
|TZ| Europe/Berlin	|Tijdzone|
|MYSQL_ROOT_PASSWORD	 | wallaroot |Hoofdwachtwoord van de database.|
{{</table>}}
Tenslotte voer ik deze omgevingsvariabelen in:Zie:
{{< gallery match="images/6/*.png" >}}
Na deze instellingen kan de Mariadb server worden gestart! Ik druk overal op "Toepassen".
{{< gallery match="images/7/*.png" >}}

## Stap 3: Installeer Wallabag
Ik klik op het tabblad "Registratie" in het Synology Docker-venster en zoek naar "wallabag". Ik selecteer de Docker image "wallabag/wallabag" en klik dan op de tag "latest".
{{< gallery match="images/8/*.png" >}}
Ik dubbelklik op mijn wallabag plaatje. Dan klik ik op "Geavanceerde instellingen" en activeer ook hier de "Automatische herstart".
{{< gallery match="images/9/*.png" >}}
Ik selecteer het tabblad "Volume" en klik op "Map toevoegen". Daar maak ik een nieuwe map aan met dit mount pad "/var/www/wallabag/web/assets/images".
{{< gallery match="images/10/*.png" >}}
Ik wijs vaste poorten toe voor de "wallabag" container. Zonder vaste poorten kan het zijn dat de "wallabag server" na een herstart op een andere poort draait. De eerste containerpoort kan worden verwijderd. De andere poort moet je niet vergeten.
{{< gallery match="images/11/*.png" >}}
Bovendien moet er nog een "link" naar de "mariadb" container worden gemaakt. Ik klik op de "Links" tab en selecteer de database container. De aliasnaam moet onthouden worden voor de wallabag installatie.
{{< gallery match="images/12/*.png" >}}
{{<table "table table-striped table-bordered">}}
|Umgebungsvariable	|Waarde|
|--- |---|
|MYSQL_ROOT_PASSWORD	|wallaroot|
|SYMFONY__ENV__DATABASE_DRIVER	|pdo_mysql|
|SYMFONY__ENV__DATABASE_HOST	|db|
|SYMFONY__ENV__DATABASE_PORT	|3306|
|SYMFONY__ENV__DATABASE_NAME	|wallabag|
|SYMFONY__ENV__DATABASE_USER	|wallabag|
|SYMFONY__ENV__DATABASE_PASSWORD	|wallapass|
|SYMFONY__ENV__DATABASE_CHARSET |utf8mb4|
|SYMFONY__ENV__DOMAIN_NAME	|"http://synology-ip:container-port" <- Verander alsjeblieft|
|SYMFONY__ENV__SERVER_NAME	|"Wallabag - Server"|
|SYMFONY__ENV__FOSUSER_CONFIRMATION	|vals|
|SYMFONY__ENV__TWOFACTOR_AUTH	|vals|
{{</table>}}
Tenslotte voer ik deze omgevingsvariabelen in:Zie:
{{< gallery match="images/13/*.png" >}}
De container kan nu worden gestart. Het kan enige tijd duren om de database aan te maken. Het gedrag kan worden waargenomen via de details van de container.
{{< gallery match="images/14/*.png" >}}
Ik bel de wallabag server met het Synology IP adres en mijn container poort.
{{< gallery match="images/15/*.png" >}}
