+++
date = "2021-04-18"
title = "Nagyszerű dolgok konténerekkel: Saját WallaBag a Synology lemezállomáson"
difficulty = "level-1"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "archiv", "wallabag"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210418-docker-WallaBag/index.hu.md"
+++
A Wallabag egy érdekes weboldalak vagy cikkek archiválására szolgáló program. Ma megmutatom, hogyan kell telepíteni a Wallabag szolgáltatást a Synology lemezállomáson.
## Lehetőség szakemberek számára
Tapasztalt Synology felhasználóként természetesen bejelentkezhet SSH-n keresztül, és telepítheti a teljes telepítést Docker Compose fájlon keresztül.
```
version: '3'
services:
  wallabag:
    image: wallabag/wallabag
    environment:
      - MYSQL_ROOT_PASSWORD=wallaroot
      - SYMFONY__ENV__DATABASE_DRIVER=pdo_mysql
      - SYMFONY__ENV__DATABASE_HOST=db
      - SYMFONY__ENV__DATABASE_PORT=3306
      - SYMFONY__ENV__DATABASE_NAME=wallabag
      - SYMFONY__ENV__DATABASE_USER=wallabag
      - SYMFONY__ENV__DATABASE_PASSWORD=wallapass
      - SYMFONY__ENV__DATABASE_CHARSET=utf8mb4
      - SYMFONY__ENV__DOMAIN_NAME=http://192.168.178.50:8089
      - SYMFONY__ENV__SERVER_NAME="Your wallabag instance"
      - SYMFONY__ENV__FOSUSER_CONFIRMATION=false
      - SYMFONY__ENV__TWOFACTOR_AUTH=false
    ports:
      - "8089:80"
    volumes:
      - ./wallabag/images:/var/www/wallabag/web/assets/images

  db:
    image: mariadb
    environment:
      - MYSQL_ROOT_PASSWORD=wallaroot
    volumes:
      - ./mariadb:/var/lib/mysql

```
További hasznos Docker-képek otthoni használatra az [Dockerverse]({{< ref "dockerverse" >}} "Dockerverse").
## 1. lépés: Készítsük elő a wallabag mappát
Létrehozok egy új könyvtárat "wallabag" néven a Docker könyvtárban.
{{< gallery match="images/1/*.png" >}}

## 2. lépés: Adatbázis telepítése
Ezután létre kell hozni egy adatbázist. A Synology Docker ablakban a "Regisztráció" fülre kattintok, és rákeresek a "mariadb"-re. Kiválasztom a "mariadb" Docker-képet, majd a "latest" címkére kattintok.
{{< gallery match="images/2/*.png" >}}
A kép letöltése után a kép képként elérhető. A Docker 2 állapotot különböztet meg, a konténer "dinamikus állapotát" és a képet (rögzített állapot). Mielőtt létrehoznánk egy konténert a képből, néhány beállítást el kell végezni. Duplán kattintok a mariadb képemre.
{{< gallery match="images/3/*.png" >}}
Ezután a "Speciális beállítások" gombra kattintok, és aktiválom az "Automatikus újraindítás" opciót. Kiválasztom a "Kötet" lapot, és a "Mappa hozzáadása" gombra kattintok. Ott létrehozok egy új adatbázis mappát ezzel a mount útvonallal "/var/lib/mysql".
{{< gallery match="images/4/*.png" >}}
A "Portbeállítások" alatt az összes port törlődik. Ez azt jelenti, hogy kiválasztom a "3306" portot, és a "-" gombbal törlöm.
{{< gallery match="images/5/*.png" >}}
{{<table "table table-striped table-bordered">}}
|Változó neve|Érték|Mi ez?|
|--- | --- |---|
|TZ| Europe/Berlin	|Időzóna|
|MYSQL_ROOT_PASSWORD	 | wallaroot |Az adatbázis fő jelszava.|
{{</table>}}
Végül megadom ezeket a környezeti változókat:Lásd:
{{< gallery match="images/6/*.png" >}}
Ezek után a beállítások után a Mariadb szerver elindítható! Mindenhol megnyomom az "Alkalmazás" gombot.
{{< gallery match="images/7/*.png" >}}

## 3. lépés: A Wallabag telepítése
A Synology Docker ablakban a "Regisztráció" fülre kattintok, és rákeresek a "wallabag"-ra. Kiválasztom a "wallabag/wallabag" Docker-képet, majd a "latest" címkére kattintok.
{{< gallery match="images/8/*.png" >}}
Duplán kattintok a fali táska képére. Ezután a "Speciális beállítások" menüpontra kattintok, és itt is aktiválom az "Automatikus újraindítás" opciót.
{{< gallery match="images/9/*.png" >}}
Kiválasztom a "Kötet" fület, és a "Mappa hozzáadása" gombra kattintok. Ott létrehozok egy új mappát ezzel a mount útvonallal "/var/www/wallabag/web/assets/images".
{{< gallery match="images/10/*.png" >}}
A "wallabag" konténerhez fix portokat rendelek. Fix portok nélkül előfordulhat, hogy a "wallabag szerver" egy másik porton fut az újraindítás után. Az első konténerport törölhető. A másik kikötőt nem szabad elfelejteni.
{{< gallery match="images/11/*.png" >}}
Ezenkívül még létre kell hozni egy "linket" a "mariadb" konténerhez. A "Linkek" fülre kattintok, és kiválasztom az adatbázis-konténert. Az alias nevet meg kell jegyezni a wallabag telepítéséhez.
{{< gallery match="images/12/*.png" >}}
{{<table "table table-striped table-bordered">}}
|Umgebungsvariable	|Érték|
|--- |---|
|MYSQL_ROOT_PASSWORD	|wallaroot|
|SYMFONY__ENV__DATABASE_DRIVER	|pdo_mysql|
|SYMFONY__ENV__DATABASE_HOST	|db|
|SYMFONY__ENV__DATABASE_PORT	|3306|
|SYMFONY__ENV__DATABASE_NAME	|wallabag|
|SYMFONY__ENV__DATABASE_USER	|wallabag|
|SYMFONY__ENV__DATABASE_PASSWORD	|wallapass|
|SYMFONY__ENV__DATABASE_CHARSET |utf8mb4|
|SYMFONY__ENV__DOMAIN_NAME	|"http://synology-ip:container-port" <- Kérjük, változtassa meg|
|SYMFONY__ENV__SERVER_NAME	|"Wallabag - szerver"|
|SYMFONY__ENV__FOSUSER_CONFIRMATION	|hamis|
|SYMFONY__ENV__TWOFACTOR_AUTH	|hamis|
{{</table>}}
Végül megadom ezeket a környezeti változókat:Lásd:
{{< gallery match="images/13/*.png" >}}
A konténer most már elindítható. Az adatbázis létrehozása eltarthat egy ideig. A viselkedés a konténer részletein keresztül figyelhető meg.
{{< gallery match="images/14/*.png" >}}
Felhívom a wallabag szervert a Synology IP-címével és a konténerportommal.
{{< gallery match="images/15/*.png" >}}
Azt kell mondanom azonban, hogy én személy szerint jobban szeretem a shiorit mint internetes archívumot.
