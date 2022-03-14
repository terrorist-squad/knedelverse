+++
date = "2021-04-17"
title = "Geweldige dingen met containers: Draai je eigen xWiki op het Synology diskstation"
difficulty = "level-1"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "xwiki", "wiki",]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/april/20210417-docker-xWiki/index.nl.md"
+++
XWiki is een gratis wiki-softwareplatform, geschreven in Java en ontworpen met uitbreidbaarheid in het achterhoofd. Vandaag laat ik zien hoe een xWiki-service op het Synology DiskStation kan worden geïnstalleerd.
## Optie voor professionals
Als ervaren Synology gebruiker kunt u natuurlijk inloggen met SSH en de hele setup installeren via Docker Compose bestand.
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
Meer nuttige Docker images voor thuisgebruik zijn te vinden in de [Dockerverse]({{< ref "dockerverse" >}} "Dockerverse").
## Stap 1: Maak de wiki map klaar
Ik maak een nieuwe map aan genaamd "wiki" in de Docker map.
{{< gallery match="images/1/*.png" >}}

## Stap 2: Database installeren
Daarna moet een database worden gecreëerd. Ik klik op het tabblad "Registratie" in het Synology Docker venster en zoek naar "postgres". Ik selecteer de Docker image "postgres" en klik dan op de tag "latest".
{{< gallery match="images/2/*.png" >}}
Na het downloaden van de afbeelding, is de afbeelding beschikbaar als een afbeelding. Docker maakt onderscheid tussen 2 staten, container "dynamische staat" en image (vaste staat). Voordat we een container maken van de image, moeten een paar instellingen worden gemaakt. Ik dubbelklik op mijn postgres image.
{{< gallery match="images/3/*.png" >}}
Dan klik ik op "Geavanceerde instellingen" en activeer de "Automatische herstart". Ik selecteer de tab "Volume" en klik op "Map toevoegen". Daar maak ik een nieuwe database map aan met dit mount pad "/var/lib/postgresql/data".
{{< gallery match="images/4/*.png" >}}
Onder "Poortinstellingen" worden alle poorten gewist. Dit betekent dat ik de "5432" poort selecteer en deze verwijder met de "-" knop.
{{< gallery match="images/5/*.png" >}}
{{<table "table table-striped table-bordered">}}
|Naam variabele|Waarde|Wat is het?|
|--- | --- |---|
|TZ	| Europe/Berlin	|Tijdzone|
|POSTGRES_DB	| xwiki |Dit is de naam van de database.|
|POSTGRES_USER	| xwiki |Gebruikersnaam van de wiki databank.|
|POSTGRES_PASSWORD	| xwiki |Wachtwoord van de wiki database gebruiker.|
{{</table>}}
Tenslotte voer ik deze vier omgevingsvariabelen in:Zie:
{{< gallery match="images/6/*.png" >}}
Na deze instellingen kan de Mariadb server worden gestart! Ik druk overal op "Toepassen".
## Stap 3: xWiki installeren
Ik klik op het tabblad "Registratie" in het Synology Docker-venster en zoek naar "xwiki". Ik selecteer de Docker image "xwiki" en klik dan op de tag "10-postgres-tomcat".
{{< gallery match="images/7/*.png" >}}
Ik dubbelklik op mijn xwiki plaatje. Dan klik ik op "Geavanceerde instellingen" en activeer ook hier de "Automatische herstart".
{{< gallery match="images/8/*.png" >}}
Ik wijs vaste poorten toe voor de "xwiki" container. Zonder vaste poorten zou het kunnen dat de "xwiki server" na een herstart op een andere poort draait.
{{< gallery match="images/9/*.png" >}}
Bovendien moet een "link" naar de "postgres" container worden gemaakt. Ik klik op de "Links" tab en selecteer de database container. De aliasnaam moet onthouden worden voor de wiki installatie.
{{< gallery match="images/10/*.png" >}}
{{<table "table table-striped table-bordered">}}
|Naam variabele|Waarde|Wat is het?|
|--- | --- |---|
|TZ |	Europe/Berlin	|Tijdzone|
|DB_HOST	| db |Alias namen / container koppeling|
|DB_DATABASE	| xwiki	|Gegevens van stap 2|
|DB_USER	| xwiki	|Gegevens van stap 2|
|DB_PASSWORD	| xwiki |Gegevens van stap 2|
{{</table>}}
Tenslotte voer ik deze omgevingsvariabelen in:Zie:
{{< gallery match="images/11/*.png" >}}
De container kan nu worden gestart. Ik roep de xWiki server op met het Synology IP adres en mijn container poort.
{{< gallery match="images/12/*.png" >}}