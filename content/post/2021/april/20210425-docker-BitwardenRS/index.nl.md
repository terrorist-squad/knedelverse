+++
date = "2021-04-25T09:28:11+01:00"
title = "BitwardenRS op het Synology DiskStation"
difficulty = "level-2"
tags = ["bitwardenrs", "Docker", "docker-compose", "password-manager", "passwort", "Synology"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/april/20210425-docker-BitwardenRS/index.nl.md"
+++
Bitwarden is een gratis open-source wachtwoordbeheerdienst die vertrouwelijke informatie, zoals websitegegevens, opslaat in een versleutelde kluis. Vandaag laat ik zien hoe je een BitwardenRS installeert op een Synology DiskStation.
## Stap 1: BitwardenRS map klaarmaken
Ik maak een nieuwe map aan genaamd "bitwarden" in de Docker map.
{{< gallery match="images/1/*.png" >}}

## Stap 2: Installeer BitwardenRS
Ik klik op het tabblad "Registratie" in het Synology Docker-venster en zoek naar "bitwarden". Ik selecteer de Docker image "bitwardenrs/server" en klik dan op de tag "latest".
{{< gallery match="images/2/*.png" >}}
Ik dubbelklik op mijn bitwardenrs foto. Dan klik ik op "Geavanceerde instellingen" en activeer ook hier de "Automatische herstart".
{{< gallery match="images/3/*.png" >}}
Ik selecteer de tab "Volume" en klik op "Map toevoegen". Daar maak ik een nieuwe map aan met dit mount pad "/data".
{{< gallery match="images/4/*.png" >}}
Ik wijs vaste poorten toe voor de "bitwardenrs" container. Zonder vaste poorten kan het zijn dat de "bitwardenrs server" na een herstart op een andere poort draait. De eerste containerpoort kan worden verwijderd. De andere poort moet je niet vergeten.
{{< gallery match="images/5/*.png" >}}
De container kan nu worden gestart. Ik bel de bitwardenrs server met het Synology IP adres en mijn container poort 8084.
{{< gallery match="images/6/*.png" >}}

## Stap 3: HTTPS instellen
Ik klik op "Control Panel" > "Reverse Proxy" en "Create".
{{< gallery match="images/7/*.png" >}}
Daarna kan ik de bitwardenrs server oproepen met het Synology IP adres en mijn proxy poort 8085, versleuteld.
{{< gallery match="images/8/*.png" >}}