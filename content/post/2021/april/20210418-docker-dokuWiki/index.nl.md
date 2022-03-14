+++
date = "2021-04-18"
title = "Geweldige dingen met containers: Je eigen dokuWiki installeren op het Synology-schijfstation"
difficulty = "level-2"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "dokuwiki", "wiki"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/april/20210418-docker-dokuWiki/index.nl.md"
+++
DokuWiki is een standaard-compliant, eenvoudig te gebruiken en tegelijkertijd uiterst veelzijdige open source wiki software. Vandaag laat ik zien hoe je een DokuWiki service installeert op het Synology disk station.
## Optie voor professionals
Als ervaren Synology gebruiker kunt u natuurlijk inloggen met SSH en de hele setup installeren via Docker Compose bestand.
```
version: '3'
services:
  dokuwiki:
    image:  bitnami/dokuwiki:latest
    restart: always
    ports:
      - 8080:8080
      - 8443:8443
    environment:
      TZ: 'Europe/Berlin'
      DOKUWIKI_USERNAME: 'admin'
      DOKUWIKI_FULL_NAME: 'wiki'
      DOKUWIKI_PASSWORD: 'password'
    volumes:
      - ./data:/bitnami/dokuwiki

```
Meer nuttige Docker images voor thuisgebruik zijn te vinden in de [Dockerverse]({{< ref "dockerverse" >}} "Dockerverse").
## Stap 1: Maak de wiki map klaar
Ik maak een nieuwe map aan genaamd "wiki" in de Docker map.
{{< gallery match="images/1/*.png" >}}

## Stap 2: DokuWiki installeren
Daarna moet een database worden gecreëerd. Ik klik op het tabblad "Registratie" in het Synology Docker-venster en zoek naar "dokuwiki". Ik selecteer de Docker image "bitnami/dokuwiki" en klik dan op de tag "latest".
{{< gallery match="images/2/*.png" >}}
Na het downloaden van de afbeelding, is de afbeelding beschikbaar als een afbeelding. Docker maakt onderscheid tussen 2 staten, container "dynamische staat" en image (vaste staat). Voordat we een container maken van de image, moeten een paar instellingen worden gemaakt. Ik dubbelklik op mijn dokuwiki image.
{{< gallery match="images/3/*.png" >}}
Ik wijs vaste poorten toe voor de "dokuwiki" container. Zonder vaste poorten zou het kunnen dat de "dokuwiki server" na een herstart op een andere poort draait.
{{< gallery match="images/4/*.png" >}}
{{<table "table table-striped table-bordered">}}
|Naam variabele|Waarde|Wat is het?|
|--- | --- |---|
|TZ	| Europe/Berlin	|Tijdzone|
|DOKUWIKI_USERNAME	| admin|Admin gebruikersnaam|
|DOKUWIKI_FULL_NAME |	wiki	|WIki naam|
|DOKUWIKI_PASSWORD	| password	|Admin wachtwoord|
{{</table>}}
Tenslotte voer ik deze omgevingsvariabelen in:Zie:
{{< gallery match="images/5/*.png" >}}
De container kan nu worden gestart. Ik roep de dokuWIki server op met het Synology IP adres en mijn container poort.
{{< gallery match="images/6/*.png" >}}
