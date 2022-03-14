+++
date = "2020-02-27"
title = "Store ting med containere: Kører Youtube-downloader på Synology Diskstation"
difficulty = "level-1"
tags = ["Docker", "docker-compose", "download", "linux", "Synology", "video", "youtube"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2020/february/20200227-docker-youtube-dl/index.da.md"
+++
Mange af mine venner ved, at jeg driver en privat læringsvideo portal på mit Homelab - Network. Jeg har gemt videokurser fra tidligere medlemskaber af læringsportaler og gode Youtube-tutorials til offline brug på min NAS.
{{< gallery match="images/1/*.png" >}}
I løbet af tiden har jeg samlet 8845 videokurser med 282616 individuelle videoer. Den samlede løbetid svarer til ca. 2 år. I denne tutorial viser jeg, hvordan du kan sikkerhedskopiere gode Youtube-tutorials med en Docker-downloadtjeneste til offlineformål.
## Mulighed for fagfolk
Som erfaren Synology-bruger kan du naturligvis logge ind med SSH og installere hele opsætningen via Docker Compose-filen.
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

## Trin 1
Først opretter jeg en mappe til downloads. Jeg går til "System Control" -> "Shared Folder" og opretter en ny mappe kaldet "Downloads".
{{< gallery match="images/2/*.png" >}}

## Trin 2: Søg efter Docker-aftryk
Jeg klikker på fanen "Registration" i Synology Docker-vinduet og søger efter "youtube-dl-nas". Jeg vælger Docker-image "modenaf360/youtube-dl-nas" og klikker derefter på tagget "latest".
{{< gallery match="images/3/*.png" >}}
Når billedet er downloadet, er det tilgængeligt som et billede. Docker skelner mellem 2 tilstande, container "dynamisk tilstand" og image/image (fast tilstand). Før vi kan oprette en container fra billedet, skal der foretages et par indstillinger.
## Trin 3: Sæt billedet i drift:
Jeg dobbeltklikker på mit youtube-dl-nas-billede.
{{< gallery match="images/4/*.png" >}}
Derefter klikker jeg på "Avancerede indstillinger" og aktiverer "Automatisk genstart". Jeg vælger fanen "Volume" og klikker på "Add folder" (tilføj mappe). Der opretter jeg en ny database-mappe med denne mount-sti "/downfolder".
{{< gallery match="images/5/*.png" >}}
Jeg tildeler faste porte til beholderen "Youtube Downloader". Uden faste porte kan det være, at "Youtube Downloader" kører på en anden port efter en genstart.
{{< gallery match="images/6/*.png" >}}
Endelig indtaster jeg to miljøvariabler. Variablen "MY_ID" er mit brugernavn, og "MY_PW" er min adgangskode.
{{< gallery match="images/7/*.png" >}}
Efter disse indstillinger kan Downloader startes! Herefter kan du ringe til downloaderen via Ip-adressen på Synology-disktionen og den tildelte port, f.eks. http://192.168.21.23:8070 .
{{< gallery match="images/8/*.png" >}}
Til autentificering skal du bruge brugernavnet og adgangskoden fra MY_ID og MY_PW.
## Trin 4: Kom så i gang
Nu kan du indtaste Youtube-video-urls og playlist-urls i "URL"-feltet, og alle videoer ender automatisk i download-mappen på Synology diskstationen.
{{< gallery match="images/9/*.png" >}}
Hent mappe:
{{< gallery match="images/10/*.png" >}}