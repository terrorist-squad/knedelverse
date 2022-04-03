+++
date = "2021-04-16"
title = "Geweldige dingen met containers: Installeer je eigen MediaWiki op het Synology-schijfstation"
difficulty = "level-1"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "mediawiki", "wiki"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210416-docker-MediaWiki/index.nl.md"
+++
MediaWiki is een op PHP gebaseerd wikisysteem dat gratis beschikbaar is als een open-sourceproduct. Vandaag laat ik zien hoe je een MediaWiki service installeert op het Synology disk station.
## Optie voor professionals
Als ervaren Synology gebruiker kunt u natuurlijk inloggen met SSH en de hele setup installeren via Docker Compose bestand.
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
Meer nuttige Docker images voor thuisgebruik zijn te vinden in de [Dockerverse]({{< ref "dockerverse" >}} "Dockerverse").
## Stap 1: MediaWiki-map klaarmaken
Ik maak een nieuwe map aan genaamd "wiki" in de Docker map.
{{< gallery match="images/1/*.png" >}}

## Stap 2: Database installeren
Daarna moet een database worden gecreëerd. Ik klik op het tabblad "Registratie" in het Synology Docker venster en zoek naar "mariadb". Ik selecteer de Docker image "mariadb" en klik dan op de tag "latest".
{{< gallery match="images/2/*.png" >}}
Na het downloaden van de afbeelding, is de afbeelding beschikbaar als een afbeelding. Docker maakt onderscheid tussen 2 toestanden, container "dynamische toestand" en image (vaste toestand). Voordat we een container van de image maken, moeten er een paar instellingen worden gemaakt. Ik dubbelklik op mijn mariadb image.
{{< gallery match="images/3/*.png" >}}
Dan klik ik op "Geavanceerde instellingen" en activeer de "Automatische herstart". Ik selecteer de tab "Volume" en klik op "Map toevoegen". Daar maak ik een nieuwe database map aan met dit mount pad "/var/lib/mysql".
{{< gallery match="images/4/*.png" >}}
Onder "Poortinstellingen" worden alle poorten gewist. Dit betekent dat ik de "3306" poort selecteer en deze verwijder met de "-" knop.
{{< gallery match="images/5/*.png" >}}
{{<table "table table-striped table-bordered">}}
|Naam variabele|Waarde|Wat is het?|
|--- | --- |---|
|TZ	| Europe/Berlin	|Tijdzone|
|MYSQL_ROOT_PASSWORD	| my_wiki_pass	|Hoofdwachtwoord van de database.|
|MYSQL_DATABASE |	my_wiki	|Dit is de naam van de database.|
|MYSQL_USER	| wikiuser |Gebruikersnaam van de wiki databank.|
|MYSQL_PASSWORD	| my_wiki_pass |Wachtwoord van de wiki database gebruiker.|
{{</table>}}
Tenslotte voer ik deze omgevingsvariabelen in:Zie:
{{< gallery match="images/6/*.png" >}}
Na deze instellingen kan de Mariadb server worden gestart! Ik druk overal op "Toepassen".
## Stap 3: Installeer MediaWiki
Ik klik op het tabblad "Registratie" in het Synology Docker-venster en zoek naar "mediawiki". Ik selecteer de Docker image "mediawiki" en klik dan op de tag "latest".
{{< gallery match="images/7/*.png" >}}
Ik dubbelklik op mijn Mediawiki plaatje.
{{< gallery match="images/8/*.png" >}}
Dan klik ik op "Geavanceerde instellingen" en activeer ook hier de "Automatische herstart". Ik selecteer het tabblad "Volume" en klik op "Map toevoegen". Daar maak ik een nieuwe map aan met dit mount pad "/var/www/html/images".
{{< gallery match="images/9/*.png" >}}
Ik wijs vaste poorten toe voor de "MediaWiki" container. Zonder vaste poorten zou het kunnen dat de "MediaWiki server" na een herstart op een andere poort draait.
{{< gallery match="images/10/*.png" >}}
Bovendien moet er nog een "link" naar de "mariadb" container worden gemaakt. Ik klik op de "Links" tab en selecteer de database container. De aliasnaam moet onthouden worden voor de wiki installatie.
{{< gallery match="images/11/*.png" >}}
Tenslotte voer ik een omgevingsvariabele "TZ" in met waarde "Europe/Berlin".
{{< gallery match="images/12/*.png" >}}
De container kan nu worden gestart. Ik roep de Mediawiki server op met het Synology IP adres en mijn container poort. Onder Database server voer ik de alias naam van de database container in. Ik voer ook de databasenaam, gebruikersnaam en wachtwoord in van "Stap 2".
{{< gallery match="images/13/*.png" >}}
