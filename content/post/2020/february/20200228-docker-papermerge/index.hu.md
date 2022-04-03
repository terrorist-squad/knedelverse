+++
date = "2020-02-28"
title = "Nagyszerű dolgok konténerekkel: Papermerge DMS futtatása egy Synology NAS-on"
difficulty = "level-3"
tags = ["archiv", "automatisch", "dms", "Docker", "Document-Managment-System", "google", "ocr", "papermerge", "Synology", "tesseract", "texterkennung"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2020/february/20200228-docker-papermerge/index.hu.md"
+++
A Papermerge egy fiatal dokumentumkezelő rendszer (DMS), amely képes a dokumentumok automatikus hozzárendelésére és feldolgozására. Ebben a bemutatóban megmutatom, hogyan telepítettem a Papermerge-t a Synology lemezállomásomra, és hogyan működik a DMS.
## Lehetőség szakemberek számára
Tapasztalt Synology felhasználóként természetesen bejelentkezhet SSH-n keresztül, és telepítheti a teljes telepítést Docker Compose fájlon keresztül.
```
version: "2.1"
services:
  papermerge:
    image: ghcr.io/linuxserver/papermerge
    container_name: papermerge
    environment:
      - PUID=1024
      - PGID=100
      - TZ=Europe/Berlin
    volumes:
      - ./config>:/config
      - ./appdata/data>:/data
    ports:
      - 8090:8000
    restart: unless-stopped

```

## 1. lépés: Mappa létrehozása
Először létrehozok egy mappát a papír egyesítéshez. Elmegyek a "System Control" -> "Shared Folder" menüpontba, és létrehozok egy új mappát "Document Archive" néven.
{{< gallery match="images/1/*.png" >}}
2. lépés: Docker-kép kereséseA Synology Docker ablakban a "Regisztráció" fülre kattintok, és rákeresek a "Papermerge"-re. Kiválasztom a "linuxserver/papermerge" Docker-képet, majd a "latest" címkére kattintok.
{{< gallery match="images/2/*.png" >}}
A kép letöltése után a kép képként elérhető. A Docker 2 állapotot különböztet meg, a konténer "dinamikus állapotát" és a képet/képet (rögzített állapot). Mielőtt létrehozhatnánk egy konténert a képből, néhány beállítást el kell végeznünk.
## 3. lépés: Helyezze üzembe a képet:
Duplán kattintok a papír egyesítési képemre.
{{< gallery match="images/3/*.png" >}}
Ezután a "Speciális beállítások" gombra kattintok, és aktiválom az "Automatikus újraindítás" opciót. Kiválasztom a "Kötet" lapot, és a "Mappa hozzáadása" gombra kattintok. Ott létrehozok egy új adatbázis mappát ezzel a "/data" csatlakozási útvonallal.
{{< gallery match="images/4/*.png" >}}
Egy második mappát is tárolok itt, amelyet a "/config" csatolási útvonalhoz csatolok. Nem igazán számít, hogy hol van ez a mappa. Fontos azonban, hogy a Synology admin felhasználójához tartozzon.
{{< gallery match="images/5/*.png" >}}
A "Papermerge" konténerhez fix portokat rendelek. Fix portok nélkül előfordulhat, hogy a "Papermerge szerver" egy másik porton fut az újraindítás után.
{{< gallery match="images/6/*.png" >}}
Végül három környezeti változót adok meg. A "PUID" változó a felhasználó azonosítója, a "PGID" pedig az admin felhasználó csoport azonosítója. A PGID/PUID azonosítót SSH-n keresztül a "cat /etc/passwd | grep admin" paranccsal tudhatja meg.
{{< gallery match="images/7/*.png" >}}
Ezek után a beállítások után a Papermerge szerver elindítható! Ezután a Papermerge a Synology disctation Ip-címén és a hozzárendelt porton keresztül hívható, például http://192.168.21.23:8095.
{{< gallery match="images/8/*.png" >}}
Az alapértelmezett bejelentkezés az admin, jelszóval admin.
## Hogyan működik a Papermerge?
A Papermerge elemzi a dokumentumok és képek szövegét. A Papermerge a Goolge által kiadott tesseract nevű OCR/"optikai karakterfelismerő" könyvtárat használja.
{{< gallery match="images/9/*.png" >}}
Létrehoztam egy "Minden Loremmel" nevű mappát, hogy teszteljem az automatikus dokumentum hozzárendelést. Ezután az "Automatizálás" menüpontban egy új felismerési mintát kattintottam össze.
{{< gallery match="images/10/*.png" >}}
Minden új dokumentum, amely a "Lorem" szót tartalmazza, a "Minden Loremmel" mappába kerül, és a "has-lorem" címkével van ellátva. Fontos, hogy a címkék között vesszőt használjon, különben a címke nem lesz beállítva. Ha feltölt egy dokumentumot, akkor az fel lesz címkézve és rendezve.
{{< gallery match="images/11/*.png" >}}
