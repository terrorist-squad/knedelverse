+++
date = "2021-04-17"
title = "Nagyszerű dolgok konténerekkel: Saját xWiki futtatása a Synology lemezállomáson"
difficulty = "level-1"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "xwiki", "wiki",]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210417-docker-xWiki/index.hu.md"
+++
Az XWiki egy szabad wiki szoftver platform, amely Java nyelven íródott és a bővíthetőséget szem előtt tartva tervezték. Ma megmutatom, hogyan telepíthetünk xWiki szolgáltatást a Synology DiskStationre.
## Lehetőség szakemberek számára
Tapasztalt Synology felhasználóként természetesen bejelentkezhet SSH-val, és telepítheti a teljes telepítést Docker Compose fájlon keresztül.
```
version: '3'
services:
  xwiki:
    image: xwiki:10-postgres-tomcat
    restart: always
    ports:
      - 8080:8080
    links:
      - db
    environment:
      DB_HOST: db
      DB_DATABASE: xwiki
      DB_DATABASE: xwiki
      DB_PASSWORD: xwiki
      TZ: 'Europe/Berlin'

  db:
    image: postgres:latest
    restart: always
    volumes:
      - ./postgresql:/var/lib/postgresql/data
    environment:
      - POSTGRES_USER=xwiki
      - POSTGRES_PASSWORD=xwiki
      - POSTGRES_DB=xwiki
      - TZ='Europe/Berlin'

```
További hasznos Docker-képek otthoni használatra az [Dockerverse]({{< ref "dockerverse" >}} "Dockerverse").
## 1. lépés: Készítse elő a wiki mappát
Létrehozok egy új könyvtárat "wiki" néven a Docker könyvtárban.
{{< gallery match="images/1/*.png" >}}

## 2. lépés: Adatbázis telepítése
Ezután létre kell hozni egy adatbázist. A Synology Docker ablakban a "Registration" fülre kattintok, és rákeresek a "postgres" kifejezésre. Kiválasztom a "postgres" Docker-képet, majd a "latest" címkére kattintok.
{{< gallery match="images/2/*.png" >}}
A kép letöltése után a kép képként elérhető. A Docker 2 állapotot különböztet meg, a konténer "dinamikus állapotát" és a képet (rögzített állapot). Mielőtt létrehoznánk egy konténert a képből, néhány beállítást el kell végezni. Duplán kattintok a postgres képemre.
{{< gallery match="images/3/*.png" >}}
Ezután a "Speciális beállítások" menüpontra kattintok, és aktiválom az "Automatikus újraindítás" opciót. Kiválasztom a "Kötet" lapot, és a "Mappa hozzáadása" gombra kattintok. Ott létrehozok egy új adatbázis mappát ezzel a mount útvonallal "/var/lib/postgresql/data".
{{< gallery match="images/4/*.png" >}}
A "Portbeállítások" alatt az összes port törlésre kerül. Ez azt jelenti, hogy kiválasztom az "5432" portot, és a "-" gombbal törlöm.
{{< gallery match="images/5/*.png" >}}
{{<table "table table-striped table-bordered">}}
|Változó neve|Érték|Mi ez?|
|--- | --- |---|
|TZ	| Europe/Berlin	|Időzóna|
|POSTGRES_DB	| xwiki |Ez az adatbázis neve.|
|POSTGRES_USER	| xwiki |A wiki adatbázis felhasználóneve.|
|POSTGRES_PASSWORD	| xwiki |A wiki adatbázis felhasználójának jelszava.|
{{</table>}}
Végül megadom ezt a négy környezeti változót:See:
{{< gallery match="images/6/*.png" >}}
Ezek után a beállítások után a Mariadb szerver elindítható! Mindenhol megnyomom az "Alkalmazás" gombot.
## 3. lépés: Az xWiki telepítése
A Synology Docker ablakban a "Regisztráció" fülre kattintok, és rákeresek az "xwiki"-re. Kiválasztom az "xwiki" Docker-képet, majd rákattintok a "10-postgres-tomcat" címkére.
{{< gallery match="images/7/*.png" >}}
Duplán kattintok az xwiki képemre. Ezután a "Speciális beállítások" menüpontra kattintok, és itt is aktiválom az "Automatikus újraindítás" opciót.
{{< gallery match="images/8/*.png" >}}
Az "xwiki" konténerhez fix portokat rendelek. Fix portok nélkül előfordulhat, hogy az "xwiki szerver" egy másik porton fut az újraindítás után.
{{< gallery match="images/9/*.png" >}}
Ezenkívül létre kell hozni egy "linket" a "postgres" konténerhez. A "Linkek" fülre kattintok, és kiválasztom az adatbázis-konténert. Az alias nevet meg kell jegyezni a wiki telepítésénél.
{{< gallery match="images/10/*.png" >}}
{{<table "table table-striped table-bordered">}}
|Változó neve|Érték|Mi ez?|
|--- | --- |---|
|TZ |	Europe/Berlin	|Időzóna|
|DB_HOST	| db |Alias nevek / konténer link|
|DB_DATABASE	| xwiki	|A 2. lépés adatai|
|DB_USER	| xwiki	|A 2. lépés adatai|
|DB_PASSWORD	| xwiki |A 2. lépés adatai|
{{</table>}}
Végül megadom ezeket a környezeti változókat:Lásd:
{{< gallery match="images/11/*.png" >}}
A konténer most már elindítható. Az xWiki szervert a Synology IP-címével és a konténerportommal hívom.
{{< gallery match="images/12/*.png" >}}