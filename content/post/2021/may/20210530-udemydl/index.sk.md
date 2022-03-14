+++
date = "2021-05-30"
title = "Program Udemy Downloader v zariadení Synology DiskStation"
difficulty = "level-2"
tags = ["udemy", "download", "synology", "diskstation", "udemydl"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/may/20210530-udemydl/index.sk.md"
+++
V tomto návode sa dozviete, ako si stiahnuť kurzy "udemy" na použitie offline.
## Krok 1: Pripravte si priečinok Udemy
V adresári Docker vytvorím nový adresár s názvom "udemy".
{{< gallery match="images/1/*.png" >}}

## Krok 2: Inštalácia obrazu Ubuntu
Kliknem na kartu "Registrácia" v okne Synology Docker a vyhľadám "ubunutu". Vyberiem obraz Docker "ubunutu" a potom kliknem na značku "latest".
{{< gallery match="images/2/*.png" >}}
Dvakrát kliknem na svoj obraz Ubuntu. Potom kliknem na "Rozšírené nastavenia" a aktivujem tu aj "Automatický reštart".
{{< gallery match="images/3/*.png" >}}
Vyberiem kartu "Zväzok" a kliknem na "Pridať priečinok". Tam vytvorím nový priečinok s touto prípojnou cestou "/download".
{{< gallery match="images/4/*.png" >}}
Teraz je možné kontajner spustiť
{{< gallery match="images/5/*.png" >}}

## Krok 4: Inštalácia programu Udemy Downloader
V okne Synology Docker kliknem na položku "Container" a dvakrát kliknem na svoj kontajner Udemy. Potom kliknem na kartu Terminál a zadám nasledujúce príkazy.
{{< gallery match="images/6/*.png" >}}

##  Príkazy:

{{< terminal >}}
apt-get update
apt-get install python3 python3-pip wget unzip
cd /download
wget https://github.com/r0oth3x49/udemy-dl/archive/refs/heads/master.zip
unzip master.zip
cd udemy-dl-master
pip3 pip install -r requirements.txt

{{</ terminal >}}
Snímky obrazovky:
{{< gallery match="images/7/*.png" >}}

## Krok 4: Uvedenie programu Udemy downloader do prevádzky
Teraz potrebujem "prístupový token". Navštívim stránku Udemy pomocou prehliadača Firefox a otvorím program Firebug. Kliknem na kartu "Webové úložisko" a skopírujem "Prístupový token".
{{< gallery match="images/8/*.png" >}}
V kontajneri vytvorím nový súbor:
{{< terminal >}}
echo "access_token=859wjuhV7PMLsZu15GOWias9A0iFnRjkL9pJXOv2" > /download/cookie.txt

{{</ terminal >}}
Potom si môžem stiahnuť kurzy, ktoré som si už kúpil:
{{< terminal >}}
cd /download
python3 udemy-dl-master/udemy-dl.py -k /download/cookie.txt https://www.udemy.com/course/ansible-grundlagen/learn/

{{</ terminal >}}
Pozri:
{{< gallery match="images/9/*.png" >}}
