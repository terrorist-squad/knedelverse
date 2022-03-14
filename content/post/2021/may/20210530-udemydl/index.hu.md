+++
date = "2021-05-30"
title = "Udemy Downloader a Synology DiskStation rendszeren"
difficulty = "level-2"
tags = ["udemy", "download", "synology", "diskstation", "udemydl"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/may/20210530-udemydl/index.hu.md"
+++
Ebben a bemutatóban megtanulhatja, hogyan töltse le az "udemy" tanfolyamokat offline használatra.
## 1. lépés: Udemy mappa előkészítése
Létrehozok egy új könyvtárat "udemy" néven a Docker könyvtárban.
{{< gallery match="images/1/*.png" >}}

## 2. lépés: Ubuntu kép telepítése
A Synology Docker ablakban a "Regisztráció" fülre kattintok, és rákeresek az "ubunutu"-ra. Kiválasztom az "ubunutu" Docker-képet, majd a "latest" címkére kattintok.
{{< gallery match="images/2/*.png" >}}
Duplán kattintok az Ubuntu képemre. Ezután a "Speciális beállítások" menüpontra kattintok, és itt is aktiválom az "Automatikus újraindítás" opciót.
{{< gallery match="images/3/*.png" >}}
Kiválasztom a "Kötet" lapot, és a "Mappa hozzáadása" gombra kattintok. Ott létrehozok egy új mappát ezzel a "/download" mount útvonallal.
{{< gallery match="images/4/*.png" >}}
Most már elindítható a konténer
{{< gallery match="images/5/*.png" >}}

## 4. lépés: Telepítse az Udemy Downloader-t
A Synology Docker ablakban a "Container" gombra kattintok, és duplán kattintok az "Udemy konténerre". Ezután a "Terminál" fülre kattintok, és beírom a következő parancsokat.
{{< gallery match="images/6/*.png" >}}

##  Parancsok:

{{< terminal >}}
apt-get update
apt-get install python3 python3-pip wget unzip
cd /download
wget https://github.com/r0oth3x49/udemy-dl/archive/refs/heads/master.zip
unzip master.zip
cd udemy-dl-master
pip3 pip install -r requirements.txt

{{</ terminal >}}
Pillanatképek:
{{< gallery match="images/7/*.png" >}}

## 4. lépés: Az Udemy letöltő üzembe helyezése
Most szükségem van egy "hozzáférési jelszóra". Meglátogatom az Udemy-t a Firefox böngészőmmel, és megnyitom a Firebug-ot. A "Webes tárolás" fülre kattintok, és bemásolom a "Hozzáférési tokent".
{{< gallery match="images/8/*.png" >}}
Létrehozok egy új fájlt a konténeremben:
{{< terminal >}}
echo "access_token=859wjuhV7PMLsZu15GOWias9A0iFnRjkL9pJXOv2" > /download/cookie.txt

{{</ terminal >}}
Ezután letölthetem a már megvásárolt tanfolyamokat:
{{< terminal >}}
cd /download
python3 udemy-dl-master/udemy-dl.py -k /download/cookie.txt https://www.udemy.com/course/ansible-grundlagen/learn/

{{</ terminal >}}
Lásd:
{{< gallery match="images/9/*.png" >}}
