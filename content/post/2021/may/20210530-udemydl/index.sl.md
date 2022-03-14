+++
date = "2021-05-30"
title = "Prenosnik Udemy na strežniku Synology DiskStation"
difficulty = "level-2"
tags = ["udemy", "download", "synology", "diskstation", "udemydl"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/may/20210530-udemydl/index.sl.md"
+++
V tem priročniku se boste naučili, kako prenesti tečaje "udemy" za uporabo brez povezave.
## Korak 1: Pripravite mapo Udemy
V imeniku Docker ustvarim nov imenik z imenom "udemy".
{{< gallery match="images/1/*.png" >}}

## Korak 2: Namestitev slike Ubuntu
V oknu Synology Docker kliknem na zavihek "Registracija" in poiščem "ubunutu". Izberem sliko Docker "ubunutu" in nato kliknem na oznako "latest".
{{< gallery match="images/2/*.png" >}}
Dvakrat kliknem na sliko Ubuntuja. Nato kliknem na "Napredne nastavitve" in aktiviram možnost "Samodejni ponovni zagon".
{{< gallery match="images/3/*.png" >}}
Izberem zavihek "Zvezek" in kliknem na "Dodaj mapo". Tam ustvarim novo mapo s to potjo "/download".
{{< gallery match="images/4/*.png" >}}
Zdaj lahko zaženete posodo
{{< gallery match="images/5/*.png" >}}

## Korak 4: Namestite Udemy Downloader
V oknu Synology Docker kliknem na "Container" in dvakrat kliknem na svoj "Udemy container". Nato kliknem na zavihek Terminal in vnesem naslednje ukaze.
{{< gallery match="images/6/*.png" >}}

##  Ukazi:

{{< terminal >}}
apt-get update
apt-get install python3 python3-pip wget unzip
cd /download
wget https://github.com/r0oth3x49/udemy-dl/archive/refs/heads/master.zip
unzip master.zip
cd udemy-dl-master
pip3 pip install -r requirements.txt

{{</ terminal >}}
Posnetki zaslona:
{{< gallery match="images/7/*.png" >}}

## Korak 4: Zagon prenosnika Udemy
Zdaj potrebujem "žeton za dostop". V brskalniku Firefox obiščem Udemy in odprem program Firebug. Kliknem na zavihek "Spletna shramba" in kopiram "Dostopovni žeton".
{{< gallery match="images/8/*.png" >}}
V vsebniku ustvarim novo datoteko:
{{< terminal >}}
echo "access_token=859wjuhV7PMLsZu15GOWias9A0iFnRjkL9pJXOv2" > /download/cookie.txt

{{</ terminal >}}
Nato lahko prenesem tečaje, ki sem jih že kupil:
{{< terminal >}}
cd /download
python3 udemy-dl-master/udemy-dl.py -k /download/cookie.txt https://www.udemy.com/course/ansible-grundlagen/learn/

{{</ terminal >}}
Oglejte si:
{{< gallery match="images/9/*.png" >}}
