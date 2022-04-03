+++
date = "2021-04-25T09:28:11+01:00"
title = "BitwardenRS a Synology DiskStation rendszeren"
difficulty = "level-2"
tags = ["bitwardenrs", "Docker", "docker-compose", "password-manager", "passwort", "Synology"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210425-docker-BitwardenRS/index.hu.md"
+++
A Bitwarden egy ingyenes, nyílt forráskódú jelszókezelő szolgáltatás, amely titkosított páncélteremben tárolja a bizalmas információkat, például a weboldal hitelesítő adatait. Ma megmutatom, hogyan kell telepíteni egy BitwardenRS-t a Synology DiskStationre.
## 1. lépés: BitwardenRS mappa előkészítése
Létrehozok egy új könyvtárat "bitwarden" néven a Docker könyvtárban.
{{< gallery match="images/1/*.png" >}}

## 2. lépés: BitwardenRS telepítése
A Synology Docker ablakban a "Regisztráció" fülre kattintok, és rákeresek a "bitwarden"-re. Kiválasztom a "bitwardenrs/server" Docker-képet, majd a "latest" címkére kattintok.
{{< gallery match="images/2/*.png" >}}
Duplán kattintok a bitwardenrs képemre. Ezután a "Speciális beállítások" menüpontra kattintok, és itt is aktiválom az "Automatikus újraindítás" opciót.
{{< gallery match="images/3/*.png" >}}
Kiválasztom a "Kötet" lapot, és a "Mappa hozzáadása" gombra kattintok. Ott létrehozok egy új mappát ezzel a "/data" mount útvonallal.
{{< gallery match="images/4/*.png" >}}
A "bitwardenrs" konténerhez fix portokat rendelek. Fix portok nélkül előfordulhat, hogy a "bitwardenrs szerver" egy másik porton fut az újraindítás után. Az első konténerport törölhető. A másik kikötőt nem szabad elfelejteni.
{{< gallery match="images/5/*.png" >}}
A konténer most már elindítható. A bitwardenrs szervert a Synology IP-címével és a 8084-es konténerporttal hívom.
{{< gallery match="images/6/*.png" >}}

## 3. lépés: HTTPS beállítása
A "Vezérlőpult" > "Fordított proxy" és a "Létrehozás" gombra kattintok.
{{< gallery match="images/7/*.png" >}}
Ezután a Synology IP-címével és a 8085-ös proxy porttal, titkosítva hívhatom a bitwardenrs szervert.
{{< gallery match="images/8/*.png" >}}
