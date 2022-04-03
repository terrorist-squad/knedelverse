+++
date = "2021-04-18"
title = "Geweldige dingen met containers: Docspell DMS draaien op het Synology DiskStation"
difficulty = "level-2"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "Document-Managment-System"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210418-docker-Docspell/index.nl.md"
+++
Docspell is een documentbeheersysteem voor het Synology DiskStation. Met Docspell kunnen documenten veel sneller worden geïndexeerd, doorzocht en gevonden. Vandaag laat ik zien hoe je een Docspell service installeert op het Synology disk station.
## Stap 1: Synology voorbereiden
Eerst moet de SSH-aanmelding op het DiskStation worden geactiveerd. Om dit te doen, ga naar het "Configuratiescherm" > "Terminal
{{< gallery match="images/1/*.png" >}}
Vervolgens kunt u inloggen via "SSH", de opgegeven poort en het beheerderswachtwoord (Windows-gebruikers gebruiken Putty of WinSCP).
{{< gallery match="images/2/*.png" >}}
Ik log in via Terminal, winSCP of Putty en laat deze console open voor later.
## Stap 2: Docspel-map aanmaken
Ik maak een nieuwe map genaamd "docspell" in de Docker map.
{{< gallery match="images/3/*.png" >}}
Nu moet het volgende bestand worden gedownload en uitgepakt in de directory: https://github.com/eikek/docspell/archive/refs/heads/master.zip . Ik gebruik de console hiervoor:
{{< terminal >}}
cd /volume1/docker/docspell/
mkdir docs
mkdir postgres_data
wget https://github.com/eikek/docspell/archive/refs/heads/master.zip 
/bin/7z x master.zip

{{</ terminal >}}
Dan bewerk ik het "docker/docker-compose.yml" bestand en voer mijn Synology adressen in bij "consumedir" en "db":
{{< gallery match="images/4/*.png" >}}
Daarna kan ik het Compose-bestand starten:
{{< terminal >}}
cd docspell-master/docker/
docker-compose up -d

{{</ terminal >}}
Na een paar minuten kan ik mijn Docspell server oproepen met het IP van het diskstation en de toegewezen poort/7878.
{{< gallery match="images/5/*.png" >}}
Het zoeken naar documenten werkt goed. Ik vind het jammer dat teksten in afbeeldingen niet worden geïndexeerd. Met Papermerge kunt u ook naar teksten in afbeeldingen zoeken.
