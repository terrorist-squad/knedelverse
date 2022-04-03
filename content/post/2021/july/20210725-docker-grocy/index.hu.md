+++
date = "2021-07-25"
title = "Nagyszerű dolgok konténerekkel: hűtőszekrény-kezelés a Grocyval"
difficulty = "level-1"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "kühlschrank", "erp", "mhd", "Speispläne", "cms", "Cafe", "Bistro"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/july/20210725-docker-grocy/index.hu.md"
+++
A Grocy segítségével egy egész háztartást, éttermet, kávézót, bisztrót vagy élelmiszerpiacot kezelhet. Kezelheti a hűtőszekrényeket, menüket, feladatokat, bevásárlólistákat és az élelmiszerek szavatossági idejét.
{{< gallery match="images/1/*.png" >}}
Ma megmutatom, hogyan kell telepíteni egy Grocy szolgáltatást a Synology lemezállomásra.
## Lehetőség szakemberek számára
Tapasztalt Synology felhasználóként természetesen bejelentkezhet SSH-n keresztül, és telepítheti a teljes telepítést Docker Compose fájlon keresztül.
```
version: "2.1"
services:
  grocy:
    image: ghcr.io/linuxserver/grocy
    container_name: grocy
    environment:
      - PUID=1024
      - PGID=100
      - TZ=Europe/Berlin
    volumes:
      - ./data:/config
    ports:
      - 9283:80
    restart: unless-stopped

```
További hasznos Docker-képek otthoni használatra az [Dockerverse]({{< ref "dockerverse" >}} "Dockerverse").
## 1. lépés: Grocy mappa előkészítése
Létrehozok egy új könyvtárat "grocy" néven a Docker könyvtárban.
{{< gallery match="images/2/*.png" >}}

## 2. lépés: Grocy telepítése
A Synology Docker ablakban a "Regisztráció" fülre kattintok, és rákeresek a "Grocy"-ra. Kiválasztom a "linuxserver/grocy:latest" Docker-képet, majd a "latest" címkére kattintok.
{{< gallery match="images/3/*.png" >}}
Duplán kattintok a Grocy-képemre.
{{< gallery match="images/4/*.png" >}}
Ezután a "Speciális beállítások" menüpontra kattintok, és itt is aktiválom az "Automatikus újraindítás" opciót. Kiválasztom a "Kötet" lapot, és a "Mappa hozzáadása" gombra kattintok. Ott létrehozok egy új mappát ezzel a "/config" mount útvonallal.
{{< gallery match="images/5/*.png" >}}
A "Grocy" konténerhez fix portokat rendelek. Fix portok nélkül előfordulhat, hogy a "Grocy szerver" egy másik porton fut az újraindítás után.
{{< gallery match="images/6/*.png" >}}
{{<table "table table-striped table-bordered">}}
|Változó neve|Érték|Mi ez?|
|--- | --- |---|
|TZ | Europe/Berlin |Időzóna|
|PUID | 1024 |Felhasználói azonosító a Synology Admin felhasználóból|
|PGID |	100 |Csoport azonosítója a Synology Admin felhasználóból|
{{</table>}}
Végül megadom ezeket a környezeti változókat:Lásd:
{{< gallery match="images/7/*.png" >}}
A konténer most már elindítható. Felhívom a Grocy szervert a Synology IP-címével és a konténerportommal, és bejelentkezem az "admin" felhasználónévvel és az "admin" jelszóval.
{{< gallery match="images/8/*.png" >}}

