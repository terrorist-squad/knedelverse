+++
date = "2021-04-16"
title = "Nagyszerű dolgok konténerekkel: Saját MediaWiki telepítése a Synology lemezállomáson"
difficulty = "level-1"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "mediawiki", "wiki"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210416-docker-MediaWiki/index.hu.md"
+++
A MediaWiki egy PHP-alapú wiki rendszer, amely nyílt forráskódú termékként ingyenesen elérhető. Ma megmutatom, hogyan lehet telepíteni egy MediaWiki szolgáltatást a Synology lemezállomáson.
## Lehetőség szakemberek számára
Tapasztalt Synology felhasználóként természetesen bejelentkezhet SSH-n keresztül, és telepítheti a teljes telepítést Docker Compose fájlon keresztül.
```
version: '3'
services:
  mediawiki:
    image: mediawiki
    restart: always
    ports:
      - 8081:80
    links:
      - database
    volumes:
      - ./images:/var/www/html/images
      # After initial setup, download LocalSettings.php to the same directory as
      # this yaml and uncomment the following line and use compose to restart
      # the mediawiki service
      # - ./LocalSettings.php:/var/www/html/LocalSettings.php

  database:
    image: mariadb
    restart: always
    volumes:
       - ./mysql:/var/lib/mysql
    environment:
      # @see https://phabricator.wikimedia.org/source/mediawiki/browse/master/includes/DefaultSettings.php
      MYSQL_ROOT_PASSWORD: my_wiki_pass1
      MYSQL_DATABASE: my_wiki
      MYSQL_USER: wikiuser
      MYSQL_PASSWORD: my_wiki_pass

```
További hasznos Docker-képek otthoni használatra az [Dockerverse]({{< ref "dockerverse" >}} "Dockerverse").
## 1. lépés: MediaWiki mappa előkészítése
Létrehozok egy új könyvtárat "wiki" néven a Docker könyvtárban.
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
|TZ	| Europe/Berlin	|Időzóna|
|MYSQL_ROOT_PASSWORD	| my_wiki_pass	|Az adatbázis fő jelszava.|
|MYSQL_DATABASE |	my_wiki	|Ez az adatbázis neve.|
|MYSQL_USER	| wikiuser |A wiki adatbázis felhasználóneve.|
|MYSQL_PASSWORD	| my_wiki_pass |A wiki adatbázis felhasználójának jelszava.|
{{</table>}}
Végül megadom ezeket a környezeti változókat:Lásd:
{{< gallery match="images/6/*.png" >}}
Ezek után a beállítások után a Mariadb szerver elindítható! Mindenhol megnyomom az "Alkalmazás" gombot.
## 3. lépés: A MediaWiki telepítése
A Synology Docker ablakban a "Regisztráció" fülre kattintok, és rákeresek a "mediawiki"-re. Kiválasztom a "mediawiki" Docker-képet, majd a "latest" címkére kattintok.
{{< gallery match="images/7/*.png" >}}
Duplán kattintok a Mediawiki képemre.
{{< gallery match="images/8/*.png" >}}
Ezután a "Speciális beállítások" menüpontra kattintok, és itt is aktiválom az "Automatikus újraindítás" opciót. Kiválasztom a "Kötet" lapot, és a "Mappa hozzáadása" gombra kattintok. Ott létrehozok egy új mappát ezzel a mount útvonallal "/var/www/html/images".
{{< gallery match="images/9/*.png" >}}
A "MediaWiki" konténerhez fix portokat rendelek. Fix portok nélkül előfordulhat, hogy a "MediaWiki szerver" egy másik porton fut az újraindítás után.
{{< gallery match="images/10/*.png" >}}
Ezenkívül még létre kell hozni egy "linket" a "mariadb" konténerhez. A "Linkek" fülre kattintok, és kiválasztom az adatbázis-konténert. Az alias nevet meg kell jegyezni a wiki telepítésénél.
{{< gallery match="images/11/*.png" >}}
Végül megadok egy "TZ" környezeti változót "Europe/Berlin" értékkel.
{{< gallery match="images/12/*.png" >}}
A konténer most már elindítható. A Mediawiki szervert a Synology IP-címével és a konténer portjával hívom. Az Adatbázis kiszolgáló alatt megadom az adatbázis-konténer alias nevét. A 2. lépésben megadott adatbázis nevét, felhasználónevét és jelszavát is megadom.
{{< gallery match="images/13/*.png" >}}
