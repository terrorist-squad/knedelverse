+++
date = "2020-02-27"
title = "Nagyszerű dolgok konténerekkel: Youtube letöltő futtatása Synology Diskstationon"
difficulty = "level-1"
tags = ["Docker", "docker-compose", "download", "linux", "Synology", "video", "youtube"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2020/february/20200227-docker-youtube-dl/index.hu.md"
+++
Sok barátom tudja, hogy a Homelab - hálózatomon egy privát tanulási videoportált működtetek. A korábbi tanulási portál tagságokból származó videótanfolyamokat és jó Youtube oktatóanyagokat mentettem el offline használatra a NAS-omon.
{{< gallery match="images/1/*.png" >}}
Idővel 8845 videótanfolyamot gyűjtöttem össze 282616 egyedi videóval. A teljes futási idő körülbelül 2 év. Teljesen őrült! Ebben a bemutatóban megmutatom, hogyan lehet a jó Youtube oktatóanyagokról biztonsági másolatot készíteni egy Docker letöltési szolgáltatással offline célokra.
## Lehetőség szakemberek számára
Tapasztalt Synology felhasználóként természetesen bejelentkezhet SSH-val, és telepítheti a teljes telepítést Docker Compose fájlon keresztül.
```
version: "2"
services:
  youtube-dl:
    image: modenaf360/youtube-dl-nas
    container_name: youtube-dl
    environment:
      - MY_ID=admin
      - MY_PW=admin
    volumes:
      - ./YouTube:/downfolder
    ports:
      - 8080:8080
    restart: unless-stopped

```

## 1. lépés
Először létrehozok egy mappát a letöltéseknek. Megyek a "Rendszervezérlés" -> "Megosztott mappa" menüpontba, és létrehozok egy új mappát "Letöltések" néven.
{{< gallery match="images/2/*.png" >}}

## 2. lépés: Docker-kép keresése
A Synology Docker ablakban a "Registration" fülre kattintok, és rákeresek a "youtube-dl-nas" kifejezésre. Kiválasztom a "modenaf360/youtube-dl-nas" Docker-képet, majd a "latest" címkére kattintok.
{{< gallery match="images/3/*.png" >}}
A kép letöltése után a kép képként elérhető. A Docker 2 állapotot különböztet meg, a konténer "dinamikus állapotát" és a képet/képet (rögzített állapot). Mielőtt létrehozhatnánk egy konténert a képből, néhány beállítást el kell végeznünk.
## 3. lépés: Helyezze üzembe a képet:
Duplán kattintok a youtube-dl-nas képemre.
{{< gallery match="images/4/*.png" >}}
Ezután a "Speciális beállítások" menüpontra kattintok, és aktiválom az "Automatikus újraindítás" opciót. Kiválasztom a "Kötet" lapot, és a "Mappa hozzáadása" gombra kattintok. Ott létrehozok egy új adatbázis mappát ezzel a "/downfolder" csatlakozási útvonallal.
{{< gallery match="images/5/*.png" >}}
A "Youtube Downloader" konténerhez fix portokat rendelek. Fix portok nélkül előfordulhat, hogy a "Youtube Downloader" egy másik porton fut az újraindítás után.
{{< gallery match="images/6/*.png" >}}
Végül megadok két környezeti változót. A "MY_ID" változó a felhasználónevem, a "MY_PW" pedig a jelszavam.
{{< gallery match="images/7/*.png" >}}
Ezek után a beállítások után a Downloader elindítható! Ezután a Synology disctation Ip címén és a hozzárendelt porton keresztül hívhatja a letöltőt, például http://192.168.21.23:8070 .
{{< gallery match="images/8/*.png" >}}
A hitelesítéshez vegye a felhasználónevet és a jelszót a MY_ID és MY_PW értékekből.
## 4. lépés: Induljunk
Mostantól a Youtube-videók és lejátszási listák url-jait be lehet írni az "URL" mezőbe, és az összes videó automatikusan a Synology lemezállomás letöltési mappájába kerül.
{{< gallery match="images/9/*.png" >}}
Letöltési mappa:
{{< gallery match="images/10/*.png" >}}