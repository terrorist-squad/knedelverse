+++
date = "2021-04-18"
title = "Nagyszerű dolgok konténerekkel: A Docspell DMS futtatása a Synology DiskStation rendszeren"
difficulty = "level-2"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "Document-Managment-System"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210418-docker-Docspell/index.hu.md"
+++
A Docspell egy dokumentumkezelő rendszer a Synology DiskStationhöz. A Docspell segítségével a dokumentumok sokkal gyorsabban indexelhetők, kereshetők és megtalálhatók. Ma megmutatom, hogyan kell telepíteni a Docspell szolgáltatást a Synology lemezállomáson.
## 1. lépés: A Synology előkészítése
Először is aktiválni kell az SSH bejelentkezést a DiskStationön. Ehhez menjen a "Vezérlőpult" > "Terminál" > "Terminál" menüpontba.
{{< gallery match="images/1/*.png" >}}
Ezután bejelentkezhet az "SSH"-n keresztül, a megadott porton és a rendszergazdai jelszóval (Windows felhasználók a Putty vagy a WinSCP segítségével).
{{< gallery match="images/2/*.png" >}}
Terminal, winSCP vagy Putty segítségével jelentkezem be, és ezt a konzolt későbbre nyitva hagyom.
## 2. lépés: Docspel mappa létrehozása
Létrehozok egy új könyvtárat "docspell" néven a Docker könyvtárban.
{{< gallery match="images/3/*.png" >}}
Most a következő fájlt kell letölteni és kicsomagolni a könyvtárba: https://github.com/eikek/docspell/archive/refs/heads/master.zip . Ehhez a konzolt használom:
{{< terminal >}}
cd /volume1/docker/docspell/
mkdir docs
mkdir postgres_data
wget https://github.com/eikek/docspell/archive/refs/heads/master.zip 
/bin/7z x master.zip

{{</ terminal >}}
Ezután szerkesztem a "docker/docker-compose.yml" fájlt, és a "consumedir" és "db" mezőkbe beírom a Synology címeket:
{{< gallery match="images/4/*.png" >}}
Ezután elindíthatom a Compose fájlt:
{{< terminal >}}
cd docspell-master/docker/
docker-compose up -d

{{</ terminal >}}
Néhány perc múlva a Docspell szerveremet a lemezállomás IP címével és a hozzárendelt 7878-as porttal tudom hívni.
{{< gallery match="images/5/*.png" >}}
A dokumentumok keresése jól működik. Sajnálatosnak tartom, hogy a képekben lévő szövegek nincsenek indexelve. A Papermerge segítségével szövegeket is kereshet a képeken.
