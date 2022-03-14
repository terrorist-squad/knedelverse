+++
date = "2020-02-27"
title = "Geweldige dingen met containers: Youtube downloader draaien op Synology Diskstation"
difficulty = "level-1"
tags = ["Docker", "docker-compose", "download", "linux", "Synology", "video", "youtube"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2020/february/20200227-docker-youtube-dl/index.nl.md"
+++
Veel van mijn vrienden weten dat ik een privé-leer-videoportaal run op mijn Homelab - Netwerk. Ik heb videocursussen van eerdere leerportaallidmaatschappen en goede Youtube-lesprogramma's opgeslagen voor offline gebruik op mijn NAS.
{{< gallery match="images/1/*.png" >}}
In de loop der tijd heb ik 8845 videocursussen verzameld met 282616 individuele video's. De totale looptijd bedraagt ongeveer 2 jaar. Helemaal te gek! In deze tutorial laat ik zien hoe je een back-up maakt van goede Youtube tutorials met een Docker download service voor offline doeleinden.
## Optie voor professionals
Als ervaren Synology gebruiker kunt u natuurlijk inloggen met SSH en de hele setup installeren via Docker Compose bestand.
```
version: "2"
services:
  youtube-dl:
    image: modenaf360/youtube-dl-nas
    container_name: youtube-dl
    environment:
      - MY_ID=admin
      - MY_PW=admin
    volumes:
      - ./YouTube:/downfolder
    ports:
      - 8080:8080
    restart: unless-stopped

```

## Stap 1
Eerst maak ik een map voor de downloads. Ik ga naar "System Control" -> "Shared Folder" en maak een nieuwe map aan genaamd "Downloads".
{{< gallery match="images/2/*.png" >}}

## Stap 2: Zoek naar Docker image
Ik klik op het tabblad "Registratie" in het Synology Docker-venster en zoek naar "youtube-dl-nas". Ik selecteer de Docker image "modenaf360/youtube-dl-nas" en klik dan op de tag "latest".
{{< gallery match="images/3/*.png" >}}
Na het downloaden van de afbeelding, is de afbeelding beschikbaar als een afbeelding. Docker maakt onderscheid tussen 2 toestanden, container "dynamische toestand" en image/image (vaste toestand). Voordat we een container kunnen maken van de image, moeten een paar instellingen worden gemaakt.
## Stap 3: Zet het beeld in werking:
Ik dubbelklik op mijn youtube-dl-nas beeld.
{{< gallery match="images/4/*.png" >}}
Dan klik ik op "Geavanceerde instellingen" en activeer de "Automatische herstart". Ik selecteer de tab "Volume" en klik op "Map toevoegen". Daar maak ik een nieuwe database map aan met dit mount pad "/downfolder".
{{< gallery match="images/5/*.png" >}}
Ik wijs vaste poorten toe voor de "Youtube Downloader" container. Zonder vaste poorten, kan het zijn dat de "Youtube Downloader" op een andere poort draait na een herstart.
{{< gallery match="images/6/*.png" >}}
Tenslotte voer ik twee omgevingsvariabelen in. De variabele "MY_ID" is mijn gebruikersnaam en "MY_PW" is mijn wachtwoord.
{{< gallery match="images/7/*.png" >}}
Na deze instellingen kan Downloader gestart worden! Daarna kunt u de downloader oproepen via het Ip-adres van het Synology disctation en de toegewezen poort, bijvoorbeeld http://192.168.21.23:8070 .
{{< gallery match="images/8/*.png" >}}
Neem voor de authenticatie de gebruikersnaam en het wachtwoord van MY_ID en MY_PW.
## Stap 4: Laten we gaan
Nu kunnen Youtube video url's en playlist url's worden ingevoerd in het "URL" veld en alle video's komen automatisch terecht in de download map van het Synology disk station.
{{< gallery match="images/9/*.png" >}}
Download map:
{{< gallery match="images/10/*.png" >}}