+++
date = "2021-04-16"
title = "Geweldige dingen met containers: Uw eigen Bookstack Wiki op het Synology DiskStation"
difficulty = "level-1"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "bookstack", "wiki"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210416-docker-Bookstack/index.nl.md"
+++
Bookstack is een "open bron"-alternatief voor MediaWiki of Confluence. Vandaag laat ik zien hoe je een Bookstack service installeert op het Synology disk station.
## Optie voor professionals
Als ervaren Synology gebruiker kunt u natuurlijk inloggen met SSH en de hele setup installeren via Docker Compose bestand.
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
Meer nuttige Docker images voor thuisgebruik zijn te vinden in de [Dockerverse]({{< ref "dockerverse" >}} "Dockerverse").
## Stap 1: Maak de boekenmap klaar
Ik maak een nieuwe map aan genaamd "wiki" in de Docker map.
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
|TZ	| Europe/Berlin |Tijdzone|
|MYSQL_ROOT_PASSWORD	|  my_wiki_pass |Hoofdwachtwoord van de database.|
|MYSQL_DATABASE | 	my_wiki	|Dit is de naam van de database.|
|MYSQL_USER	|  wikiuser	|Gebruikersnaam van de wiki databank.|
|MYSQL_PASSWORD	|  my_wiki_pass	|Wachtwoord van de wiki database gebruiker.|
{{</table>}}
Tenslotte voer ik deze omgevingsvariabelen in:Zie:
{{< gallery match="images/6/*.png" >}}
Na deze instellingen kan de Mariadb server worden gestart! Ik druk overal op "Toepassen".
## Stap 3: Installeer Bookstack
Ik klik op het tabblad "Registratie" in het Synology Docker-venster en zoek naar "bookstack". Ik selecteer de Docker image "solidnerd/bookstack" en klik dan op de tag "latest".
{{< gallery match="images/7/*.png" >}}
Ik dubbelklik op mijn Bookstack beeld. Dan klik ik op "Geavanceerde instellingen" en activeer ook hier de "Automatische herstart".
{{< gallery match="images/8/*.png" >}}
Ik wijs vaste poorten toe voor de "bookstack" container. Zonder vaste poorten kan het zijn dat de "bookstack server" na een herstart op een andere poort draait. De eerste containerpoort kan worden verwijderd. De andere poort moet je niet vergeten.
{{< gallery match="images/9/*.png" >}}
Bovendien moet er nog een "link" naar de "mariadb" container worden gemaakt. Ik klik op de "Links" tab en selecteer de database container. De aliasnaam moet onthouden worden voor de wiki installatie.
{{< gallery match="images/10/*.png" >}}
{{<table "table table-striped table-bordered">}}
|Naam variabele|Waarde|Wat is het?|
|--- | --- |---|
|TZ	| Europe/Berlin |Tijdzone|
|DB_HOST	| wiki-db:3306	|Alias namen / container koppeling|
|DB_DATABASE	| my_wiki |Gegevens van stap 2|
|DB_USERNAME	| wikiuser |Gegevens van stap 2|
|DB_PASSWORD	| my_wiki_pass	|Gegevens van stap 2|
{{</table>}}
Tenslotte voer ik deze omgevingsvariabelen in:Zie:
{{< gallery match="images/11/*.png" >}}
De container kan nu worden gestart. Het kan enige tijd duren om de database aan te maken. Het gedrag kan worden waargenomen via de details van de container.
{{< gallery match="images/12/*.png" >}}
Ik roep de Bookstack server op met het Synology IP adres en mijn container poort. De inlognaam is "admin@admin.com" en het wachtwoord is "password".
{{< gallery match="images/13/*.png" >}}
