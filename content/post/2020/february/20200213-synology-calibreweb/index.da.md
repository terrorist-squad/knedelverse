+++
date = "2020-02-13"
title = "Synology-Nas: Installer Calibre Web som e-bogbibliotek"
difficulty = "level-1"
tags = ["calbre-web", "calibre", "Docker", "ds918", "ebook", "epub", "nas", "pdf", "Synology"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2020/february/20200213-synology-calibreweb/index.da.md"
+++
Hvordan installerer jeg Calibre-Web som en Docker-container på min Synology NAS? Bemærk: Denne installationsmetode er forældet og er ikke kompatibel med den aktuelle Calibre-software. Se venligst denne nye vejledning:[Store ting med containere: Kørsel af Calibre med Docker Compose]({{< ref "post/2020/february/20200221-docker-Calibre-pro" >}} "Store ting med containere: Kørsel af Calibre med Docker Compose"). Denne vejledning er for alle Synology DS-fagfolk.
## Trin 1: Opret en mappe
Først opretter jeg en mappe til Calibre-biblioteket.  Jeg kalder "Systemkontrol" -> "Delte mapper" og opretter en ny mappe "Bøger".
{{< gallery match="images/1/*.png" >}}

##  Trin 2: Opret Calibre-bibliotek
Nu kopierer jeg et eksisterende bibliotek eller "[dette tomme prøvebibliotek](https://drive.google.com/file/d/1zfeU7Jh3FO_jFlWSuZcZQfQOGD0NvXBm/view)" over i den nye mappe. Jeg har selv kopieret det eksisterende bibliotek i skrivebordsprogrammet.
{{< gallery match="images/2/*.png" >}}

## Trin 3: Søg efter Docker-aftryk
Jeg klikker på fanen "Registration" i Synology Docker-vinduet og søger efter "Calibre". Jeg vælger Docker-aftrykket "janeczku/calibre-web" og klikker derefter på tagget "latest".
{{< gallery match="images/3/*.png" >}}
Når billedet er downloadet, er det tilgængeligt som et billede. Docker skelner mellem 2 tilstande, container "dynamisk tilstand" og image/image (fast tilstand). Før vi kan oprette en container fra billedet, skal der foretages et par indstillinger.
## Trin 4: Sæt billedet i drift:
Jeg dobbeltklikker på mit Calibre-billede.
{{< gallery match="images/4/*.png" >}}
Derefter klikker jeg på "Avancerede indstillinger" og aktiverer "Automatisk genstart". Jeg vælger fanen "Volume" og klikker på "Add Folder" (tilføj mappe). Der opretter jeg en ny database-mappe med denne monteringssti "/calibre".
{{< gallery match="images/5/*.png" >}}
Jeg tildeler faste porte til Calibre-containeren. Uden faste porte kan det være, at Calibre kører på en anden port efter en genstart.
{{< gallery match="images/6/*.png" >}}
Efter disse indstillinger kan Calibre startes!
{{< gallery match="images/7/*.png" >}}
Jeg kalder nu min Synology IP op med den tildelte Calibre-port og ser følgende billede. Jeg indtaster "/calibre" som "Placering af Calibre-database". De øvrige indstillinger er et spørgsmål om smag.
{{< gallery match="images/8/*.png" >}}
Standardlogin er "admin" med adgangskode "admin123".
{{< gallery match="images/9/*.png" >}}
Færdig! Nu kan jeg selvfølgelig også forbinde desktop-appen via min "bogmappe". Jeg bytter biblioteket i min app og vælger derefter min Nas-mappe.
{{< gallery match="images/10/*.png" >}}
Noget i denne retning:
{{< gallery match="images/11/*.png" >}}
Hvis jeg nu redigerer meta-infos i desktop-appen, bliver de også automatisk opdateret i web-appen.
{{< gallery match="images/12/*.png" >}}