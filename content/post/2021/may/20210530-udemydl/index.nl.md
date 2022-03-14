+++
date = "2021-05-30"
title = "Udemy Downloader op het Synology DiskStation"
difficulty = "level-2"
tags = ["udemy", "download", "synology", "diskstation", "udemydl"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/may/20210530-udemydl/index.nl.md"
+++
In deze handleiding leer je hoe je "udemy" cursussen kunt downloaden voor offline gebruik.
## Stap 1: Maak de Udemy-map klaar
Ik maak een nieuwe map genaamd "udemy" in de Docker map.
{{< gallery match="images/1/*.png" >}}

## Stap 2: Installeer Ubuntu image
Ik klik op het tabblad "Registratie" in het Synology Docker-venster en zoek naar "ubunutu". Ik selecteer de Docker image "ubunutu" en klik dan op de tag "latest".
{{< gallery match="images/2/*.png" >}}
Ik dubbelklik op mijn Ubuntu image. Dan klik ik op "Geavanceerde instellingen" en activeer ook hier de "Automatische herstart".
{{< gallery match="images/3/*.png" >}}
Ik selecteer het tabblad "Volume" en klik op "Map toevoegen". Daar maak ik een nieuwe map aan met dit mount pad "/download".
{{< gallery match="images/4/*.png" >}}
Nu kan de container gestart worden
{{< gallery match="images/5/*.png" >}}

## Stap 4: Installeer Udemy Downloader
Ik klik op "Container" in het Synology Docker venster en dubbelklik op mijn "Udemy container". Dan klik ik op de "Terminal" tab en voer de volgende commando's in.
{{< gallery match="images/6/*.png" >}}

##  Commando's:

{{< terminal >}}
apt-get update
apt-get install python3 python3-pip wget unzip
cd /download
wget https://github.com/r0oth3x49/udemy-dl/archive/refs/heads/master.zip
unzip master.zip
cd udemy-dl-master
pip3 pip install -r requirements.txt

{{</ terminal >}}
Screenshots:
{{< gallery match="images/7/*.png" >}}

## Stap 4: De Udemy-downloader in werking stellen
Nu heb ik een "toegangs token" nodig. Ik bezoek Udemy met mijn Firefox browser en open Firebug. Ik klik op de "Web storage" tab en kopieer de "Access token".
{{< gallery match="images/8/*.png" >}}
Ik maak een nieuw bestand in mijn container:
{{< terminal >}}
echo "access_token=859wjuhV7PMLsZu15GOWias9A0iFnRjkL9pJXOv2" > /download/cookie.txt

{{</ terminal >}}
Daarna kan ik de cursussen downloaden die ik al gekocht heb:
{{< terminal >}}
cd /download
python3 udemy-dl-master/udemy-dl.py -k /download/cookie.txt https://www.udemy.com/course/ansible-grundlagen/learn/

{{</ terminal >}}
Zie:
{{< gallery match="images/9/*.png" >}}
