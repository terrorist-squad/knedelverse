+++
date = "2021-04-16"
title = "Nagyszerű dolgok konténerekkel: Wiki.js telepítése a Synology Diskstationre"
difficulty = "level-1"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "wikijs", "wiki"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/april/20210416-docker-Wikijs/index.hu.md"
+++
A Wiki.js egy nagy teljesítményű, nyílt forráskódú wiki szoftver, amely egyszerű felületével élvezetessé teszi a dokumentálást. Ma megmutatom, hogyan lehet telepíteni egy Wiki.js szolgáltatást a Synology DiskStationre.
## Lehetőség szakemberek számára
Tapasztalt Synology felhasználóként természetesen bejelentkezhet SSH-val, és telepítheti a teljes telepítést Docker Compose fájlon keresztül.
```
version: '3'
services:
  wikijs:
    image: requarks/wiki:latest
    restart: always
    ports:
      - 8082:3000
    links:
      - database
    environment:
      DB_TYPE: mysql
      DB_HOST: database
      DB_PORT: 3306
      DB_NAME: my_wiki
      DB_USER: wikiuser
      DB_PASS: my_wiki_pass
      TZ: 'Europe/Berlin'

  database:
    image: mysql
    restart: always
    expose:
      - 3306
    volumes:
       - ./mysql:/var/lib/mysql
    environment:
      MYSQL_ROOT_PASSWORD: my_wiki_pass
      MYSQL_DATABASE: my_wiki
      MYSQL_USER: wikiuser
      MYSQL_PASSWORD: my_wiki_pass

```
További hasznos Docker-képeket találsz otthoni használatra a Dockerverse-ben.
## 1. lépés: Készítse elő a wiki mappát
Létrehozok egy új könyvtárat "wiki" néven a Docker könyvtárban.
{{< gallery match="images/1/*.png" >}}

## 2. lépés: Adatbázis telepítése
Ezután létre kell hozni egy adatbázist. A Synology Docker ablakban a "Regisztráció" fülre kattintok, és rákeresek a "mysql"-re. Kiválasztom a "mysql" Docker-képet, majd a "latest" címkére kattintok.
{{< gallery match="images/2/*.png" >}}
A kép letöltése után a kép képként elérhető. A Docker 2 állapotot különböztet meg, a konténer "dinamikus állapotát" és a képet (rögzített állapot). Mielőtt létrehoznánk egy konténert a képből, néhány beállítást el kell végezni. Duplán kattintok a mysql képemre.
{{< gallery match="images/3/*.png" >}}
Ezután a "Speciális beállítások" menüpontra kattintok, és aktiválom az "Automatikus újraindítás" opciót. Kiválasztom a "Kötet" lapot, és a "Mappa hozzáadása" gombra kattintok. Ott létrehozok egy új adatbázis mappát ezzel a mount útvonallal "/var/lib/mysql".
{{< gallery match="images/4/*.png" >}}
A "Portbeállítások" alatt az összes port törlésre kerül. Ez azt jelenti, hogy kiválasztom a "3306" portot, és a "-" gombbal törlöm.
{{< gallery match="images/5/*.png" >}}
{{<table "table table-striped table-bordered">}}
|Változó neve|Érték|Mi ez?|
|--- | --- |---|
|TZ	| Europe/Berlin |Időzóna|
|MYSQL_ROOT_PASSWORD	| my_wiki_pass |Az adatbázis fő jelszava.|
|MYSQL_DATABASE |	my_wiki |Ez az adatbázis neve.|
|MYSQL_USER	| wikiuser |A wiki adatbázis felhasználóneve.|
|MYSQL_PASSWORD |	my_wiki_pass	|A wiki adatbázis felhasználójának jelszava.|
{{</table>}}
Végül megadom ezt a négy környezeti változót:See:
{{< gallery match="images/6/*.png" >}}
Ezek után a beállítások után a Mariadb szerver elindítható! Mindenhol megnyomom az "Alkalmazás" gombot.
## 3. lépés: Telepítse a Wiki.js-t
A Synology Docker ablakban a "Regisztráció" fülre kattintok, és rákeresek a "wiki"-re. Kiválasztom a "requarks/wiki" Docker-képet, majd a "latest" címkére kattintok.
{{< gallery match="images/7/*.png" >}}
Duplán kattintok a WikiJS-képemre. Ezután a "Speciális beállítások" menüpontra kattintok, és itt is aktiválom az "Automatikus újraindítás" opciót.
{{< gallery match="images/8/*.png" >}}
A "WikiJS" konténerhez fix portokat rendelek. Fix portok nélkül előfordulhat, hogy a "bookstack szerver" egy másik porton fut az újraindítás után.
{{< gallery match="images/9/*.png" >}}
Ezenkívül létre kell hozni egy "linket" a "mysql" konténerhez. A "Linkek" fülre kattintok, és kiválasztom az adatbázis-konténert. Az alias nevet meg kell jegyezni a wiki telepítésénél.
{{< gallery match="images/10/*.png" >}}
{{<table "table table-striped table-bordered">}}
|Változó neve|Érték|Mi ez?|
|--- | --- |---|
|TZ	| Europe/Berlin	|Időzóna|
|DB_HOST	| wiki-db	|Alias nevek / konténer link|
|DB_TYPE	| mysql	||
|DB_PORT	| 3306	 ||
|DB_PASSWORD	| my_wiki	|A 2. lépés adatai|
|DB_USER	| wikiuser |A 2. lépés adatai|
|DB_PASS	| my_wiki_pass	|A 2. lépés adatai|
{{</table>}}
Végül megadom ezeket a környezeti változókat:Lásd:
{{< gallery match="images/11/*.png" >}}
A konténer most már elindítható. A Wiki.js kiszolgálót a Synology IP-címével és a konténerportom/3000-es portjával hívom.
{{< gallery match="images/12/*.png" >}}