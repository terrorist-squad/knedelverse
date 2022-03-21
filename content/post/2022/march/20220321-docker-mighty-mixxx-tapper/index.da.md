+++
date = "2022-03-21"
title = "Store ting med containere: Optagelse af MP3-filer fra radioen"
difficulty = "level-1"
tags = ["diskstation", "Docker", "docker-compose", "docker-for-desktop", "radio", "mp3", "ripp", "streamripper", "radiorecorder"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2022/march/20220321-docker-mighty-mixxx-tapper/index.da.md"
+++
Streamripper er et værktøj til kommandolinjen, der kan bruges til at optage MP3- eller OGG/Vorbis-streams og gemme dem direkte på harddisken. Sangene navngives automatisk efter kunstneren og gemmes individuelt, og formatet er det format, der oprindeligt blev sendt (så der oprettes faktisk filer med udvidelsen .mp3 eller .ogg). Jeg har fundet en god radiorecorder-grænseflade og bygget et Docker-image ud fra den, se: https://github.com/terrorist-squad/mightyMixxxTapper/
{{< gallery match="images/1/*.png" >}}

## Mulighed for fagfolk
Som erfaren Synology-bruger kan du naturligvis logge ind med SSH og installere hele opsætningen via Docker Compose-filen.
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

## Trin 1: Søg efter Docker-aftryk
Jeg klikker på fanen "Registration" i Synology Docker-vinduet og søger efter "mighty-mixxx-tapper". Jeg vælger Docker-image "chrisknedel/mighty-mixxx-tapper" og klikker derefter på tagget "latest".
{{< gallery match="images/2/*.png" >}}
Når billedet er downloadet, er det tilgængeligt som et billede. Docker skelner mellem 2 tilstande, container "dynamisk tilstand" og image/image (fast tilstand). Før vi kan oprette en container fra billedet, skal der foretages nogle få indstillinger.
## Trin 2: Sæt billedet i drift:
Jeg dobbeltklikker på mit "mighty-mixxx-tapper"-billede.
{{< gallery match="images/3/*.png" >}}
Derefter klikker jeg på "Avancerede indstillinger" og aktiverer "Automatisk genstart". Jeg vælger fanen "Volume" og klikker på "Add Folder" (tilføj mappe). Der opretter jeg en ny mappe med denne monteringssti "/tmp/ripps/".
{{< gallery match="images/4/*.png" >}}
Jeg tildeler faste porte til containeren "mighty-mixxx-tapper". Uden faste porte kan det være, at "mighty-mixxx-tapper-serveren" kører på en anden port efter en genstart.
{{< gallery match="images/5/*.png" >}}
Efter disse indstillinger kan mighty-mixxx-tapper-serveren startes! Derefter kan du ringe til mighty-mixxx-tapper via Ip-adressen på Synology-disktionen og den tildelte port, f.eks. http://192.168.21.23:8097.
{{< gallery match="images/6/*.png" >}}