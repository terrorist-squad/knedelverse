+++
date = "2021-04-16"
title = "Nagyszerű dolgok konténerekkel: Saját Bookstack Wiki a Synology DiskStationön"
difficulty = "level-1"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "bookstack", "wiki"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210416-docker-Bookstack/index.hu.md"
+++
A Bookstack a MediaWiki vagy a Confluence "nyílt forráskódú" alternatívája. Ma megmutatom, hogyan kell telepíteni a Bookstack szolgáltatást a Synology lemezállomáson.
## Lehetőség szakemberek számára
Tapasztalt Synology felhasználóként természetesen bejelentkezhet SSH-val, és telepítheti a teljes telepítést Docker Compose fájlon keresztül.
```
version: '3'
services:
  bookstack:
    image: solidnerd/bookstack:0.27.4-1
    restart: always
    ports:
      - 8080:8080
    links:
      - database
    environment:
      DB_HOST: database:3306
      DB_DATABASE: my_wiki
      DB_USERNAME: wikiuser
      DB_PASSWORD: my_wiki_pass
      
  database:
    image: mariadb
    restart: always
    volumes:
       - ./mysql:/var/lib/mysql
    environment:
      MYSQL_ROOT_PASSWORD: my_wiki_pass1
      MYSQL_DATABASE: my_wiki
      MYSQL_USER: wikiuser
      MYSQL_PASSWORD: my_wiki_pass

```
További hasznos Docker-képek otthoni használatra az [Dockerverse]({{< ref "dockerverse" >}} "Dockerverse").
## 1. lépés: Készítse elő a könyvköteg mappát
Létrehozok egy új könyvtárat "wiki" néven a Docker könyvtárban.
{{< gallery match="images/1/*.png" >}}

## 2. lépés: Adatbázis telepítése
Ezután létre kell hozni egy adatbázist. A Synology Docker ablakban a "Regisztráció" fülre kattintok, és rákeresek a "mariadb"-re. Kiválasztom a "mariadb" Docker-képet, majd a "latest" címkére kattintok.
{{< gallery match="images/2/*.png" >}}
A kép letöltése után a kép képként elérhető. A Docker 2 állapotot különböztet meg, a konténer "dinamikus állapotát" és a képet (rögzített állapot). Mielőtt létrehoznánk egy konténert a képből, néhány beállítást el kell végezni. Duplán kattintok a mariadb képemre.
{{< gallery match="images/3/*.png" >}}
Ezután a "Speciális beállítások" menüpontra kattintok, és aktiválom az "Automatikus újraindítás" opciót. Kiválasztom a "Kötet" lapot, és a "Mappa hozzáadása" gombra kattintok. Ott létrehozok egy új adatbázis mappát ezzel a mount útvonallal "/var/lib/mysql".
{{< gallery match="images/4/*.png" >}}
A "Portbeállítások" alatt az összes port törlésre kerül. Ez azt jelenti, hogy kiválasztom a "3306" portot, és a "-" gombbal törlöm.
{{< gallery match="images/5/*.png" >}}
{{<table "table table-striped table-bordered">}}
|Változó neve|Érték|Mi ez?|
|--- | --- |---|
|TZ	| Europe/Berlin |Időzóna|
|MYSQL_ROOT_PASSWORD	|  my_wiki_pass |Az adatbázis fő jelszava.|
|MYSQL_DATABASE | 	my_wiki	|Ez az adatbázis neve.|
|MYSQL_USER	|  wikiuser	|A wiki adatbázis felhasználóneve.|
|MYSQL_PASSWORD	|  my_wiki_pass	|A wiki adatbázis felhasználójának jelszava.|
{{</table>}}
Végül megadom ezeket a környezeti változókat:Lásd:
{{< gallery match="images/6/*.png" >}}
Ezek után a beállítások után a Mariadb szerver elindítható! Mindenhol megnyomom az "Alkalmazás" gombot.
## 3. lépés: A Bookstack telepítése
A Synology Docker ablakban a "Regisztráció" fülre kattintok, és rákeresek a "bookstack"-re. Kiválasztom a "solidnerd/bookstack" Docker-képet, majd a "latest" címkére kattintok.
{{< gallery match="images/7/*.png" >}}
Duplán kattintok a Bookstack-képemre. Ezután a "Speciális beállítások" menüpontra kattintok, és itt is aktiválom az "Automatikus újraindítás" opciót.
{{< gallery match="images/8/*.png" >}}
A "bookstack" konténerhez fix portokat rendelek. Fix portok nélkül előfordulhat, hogy a "bookstack szerver" egy másik porton fut az újraindítás után. Az első konténerport törölhető. A másik kikötőt nem szabad elfelejteni.
{{< gallery match="images/9/*.png" >}}
Ezenkívül még létre kell hozni egy "linket" a "mariadb" konténerhez. A "Linkek" fülre kattintok, és kiválasztom az adatbázis-konténert. Az alias nevet meg kell jegyezni a wiki telepítésénél.
{{< gallery match="images/10/*.png" >}}
{{<table "table table-striped table-bordered">}}
|Változó neve|Érték|Mi ez?|
|--- | --- |---|
|TZ	| Europe/Berlin |Időzóna|
|DB_HOST	| wiki-db:3306	|Alias nevek / konténer link|
|DB_DATABASE	| my_wiki |A 2. lépés adatai|
|DB_USERNAME	| wikiuser |A 2. lépés adatai|
|DB_PASSWORD	| my_wiki_pass	|A 2. lépés adatai|
{{</table>}}
Végül megadom ezeket a környezeti változókat:Lásd:
{{< gallery match="images/11/*.png" >}}
A konténer most már elindítható. Az adatbázis létrehozása eltarthat egy ideig. A viselkedés a konténer részletein keresztül figyelhető meg.
{{< gallery match="images/12/*.png" >}}
A Synology IP-címével és a konténerportommal hívom a Bookstack szervert. A bejelentkezési név "admin@admin.com", a jelszó pedig "password".
{{< gallery match="images/13/*.png" >}}
