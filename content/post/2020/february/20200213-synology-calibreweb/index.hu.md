+++
date = "2020-02-13"
title = "Synology-Nas: Telepítse a Calibre Web-et e-könyvtárként"
difficulty = "level-1"
tags = ["calbre-web", "calibre", "Docker", "ds918", "ebook", "epub", "nas", "pdf", "Synology"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2020/february/20200213-synology-calibreweb/index.hu.md"
+++
Hogyan telepíthetem a Calibre-Webet Docker konténerként a Synology NAS-ra? Figyelem: Ez a telepítési módszer elavult, és nem kompatibilis a jelenlegi Calibre szoftverrel. Kérjük, nézze meg ezt az új bemutatót:[Nagyszerű dolgok konténerekkel: Calibre futtatása Docker Compose-szal]({{< ref "post/2020/february/20200221-docker-Calibre-pro" >}} "Nagyszerű dolgok konténerekkel: Calibre futtatása Docker Compose-szal"). Ez a bemutató minden Synology DS szakembernek szól.
## 1. lépés: Mappa létrehozása
Először létrehozok egy mappát a Calibre könyvtárnak.  Felhívom a "Rendszer vezérlés" -> "Megosztott mappa" és létrehozok egy új mappát "Könyvek".
{{< gallery match="images/1/*.png" >}}

##  2. lépés: Calibre könyvtár létrehozása
Most egy meglévő könyvtárat vagy "[ez az üres mintakönyvtár](https://drive.google.com/file/d/1zfeU7Jh3FO_jFlWSuZcZQfQOGD0NvXBm/view)" másolok az új könyvtárba. Én magam másoltam az asztali alkalmazás meglévő könyvtárát.
{{< gallery match="images/2/*.png" >}}

## 3. lépés: Docker-kép keresése
A Synology Docker ablakban a "Regisztráció" fülre kattintok, és rákeresek a "Calibre"-re. Kiválasztom a "janeczku/calibre-web" Docker-képet, majd a "latest" címkére kattintok.
{{< gallery match="images/3/*.png" >}}
A kép letöltése után a kép képként elérhető. A Docker 2 állapotot különböztet meg, a konténer "dinamikus állapotát" és a képet/képet (rögzített állapot). Mielőtt létrehozhatnánk egy konténert a képből, néhány beállítást el kell végeznünk.
## 4. lépés: Helyezze üzembe a képet:
Duplán kattintok a Calibre-képemre.
{{< gallery match="images/4/*.png" >}}
Ezután a "Speciális beállítások" gombra kattintok, és aktiválom az "Automatikus újraindítás" opciót. Kiválasztom a "Kötet" lapot, és a "Mappa hozzáadása" gombra kattintok. Ott létrehozok egy új adatbázis mappát ezzel a "/calibre" csatolási útvonallal.
{{< gallery match="images/5/*.png" >}}
A Calibre konténerhez fix portokat rendelek. Fix portok nélkül előfordulhat, hogy a Calibre egy másik porton fut az újraindítás után.
{{< gallery match="images/6/*.png" >}}
Ezek után a beállítások után a Calibre elindítható!
{{< gallery match="images/7/*.png" >}}
Most meghívom a Synology IP-címét a hozzárendelt Calibre porttal, és a következő képet látom. A "Calibre adatbázis helyeként" a "/calibre" bejegyzést adom meg. A többi beállítás ízlés kérdése.
{{< gallery match="images/8/*.png" >}}
Az alapértelmezett bejelentkezés az "admin" és az "admin123" jelszó.
{{< gallery match="images/9/*.png" >}}
Kész! Természetesen most már az asztali alkalmazást is csatlakoztathatom a "könyvmappámon" keresztül. Megcserélem a könyvtárat az alkalmazásomban, majd kiválasztom a Nas mappát.
{{< gallery match="images/10/*.png" >}}
Valahogy így:
{{< gallery match="images/11/*.png" >}}
Ha most az asztali alkalmazásban meta-infókat szerkesztek, akkor azok automatikusan frissülnek a webes alkalmazásban is.
{{< gallery match="images/12/*.png" >}}
