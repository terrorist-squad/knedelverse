+++
date = "2020-02-28"
title = "Store ting med containere: Kørsel af Papermerge DMS på en Synology NAS"
difficulty = "level-3"
tags = ["archiv", "automatisch", "dms", "Docker", "Document-Managment-System", "google", "ocr", "papermerge", "Synology", "tesseract", "texterkennung"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2020/february/20200228-docker-papermerge/index.da.md"
+++
Papermerge er et ungt dokumenthåndteringssystem (DMS), der automatisk kan tildele og behandle dokumenter. I denne vejledning viser jeg, hvordan jeg installerede Papermerge på min Synology diskstation, og hvordan DMS fungerer.
## Mulighed for fagfolk
Som erfaren Synology-bruger kan du naturligvis logge ind med SSH og installere hele opsætningen via Docker Compose-filen.
```
version: "2.1"
services:
  papermerge:
    image: ghcr.io/linuxserver/papermerge
    container_name: papermerge
    environment:
      - PUID=1024
      - PGID=100
      - TZ=Europe/Berlin
    volumes:
      - ./config>:/config
      - ./appdata/data>:/data
    ports:
      - 8090:8000
    restart: unless-stopped

```

## Trin 1: Opret en mappe
Først opretter jeg en mappe til papirfusionen. Jeg går til "System Control" -> "Shared Folder" og opretter en ny mappe med navnet "Document Archive".
{{< gallery match="images/1/*.png" >}}
Trin 2: Søg efter Docker-imageJeg klikker på fanen "Registration" i Synology Docker-vinduet og søger efter "Papermerge". Jeg vælger Docker-image "linuxserver/papermerge" og klikker derefter på tagget "latest".
{{< gallery match="images/2/*.png" >}}
Når billedet er downloadet, er det tilgængeligt som et billede. Docker skelner mellem 2 tilstande, container "dynamisk tilstand" og image/image (fast tilstand). Før vi kan oprette en container fra billedet, skal der foretages et par indstillinger.
## Trin 3: Sæt billedet i drift:
Jeg dobbeltklikker på mit papirflettebillede.
{{< gallery match="images/3/*.png" >}}
Derefter klikker jeg på "Avancerede indstillinger" og aktiverer "Automatisk genstart". Jeg vælger fanen "Volume" og klikker på "Add folder" (tilføj mappe). Der opretter jeg en ny databasemappe med denne monteringssti "/data".
{{< gallery match="images/4/*.png" >}}
Jeg gemmer også en anden mappe her, som jeg inkluderer med monteringsstien "/config". Det er egentlig ligegyldigt, hvor denne mappe befinder sig. Det er dog vigtigt, at den tilhører Synology-administratorbrugeren.
{{< gallery match="images/5/*.png" >}}
Jeg tildeler faste porte til "Papermerge"-containeren. Uden faste porte kan det være, at "Papermerge-serveren" kører på en anden port efter en genstart.
{{< gallery match="images/6/*.png" >}}
Endelig indtaster jeg tre miljøvariabler. Variablen "PUID" er bruger-ID og "PGID" er gruppe-ID for min administratorbruger. Du kan finde PGID/PUID'et via SSH med kommandoen "cat /etc/passwd | grep admin".
{{< gallery match="images/7/*.png" >}}
Efter disse indstillinger kan Papermerge-serveren startes! Herefter kan Papermerge kaldes via Ip-adressen på Synology-disktionen og den tildelte port, f.eks. http://192.168.21.23:8095.
{{< gallery match="images/8/*.png" >}}
Standardlogin er admin med adgangskode admin.
## Hvordan fungerer Papermerge?
Papermerge analyserer teksten i dokumenter og billeder. Papermerge bruger et OCR/bibliotek til "optisk tegngenkendelse" kaldet tesseract, der er udgivet af Goolge.
{{< gallery match="images/9/*.png" >}}
Jeg oprettede en mappe med navnet "Alt med Lorem" for at teste den automatiske dokumenttildeling. Derefter klikkede jeg et nyt genkendelsesmønster sammen i menupunktet "Automatiserer".
{{< gallery match="images/10/*.png" >}}
Alle nye dokumenter, der indeholder ordet "Lorem", placeres i mappen "Alt med Lorem" og tagges med "has-lorem". Det er vigtigt at bruge et komma i tag'erne, ellers vil tag'et ikke blive sat. Hvis du uploader et tilsvarende dokument, vil det blive mærket og sorteret.
{{< gallery match="images/11/*.png" >}}
