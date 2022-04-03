+++
date = "2021-05-30"
title = "Udemy Downloader på Synology DiskStation"
difficulty = "level-2"
tags = ["udemy", "download", "synology", "diskstation", "udemydl"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/may/20210530-udemydl/index.da.md"
+++
I denne vejledning lærer du, hvordan du downloader "udemy"-kurser til offline brug.
## Trin 1: Forbered Udemy-mappen
Jeg opretter en ny mappe med navnet "udemy" i Docker-mappen.
{{< gallery match="images/1/*.png" >}}

## Trin 2: Installer Ubuntu-image
Jeg klikker på fanen "Registration" i Synology Docker-vinduet og søger efter "ubunutu". Jeg vælger Docker-image "ubunutu" og klikker derefter på tagget "latest".
{{< gallery match="images/2/*.png" >}}
Jeg dobbeltklikker på mit Ubuntu-image. Derefter klikker jeg på "Avancerede indstillinger" og aktiverer også "Automatisk genstart" her.
{{< gallery match="images/3/*.png" >}}
Jeg vælger fanen "Volume" og klikker på "Add folder" (tilføj mappe). Der opretter jeg en ny mappe med denne monteringssti "/download".
{{< gallery match="images/4/*.png" >}}
Nu kan containeren startes
{{< gallery match="images/5/*.png" >}}

## Trin 4: Installer Udemy Downloader
Jeg klikker på "Container" i Synology Docker-vinduet og dobbeltklikker på min "Udemy-container". Derefter klikker jeg på fanen "Terminal" og indtaster følgende kommandoer.
{{< gallery match="images/6/*.png" >}}

##  Kommandoer:

{{< terminal >}}
apt-get update
apt-get install python3 python3-pip wget unzip
cd /download
wget https://github.com/r0oth3x49/udemy-dl/archive/refs/heads/master.zip
unzip master.zip
cd udemy-dl-master
pip3 pip install -r requirements.txt

{{</ terminal >}}
Skærmbilleder:
{{< gallery match="images/7/*.png" >}}

## Trin 4: Sæt Udemy-downloader i gang
Nu har jeg brug for et "adgangstoken". Jeg besøger Udemy med min Firefox-browser og åbner Firebug. Jeg klikker på fanen "Web storage" og kopierer "Access token".
{{< gallery match="images/8/*.png" >}}
Jeg opretter en ny fil i min container:
{{< terminal >}}
echo "access_token=859wjuhV7PMLsZu15GOWias9A0iFnRjkL9pJXOv2" > /download/cookie.txt

{{</ terminal >}}
Derefter kan jeg downloade de kurser, jeg allerede har købt:
{{< terminal >}}
cd /download
python3 udemy-dl-master/udemy-dl.py -k /download/cookie.txt https://www.udemy.com/course/ansible-grundlagen/learn/

{{</ terminal >}}
Se:
{{< gallery match="images/9/*.png" >}}

