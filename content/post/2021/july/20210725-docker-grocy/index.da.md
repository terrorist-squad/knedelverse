+++
date = "2021-07-25"
title = "Store ting med beholdere: køleskabsstyring med Grocy"
difficulty = "level-1"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "kühlschrank", "erp", "mhd", "Speispläne", "cms", "Cafe", "Bistro"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/july/20210725-docker-grocy/index.da.md"
+++
Med Grocy kan du administrere en hel husholdning, en restaurant, en café, en bistro eller et fødevaremarked. Du kan administrere køleskabe, menuer, opgaver, indkøbslister og fødevarers holdbarhed.
{{< gallery match="images/1/*.png" >}}
I dag viser jeg, hvordan man installerer en Grocy-tjeneste på Synology diskstationen.
## Mulighed for fagfolk
Som erfaren Synology-bruger kan du naturligvis logge ind med SSH og installere hele opsætningen via Docker Compose-filen.
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
Flere nyttige Docker-aftryk til hjemmebrug findes i [Dockerverse]({{< ref "dockerverse" >}} "Dockerverse").
## Trin 1: Forbered Grocy-mappen
Jeg opretter en ny mappe med navnet "grocy" i Docker-mappen.
{{< gallery match="images/2/*.png" >}}

## Trin 2: Installer Grocy
Jeg klikker på fanen "Registration" i Synology Docker-vinduet og søger efter "Grocy". Jeg vælger Docker-image "linuxserver/grocy:latest" og klikker derefter på tagget "latest".
{{< gallery match="images/3/*.png" >}}
Jeg dobbeltklikker på mit Grocy-billede.
{{< gallery match="images/4/*.png" >}}
Derefter klikker jeg på "Avancerede indstillinger" og aktiverer også "Automatisk genstart" her. Jeg vælger fanen "Volume" og klikker på "Add Folder" (tilføj mappe). Der opretter jeg en ny mappe med denne monteringssti "/config".
{{< gallery match="images/5/*.png" >}}
Jeg tildeler faste porte til "Grocy"-containeren. Uden faste porte kan det være, at "Grocy-serveren" kører på en anden port efter en genstart.
{{< gallery match="images/6/*.png" >}}
{{<table "table table-striped table-bordered">}}
|Variabelt navn|Værdi|Hvad er det?|
|--- | --- |---|
|TZ | Europe/Berlin |Tidszone|
|PUID | 1024 |Bruger-ID fra Synology Admin-bruger|
|PGID |	100 |Gruppe-ID fra Synology Admin-bruger|
{{</table>}}
Endelig indtaster jeg disse miljøvariabler:Se:
{{< gallery match="images/7/*.png" >}}
Beholderen kan nu startes. Jeg kalder Grocy-serveren op med Synologys IP-adresse og min containerport og logger ind med brugernavnet "admin" og adgangskoden "admin".
{{< gallery match="images/8/*.png" >}}

