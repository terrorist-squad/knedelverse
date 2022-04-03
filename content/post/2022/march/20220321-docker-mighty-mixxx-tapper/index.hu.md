+++
date = "2022-03-21"
title = "Nagyszerű dolgok konténerekkel: MP3 felvételek rögzítése a rádióból"
difficulty = "level-1"
tags = ["diskstation", "Docker", "docker-compose", "docker-for-desktop", "radio", "mp3", "ripp", "streamripper", "radiorecorder"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2022/march/20220321-docker-mighty-mixxx-tapper/index.hu.md"
+++
A Streamripper egy parancssori eszköz, amely MP3 vagy OGG/Vorbis streamek rögzítésére és közvetlen merevlemezre mentésére használható. A dalokat automatikusan az előadó után nevezi el és külön-külön menti el, a formátum az eredetileg elküldött formátum (tehát gyakorlatilag .mp3 vagy .ogg kiterjesztésű fájlok jönnek létre). Találtam egy nagyszerű rádiófelvevő felületet és építettem belőle egy Docker image-et, lásd: https://github.com/terrorist-squad/mightyMixxxTapper/
{{< gallery match="images/1/*.png" >}}

## Lehetőség szakemberek számára
Tapasztalt Synology felhasználóként természetesen bejelentkezhet SSH-n keresztül, és telepítheti a teljes telepítést Docker Compose fájlon keresztül.
```
version: "2.0"
services:
  mealie:
    container_name: mighty-mixxx-tapper
    image: chrisknedel/mighty-mixxx-tapper:latest
    restart: always
    ports:
      - 9000:80
    environment:
      TZ: Europa/Berlin
    volumes:
      - ./ripps/:/tmp/ripps/

```

## 1. lépés: Docker-kép keresése
A Synology Docker ablakban a "Registration" fülre kattintok, és rákeresek a "mighty-mixxx-tapper"-re. Kiválasztom a "chrisknedel/mighty-mixxx-tapper" Docker-képet, majd a "latest" címkére kattintok.
{{< gallery match="images/2/*.png" >}}
A kép letöltése után a kép képként elérhető. A Docker 2 állapotot különböztet meg, a konténer "dinamikus állapotát" és a képet/képet (rögzített állapot). Mielőtt létrehozhatnánk egy konténert a képből, néhány beállítást el kell végeznünk.
## 2. lépés: Helyezze a képet működésbe:
Duplán kattintok a "mighty-mixxx-tapper" képemre.
{{< gallery match="images/3/*.png" >}}
Ezután a "Speciális beállítások" gombra kattintok, és aktiválom az "Automatikus újraindítás" opciót. Kiválasztom a "Kötet" lapot, és a "Mappa hozzáadása" gombra kattintok. Ott létrehozok egy új mappát ezzel a "/tmp/ripps/" csatlakozási útvonallal.
{{< gallery match="images/4/*.png" >}}
A "mighty-mixxx-tapper" konténerhez fix portokat rendelek. Fix portok nélkül előfordulhat, hogy a "mighty-mixxx-tapper-server" egy másik porton fut az újraindítás után.
{{< gallery match="images/5/*.png" >}}
Ezek után a mighty-mixxx-tapper-server elindítható! Ezután a Synology disctation Ip-címén és a hozzárendelt porton keresztül hívhatja a mighty-mixxx-tapper-t, például a http://192.168.21.23:8097 címen keresztül.
{{< gallery match="images/6/*.png" >}}
