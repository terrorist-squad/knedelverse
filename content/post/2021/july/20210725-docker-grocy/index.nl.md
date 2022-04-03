+++
date = "2021-07-25"
title = "Grootse dingen met containers: koelkastbeheer met Grocy"
difficulty = "level-1"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "kühlschrank", "erp", "mhd", "Speispläne", "cms", "Cafe", "Bistro"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/july/20210725-docker-grocy/index.nl.md"
+++
Met Grocy kunt u een heel huishouden, restaurant, café, bistro of voedselmarkt beheren. U kunt koelkasten, menu's, taken, boodschappenlijstjes en de houdbaarheid van voedsel beheren.
{{< gallery match="images/1/*.png" >}}
Vandaag laat ik zien hoe je een Grocy service installeert op het Synology disk station.
## Optie voor professionals
Als ervaren Synology gebruiker kunt u natuurlijk inloggen met SSH en de hele setup installeren via Docker Compose bestand.
```
version: "2.1"
services:
  grocy:
    image: ghcr.io/linuxserver/grocy
    container_name: grocy
    environment:
      - PUID=1024
      - PGID=100
      - TZ=Europe/Berlin
    volumes:
      - ./data:/config
    ports:
      - 9283:80
    restart: unless-stopped

```
Meer nuttige Docker images voor thuisgebruik zijn te vinden in de [Dockerverse]({{< ref "dockerverse" >}} "Dockerverse").
## Stap 1: Grocy map klaarmaken
Ik maak een nieuwe map aan genaamd "grocy" in de Docker map.
{{< gallery match="images/2/*.png" >}}

## Stap 2: Grocy installeren
Ik klik op het tabblad "Registratie" in het Synology Docker venster en zoek naar "Grocy". Ik selecteer de Docker image "linuxserver/grocy:latest" en klik dan op de tag "latest".
{{< gallery match="images/3/*.png" >}}
Ik dubbelklik op mijn Grocy foto.
{{< gallery match="images/4/*.png" >}}
Dan klik ik op "Geavanceerde instellingen" en activeer ook hier de "Automatische herstart". Ik selecteer de tab "Volume" en klik op "Map toevoegen". Daar maak ik een nieuwe map aan met dit mount pad "/config".
{{< gallery match="images/5/*.png" >}}
Ik wijs vaste poorten toe voor de "Grocy" container. Zonder vaste poorten kan het zijn dat de "Grocy server" na een herstart op een andere poort draait.
{{< gallery match="images/6/*.png" >}}
{{<table "table table-striped table-bordered">}}
|Naam variabele|Waarde|Wat is het?|
|--- | --- |---|
|TZ | Europe/Berlin |Tijdzone|
|PUID | 1024 |Gebruikers-ID van Synology Admin Gebruiker|
|PGID |	100 |Groep-ID van Synology Admin-gebruiker|
{{</table>}}
Tenslotte voer ik deze omgevingsvariabelen in:Zie:
{{< gallery match="images/7/*.png" >}}
De container kan nu worden gestart. Ik roep de Grocy server op met het Synology IP adres en mijn container poort en log in met de gebruikersnaam "admin" en het wachtwoord "admin".
{{< gallery match="images/8/*.png" >}}

