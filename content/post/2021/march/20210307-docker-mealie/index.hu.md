+++
date = "2021-03-07"
title = "Nagyszerű dolgok konténerekkel: receptek kezelése és archiválása a Synology DiskStation eszközön"
difficulty = "level-1"
tags = ["diskstation", "Docker", "docker-compose", "docker-for-desktop", "rezepte", "speisen", "Synology"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/march/20210307-docker-mealie/index.hu.md"
+++
Gyűjtse össze kedvenc receptjeit a Docker-konténerben, és rendezheti őket tetszése szerint. Írjon saját recepteket vagy importáljon recepteket weboldalakról, például a "Chefkoch", "Essen", "Essen", stb.
{{< gallery match="images/1/*.png" >}}

## Lehetőség szakemberek számára
Tapasztalt Synology felhasználóként természetesen bejelentkezhet SSH-val, és telepítheti a teljes telepítést Docker Compose fájlon keresztül.
```
version: "2.0"
services:
  mealie:
    container_name: mealie
    image: hkotel/mealie:latest
    restart: always
    ports:
      - 9000:80
    environment:
      db_type: sqlite
      TZ: Europa/Berlin
    volumes:
      - ./mealie/data/:/app/data

```

## 1. lépés: Docker-kép keresése
A Synology Docker ablakban a "Regisztráció" fülre kattintok, és rákeresek a "mealie"-re. Kiválasztom a "hkotel/mealie:latest" Docker-képet, majd a "latest" címkére kattintok.
{{< gallery match="images/2/*.png" >}}
A kép letöltése után a kép képként elérhető. A Docker 2 állapotot különböztet meg, a konténer "dinamikus állapotát" és a képet/képet (rögzített állapot). Mielőtt létrehozhatnánk egy konténert a képből, néhány beállítást el kell végeznünk.
## 2. lépés: Helyezze a képet működésbe:
Duplán kattintok a "mealie" képemre.
{{< gallery match="images/3/*.png" >}}
Ezután a "Speciális beállítások" menüpontra kattintok, és aktiválom az "Automatikus újraindítás" opciót. Kiválasztom a "Kötet" lapot, és a "Mappa hozzáadása" gombra kattintok. Ott létrehozok egy új mappát ezzel a "/app/data" csatlakozási útvonallal.
{{< gallery match="images/4/*.png" >}}
A "Mealie" konténerhez fix portokat rendelek. Fix portok nélkül előfordulhat, hogy a "Mealie szerver" egy másik porton fut az újraindítás után.
{{< gallery match="images/5/*.png" >}}
Végül megadok két környezeti változót. A "db_type" változó az adatbázis típusa, a "TZ" pedig az "Europe/Berlin" időzóna.
{{< gallery match="images/6/*.png" >}}
Ezek után a beállítások után a Mealie Server elindítható! Ezután a Synology diszkáció Ip címén és a hozzárendelt porton keresztül hívhatja a Mealie-t, például http://192.168.21.23:8096 .
{{< gallery match="images/7/*.png" >}}

## Hogyan működik a Mealie?
Ha az egeret a jobb/alul lévő "Plusz" gomb fölé viszem, majd a "Lánc" szimbólumra kattintok, be tudok írni egy url-t. A Mealie alkalmazás ezután automatikusan megkeresi a szükséges meta- és sémainformációkat.
{{< gallery match="images/8/*.png" >}}
Az import nagyszerűen működik (ezeket a funkciókat a Chef, Food, Food
{{< gallery match="images/9/*.png" >}}
Szerkesztési módban kategóriát is hozzáadhatok. Fontos, hogy minden kategória után egyszer megnyomjam az "Enter" billentyűt. Ellenkező esetben ez a beállítás nem kerül alkalmazásra.
{{< gallery match="images/10/*.png" >}}

## Különleges jellemzők
Észrevettem, hogy a menü kategóriái nem frissülnek automatikusan. Itt a böngésző újratöltésével kell segítenie.
{{< gallery match="images/11/*.png" >}}

## Egyéb jellemzők
Természetesen recepteket kereshet és menüket is készíthet. Ezenkívül a "Mealie" nagyon széles körben testreszabható.
{{< gallery match="images/12/*.png" >}}
A Mealie mobilon is jól néz ki:
{{< gallery match="images/13/*.*" >}}

## Rest-Api
Az API dokumentációja a "http://gewaehlte-ip:und-port ... /docs" címen található. Itt számos olyan módszert talál, amely az automatizáláshoz használható.
{{< gallery match="images/14/*.png" >}}

## Api példa
Képzeljük el a következő fikciót: "A Gruner und Jahr elindítja az Essen internetes portált".
{{< terminal >}}
wget --spider --force-html -r -l12  "https://www.essen-und-trinken.de/rezepte/archiv/"  2>&1 | grep '/rezepte/' | grep '^--' | awk '{ print $3 }' > liste.txt

{{</ terminal >}}
Ezután tisztítsuk meg ezt a listát, és lőjük ki a többi api ellen, például:
```
#!/bin/bash
sort -u liste.txt > clear.txt

while read p; do
  echo "import url: $p"
  curl -d "{\"url\":\"$p\"}" -H "Content-Type: application/json" http://synology-ip:8096/api/recipes/create-url
  sleep 1
done < clear.txt

```
Mostantól offline is hozzáférhet a receptekhez:
{{< gallery match="images/15/*.png" >}}
