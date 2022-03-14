+++
date = "2021-04-16"
title = "Geweldige dingen met containers: Wiki.js installeren op het Synology Diskstation"
difficulty = "level-1"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "wikijs", "wiki"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210416-docker-Wikijs/index.nl.md"
+++
Wiki.js is een krachtige open source wiki software die van documentatie een plezier maakt met zijn eenvoudige interface. Vandaag laat ik zien hoe een Wiki.js service op het Synology DiskStation kan worden geïnstalleerd.
## Optie voor professionals
Als ervaren Synology gebruiker kunt u natuurlijk inloggen met SSH en de hele setup installeren via Docker Compose bestand.
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
U kunt meer nuttige Docker images voor thuisgebruik vinden in de Dockerverse.
## Stap 1: Maak de wiki map klaar
Ik maak een nieuwe map aan genaamd "wiki" in de Docker map.
{{< gallery match="images/1/*.png" >}}

## Stap 2: Database installeren
Daarna moet een database worden gecreëerd. Ik klik op het tabblad "Registratie" in het Synology Docker venster en zoek naar "mysql". Ik selecteer de Docker image "mysql" en klik dan op de tag "latest".
{{< gallery match="images/2/*.png" >}}
Na het downloaden van de afbeelding, is de afbeelding beschikbaar als een afbeelding. Docker maakt onderscheid tussen 2 staten, container "dynamische staat" en image (vaste staat). Voordat we een container maken van de image, moeten een paar instellingen worden gemaakt. Ik dubbelklik op mijn mysql image.
{{< gallery match="images/3/*.png" >}}
Dan klik ik op "Geavanceerde instellingen" en activeer de "Automatische herstart". Ik selecteer de tab "Volume" en klik op "Map toevoegen". Daar maak ik een nieuwe database map aan met dit mount pad "/var/lib/mysql".
{{< gallery match="images/4/*.png" >}}
Onder "Poortinstellingen" worden alle poorten gewist. Dit betekent dat ik de "3306" poort selecteer en deze verwijder met de "-" knop.
{{< gallery match="images/5/*.png" >}}
{{<table "table table-striped table-bordered">}}
|Naam variabele|Waarde|Wat is het?|
|--- | --- |---|
|TZ	| Europe/Berlin |Tijdzone|
|MYSQL_ROOT_PASSWORD	| my_wiki_pass |Hoofdwachtwoord van de database.|
|MYSQL_DATABASE |	my_wiki |Dit is de naam van de database.|
|MYSQL_USER	| wikiuser |Gebruikersnaam van de wiki databank.|
|MYSQL_PASSWORD |	my_wiki_pass	|Wachtwoord van de wiki database gebruiker.|
{{</table>}}
Tenslotte voer ik deze vier omgevingsvariabelen in:Zie:
{{< gallery match="images/6/*.png" >}}
Na deze instellingen kan de Mariadb server worden gestart! Ik druk overal op "Toepassen".
## Stap 3: Installeer Wiki.js
Ik klik op het tabblad "Registratie" in het Synology Docker-venster en zoek naar "wiki". Ik selecteer de Docker image "requarks/wiki" en klik dan op de tag "latest".
{{< gallery match="images/7/*.png" >}}
Ik dubbelklik op mijn WikiJS beeld. Dan klik ik op "Geavanceerde instellingen" en activeer ook hier de "Automatische herstart".
{{< gallery match="images/8/*.png" >}}
Ik wijs vaste poorten toe voor de "WikiJS" container. Zonder vaste poorten kan het zijn dat de "bookstack server" na een herstart op een andere poort draait.
{{< gallery match="images/9/*.png" >}}
Bovendien moet er nog een "link" naar de "mysql" container worden gemaakt. Ik klik op de "Links" tab en selecteer de database container. De aliasnaam moet onthouden worden voor de wiki installatie.
{{< gallery match="images/10/*.png" >}}
{{<table "table table-striped table-bordered">}}
|Naam variabele|Waarde|Wat is het?|
|--- | --- |---|
|TZ	| Europe/Berlin	|Tijdzone|
|DB_HOST	| wiki-db	|Alias namen / container koppeling|
|DB_TYPE	| mysql	||
|DB_PORT	| 3306	 ||
|DB_PASSWORD	| my_wiki	|Gegevens van stap 2|
|DB_USER	| wikiuser |Gegevens van stap 2|
|DB_PASS	| my_wiki_pass	|Gegevens van stap 2|
{{</table>}}
Tenslotte voer ik deze omgevingsvariabelen in:Zie:
{{< gallery match="images/11/*.png" >}}
De container kan nu worden gestart. Ik roep de Wiki.js server aan met het Synology IP adres en mijn container poort/3000.
{{< gallery match="images/12/*.png" >}}