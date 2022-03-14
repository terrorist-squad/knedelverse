+++
date = "2020-02-21"
title = "Nagyszerű dolgok konténerekkel: Calibre futtatása Docker Compose-szal (Synology pro beállítás)"
difficulty = "level-3"
tags = ["calibre", "calibre-web", "Docker", "docker-compose", "Synology", "linux"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2020/february/20200221-docker-Calibre-pro/index.hu.md"
+++
Ezen a blogon már van egy egyszerűbb bemutató: [Synology-Nas: Telepítse a Calibre Web-et e-könyvtárként]({{< ref "post/2020/february/20200213-synology-calibreweb" >}} "Synology-Nas: Telepítse a Calibre Web-et e-könyvtárként"). Ez a bemutató minden Synology DS szakembernek szól.
## 1. lépés: A Synology előkészítése
Először is aktiválni kell az SSH bejelentkezést a DiskStationön. Ehhez menjen a "Vezérlőpult" > "Terminál" > "Terminál" menüpontba.
{{< gallery match="images/1/*.png" >}}
Ezután bejelentkezhet az "SSH"-n keresztül, a megadott porton és a rendszergazdai jelszóval (Windows felhasználók a Putty vagy a WinSCP segítségével).
{{< gallery match="images/2/*.png" >}}
Terminal, winSCP vagy Putty segítségével jelentkezem be, és ezt a konzolt későbbre nyitva hagyom.
## 2. lépés: Hozzon létre egy könyvmappát
Létrehozok egy új mappát a Calibre könyvtárnak. Ehhez felhívom a "Rendszer vezérlés" -> "Megosztott mappa" menüpontot, és létrehozok egy új mappát "Könyvek" néven. Ha még nincs "Docker" mappa, akkor ezt is létre kell hozni.
{{< gallery match="images/3/*.png" >}}

## 3. lépés: Készítse elő a könyvmappát
Most a következő fájlt kell letölteni és kicsomagolni: https://drive.google.com/file/d/1zfeU7Jh3FO_jFlWSuZcZQfQOGD0NvXBm/view. A tartalmat ("metadata.db") az új könyvkönyvtárba kell helyezni, lásd:
{{< gallery match="images/4/*.png" >}}

## 4. lépés: Docker mappa előkészítése
Létrehozok egy új könyvtárat "calibre" néven a Docker könyvtárban:
{{< gallery match="images/5/*.png" >}}
Ezután átváltok az új könyvtárba, és létrehozok egy új fájlt "calibre.yml" néven a következő tartalommal:
```
version: '2'
services:
  calibre-web:
    image: linuxserver/calibre-web
    container_name: calibre-web-server
    environment:
      - PUID=1026
      - PGID=100
      - TZ=Europe/Berlin
    volumes:
      - /volume1/Buecher:/books
      - /volume1/docker/calibre:/briefkaste
    ports:
      - 8055:8083
    restart: unless-stopped

```
Ebben az új fájlban több helyen is módosítani kell a következőket:* PUID/PGID: A PUID/PGID mezőbe a DS felhasználó felhasználó és csoport azonosítóját kell beírni. Itt az "1. lépés" konzolját és az "id -u" parancsot használom a felhasználói azonosító megtekintéséhez. Az "id -g" paranccsal megkapom a csoport azonosítóját.* portok: A portnál a "8055:" elülső részt kell beállítani.könyvtárakA fájlban lévő összes könyvtárat ki kell javítani. A helyes címek a DS tulajdonságok ablakában láthatók. (Pillanatkép következik)
{{< gallery match="images/6/*.png" >}}

## 5. lépés: Tesztindítás
Ebben a lépésben is jól tudom használni a konzolt. Átváltok a Calibre könyvtárba, és ott elindítom a Calibre kiszolgálót a Docker Compose-on keresztül.
{{< terminal >}}
cd /volume1/docker/calibre
sudo docker-compose -f calibre.yml up -d

{{</ terminal >}}

{{< gallery match="images/7/*.png" >}}

## 6. lépés: Beállítás
Ezután a Calibre-kiszolgálót a lemezállomás IP-címével és a 4. lépésben megadott porttal hívhatom. A beállításban a "/books" csatolási pontot használom. Ezután a szerver már használható.
{{< gallery match="images/8/*.png" >}}

## 7. lépés: A beállítás véglegesítése
A konzolra ebben a lépésben is szükség van. Az "exec" parancsot használom a konténer-belső alkalmazásadatbázis mentésére.
{{< terminal >}}
sudo docker exec -it calibre-web-server cp /app/calibre-web/app.db /briefkaste/app.db

{{</ terminal >}}
Ezután látok egy új "app.db" fájlt a Calibre könyvtárban:
{{< gallery match="images/9/*.png" >}}
Ezután leállítom a Calibre kiszolgálót:
{{< terminal >}}
sudo docker-compose -f calibre.yml down

{{</ terminal >}}
Most megváltoztatom a levelesláda elérési útvonalát, és az alkalmazásadatbázist tartósítom rajta.
```
version: '2'
services:
  calibre-web:
    image: linuxserver/calibre-web
    container_name: calibre-web-server
    environment:
      - PUID=1026
      - PGID=100
      - TZ=Europe/Berlin
    volumes:
      - /volume1/Buecher:/books
      - /volume1/docker/calibre/app.db:/app/calibre-web/app.db
    ports:
      - 8055:8083
    restart: unless-stopped

```
Ezt követően a kiszolgáló újraindítható:
{{< terminal >}}
sudo docker-compose -f calibre.yml up -d

{{</ terminal >}}