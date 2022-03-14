+++
date = "2021-04-18"
title = "Nagyszerű dolgok konténerekkel: Saját dokuWiki telepítése a Synology lemezállomáson"
difficulty = "level-2"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "dokuwiki", "wiki"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/april/20210418-docker-dokuWiki/index.hu.md"
+++
A DokuWiki egy szabványoknak megfelelő, könnyen használható és ugyanakkor rendkívül sokoldalú nyílt forráskódú wiki szoftver. Ma megmutatom, hogyan kell telepíteni a DokuWiki szolgáltatást a Synology lemezállomáson.
## Lehetőség szakemberek számára
Tapasztalt Synology felhasználóként természetesen bejelentkezhet SSH-n keresztül, és telepítheti a teljes telepítést Docker Compose fájlon keresztül.
```
version: '3'
services:
  dokuwiki:
    image:  bitnami/dokuwiki:latest
    restart: always
    ports:
      - 8080:8080
      - 8443:8443
    environment:
      TZ: 'Europe/Berlin'
      DOKUWIKI_USERNAME: 'admin'
      DOKUWIKI_FULL_NAME: 'wiki'
      DOKUWIKI_PASSWORD: 'password'
    volumes:
      - ./data:/bitnami/dokuwiki

```
További hasznos Docker-képek otthoni használatra az [Dockerverse]({{< ref "dockerverse" >}} "Dockerverse").
## 1. lépés: Készítse elő a wiki mappát
Létrehozok egy új könyvtárat "wiki" néven a Docker könyvtárban.
{{< gallery match="images/1/*.png" >}}

## 2. lépés: DokuWiki telepítése
Ezután létre kell hozni egy adatbázist. A Synology Docker ablakban a "Regisztráció" fülre kattintok, és rákeresek a "dokuwiki" kifejezésre. Kiválasztom a "bitnami/dokuwiki" Docker-képet, majd a "latest" címkére kattintok.
{{< gallery match="images/2/*.png" >}}
A kép letöltése után a kép képként elérhető. A Docker 2 állapotot különböztet meg, a konténer "dinamikus állapotát" és a képet (rögzített állapot). Mielőtt létrehoznánk egy konténert a képből, néhány beállítást el kell végezni. Duplán kattintok a dokuwiki képemre.
{{< gallery match="images/3/*.png" >}}
A "dokuwiki" konténerhez fix portokat rendelek. Fix portok nélkül előfordulhat, hogy a "dokuwiki szerver" egy másik porton fut az újraindítás után.
{{< gallery match="images/4/*.png" >}}
{{<table "table table-striped table-bordered">}}
|Változó neve|Érték|Mi ez?|
|--- | --- |---|
|TZ	| Europe/Berlin	|Időzóna|
|DOKUWIKI_USERNAME	| admin|Admin felhasználónév|
|DOKUWIKI_FULL_NAME |	wiki	|WIki név|
|DOKUWIKI_PASSWORD	| password	|Admin jelszó|
{{</table>}}
Végül megadom ezeket a környezeti változókat:Lásd:
{{< gallery match="images/5/*.png" >}}
A konténer most már elindítható. A dokuWIki szervert a Synology IP-címével és a konténerportommal hívom.
{{< gallery match="images/6/*.png" >}}
