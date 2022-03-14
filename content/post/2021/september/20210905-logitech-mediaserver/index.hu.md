+++
date = "2021-09-05"
title = "Nagyszerű dolgok konténerekkel: Logitech médiaszerverek a Synology lemezállomáson"
difficulty = "level-1"
tags = ["logitech", "synology", "diskstation", "nas", "sound-system", "multiroom"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/september/20210905-logitech-mediaserver/index.hu.md"
+++
Ebben a bemutatóban megtanulhatja, hogyan telepíthet egy Logitech Media Server-t a Synology DiskStationre.
{{< gallery match="images/1/*.jpg" >}}

## 1. lépés: A Logitech Media Server mappa előkészítése
Létrehozok egy új könyvtárat "logitechmediaserver" néven a Docker könyvtárban.
{{< gallery match="images/2/*.png" >}}

## 2. lépés: A Logitech Mediaserver kép telepítése
A Synology Docker ablakban a "Regisztráció" fülre kattintok, és rákeresek a "logitechmediaserver"-re. Kiválasztom az "lmscommunity/logitechmediaserver" Docker-képet, majd a "latest" címkére kattintok.
{{< gallery match="images/3/*.png" >}}
Duplán kattintok a Logitech Media Server képemre. Ezután a "Speciális beállítások" menüpontra kattintok, és itt is aktiválom az "Automatikus újraindítás" opciót.
{{< gallery match="images/4/*.png" >}}
{{<table "table table-striped table-bordered">}}
|Ordner |Mountpath|
|--- |---|
|/volume1/docker/logitechmediaserver/config |/config|
|/volume1/docker/logitechmediaserver/music |/zene|
|/volume1/docker/logitechmediaserver/playlist |/playlist|
{{</table>}}
Kiválasztom a "Kötet" lapot, és a "Mappa hozzáadása" gombra kattintok. Ott három mappát hozok létre:Lásd:
{{< gallery match="images/5/*.png" >}}
A "Logitechmediaserver" konténerhez fix portokat rendelek. Fix portok nélkül előfordulhat, hogy a "Logitechmediaserver szerver" egy másik porton fut az újraindítás után.
{{< gallery match="images/6/*.png" >}}
Végül megadok egy környezeti változót. A "TZ" változó az "Európa/Berlin" időzóna.
{{< gallery match="images/7/*.png" >}}
Ezek után a beállítások után a Logitechmediaserver-Server elindítható! Ezután a Logitechmediaserver-t a Synology disctation Ip címén és a hozzárendelt porton keresztül hívhatja, például http://192.168.21.23:9000 .
{{< gallery match="images/8/*.png" >}}
