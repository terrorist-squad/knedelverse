+++
date = "2021-04-25T09:28:11+01:00"
title = "BitwardenRS på Synology DiskStation"
difficulty = "level-2"
tags = ["bitwardenrs", "Docker", "docker-compose", "password-manager", "passwort", "Synology"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210425-docker-BitwardenRS/index.da.md"
+++
Bitwarden er en gratis open source-tjeneste til administration af adgangskoder, der gemmer fortrolige oplysninger som f.eks. webstedsoplysninger i en krypteret boks. I dag viser jeg, hvordan man installerer en BitwardenRS på Synology DiskStation.
## Trin 1: Forbered BitwardenRS-mappen
Jeg opretter en ny mappe kaldet "bitwarden" i Docker-mappen.
{{< gallery match="images/1/*.png" >}}

## Trin 2: Installer BitwardenRS
Jeg klikker på fanen "Registration" i Synology Docker-vinduet og søger efter "bitwarden". Jeg vælger Docker-image "bitwardenrs/server" og klikker derefter på tagget "latest".
{{< gallery match="images/2/*.png" >}}
Jeg dobbeltklikker på mit bitwardenrs-billede. Derefter klikker jeg på "Avancerede indstillinger" og aktiverer også "Automatisk genstart" her.
{{< gallery match="images/3/*.png" >}}
Jeg vælger fanen "Volume" og klikker på "Add Folder" (tilføj mappe). Der opretter jeg en ny mappe med denne monteringssti "/data".
{{< gallery match="images/4/*.png" >}}
Jeg tildeler faste porte til "bitwardenrs"-containeren. Uden faste porte kan det være, at "bitwardenrs-serveren" kører på en anden port efter en genstart. Den første containerport kan slettes. Den anden havn bør huskes.
{{< gallery match="images/5/*.png" >}}
Beholderen kan nu startes. Jeg kalder bitwardenrs-serveren med Synologys IP-adresse og min containerport 8084.
{{< gallery match="images/6/*.png" >}}

## Trin 3: Opsætning af HTTPS
Jeg klikker på "Kontrolpanel" > "Omvendt proxy" og "Opret".
{{< gallery match="images/7/*.png" >}}
Derefter kan jeg ringe til bitwardenrs-serveren med Synologys IP-adresse og min proxy-port 8085, krypteret.
{{< gallery match="images/8/*.png" >}}