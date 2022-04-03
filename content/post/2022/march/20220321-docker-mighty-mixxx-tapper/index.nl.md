+++
date = "2022-03-21"
title = "Geweldige dingen met containers: MP3's opnemen van de radio"
difficulty = "level-1"
tags = ["diskstation", "Docker", "docker-compose", "docker-for-desktop", "radio", "mp3", "ripp", "streamripper", "radiorecorder"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2022/march/20220321-docker-mighty-mixxx-tapper/index.nl.md"
+++
Streamripper is een hulpprogramma voor de opdrachtregel waarmee MP3- of OGG/Vorbis-streams kunnen worden opgenomen en rechtstreeks op de harde schijf kunnen worden opgeslagen. De liedjes krijgen automatisch de naam van de artiest en worden afzonderlijk opgeslagen, het formaat is het formaat dat oorspronkelijk is verzonden (dus in feite worden bestanden met de extensie .mp3 of .ogg aangemaakt). Ik vond een geweldige radiorecorder interface en bouwde er een Docker image van, zie: https://github.com/terrorist-squad/mightyMixxxTapper/
{{< gallery match="images/1/*.png" >}}

## Optie voor professionals
Als ervaren Synology gebruiker kunt u natuurlijk inloggen met SSH en de hele setup installeren via Docker Compose bestand.
```
version: "2.0"
services:
  mealie:
    container_name: mighty-mixxx-tapper
    image: chrisknedel/mighty-mixxx-tapper:latest
    restart: always
    ports:
      - 9000:80
    environment:
      TZ: Europa/Berlin
    volumes:
      - ./ripps/:/tmp/ripps/

```

## Stap 1: Zoek naar Docker image
Ik klik op het tabblad "Registratie" in het Synology Docker-venster en zoek naar "mighty-mixxx-tapper". Ik selecteer de Docker image "chrisknedel/mighty-mixxx-tapper" en klik dan op de tag "latest".
{{< gallery match="images/2/*.png" >}}
Na het downloaden van de afbeelding, is de afbeelding beschikbaar als een afbeelding. Docker maakt onderscheid tussen 2 toestanden, container "dynamische toestand" en image/image (vaste toestand). Voordat we een container van het image kunnen maken, moeten een paar instellingen worden gemaakt.
## Stap 2: Zet het beeld in werking:
Ik dubbelklik op mijn "mighty-mixxx-tapper" plaatje.
{{< gallery match="images/3/*.png" >}}
Dan klik ik op "Geavanceerde instellingen" en activeer de "Automatische herstart". Ik selecteer de tab "Volume" en klik op "Map toevoegen". Daar maak ik een nieuwe map aan met dit mount pad "/tmp/ripps/".
{{< gallery match="images/4/*.png" >}}
Ik wijs vaste poorten toe voor de "mighty-mixxx-tapper" container. Zonder vaste poorten kan het zijn dat de "mighty-mixxx-tapper-server" na een herstart op een andere poort draait.
{{< gallery match="images/5/*.png" >}}
Na deze instellingen kan mighty-mixxx-tapper-server worden gestart! Daarna kunt u mighty-mixxx-tapper oproepen via het Ip-adres van het Synology disctation en de toegewezen poort, bijvoorbeeld http://192.168.21.23:8097.
{{< gallery match="images/6/*.png" >}}
