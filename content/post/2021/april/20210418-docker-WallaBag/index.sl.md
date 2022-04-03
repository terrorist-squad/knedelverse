+++
date = "2021-04-18"
title = "Velike stvari z zabojniki: Lastna torba WallaBag na diskovni postaji Synology"
difficulty = "level-1"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "archiv", "wallabag"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210418-docker-WallaBag/index.sl.md"
+++
Wallabag je program za arhiviranje zanimivih spletnih mest ali člankov. Danes bom pokazal, kako namestiti storitev Wallabag na diskovno postajo Synology.
## Možnost za strokovnjake
Kot izkušen uporabnik Synologyja se lahko seveda prijavite s SSH in namestite celotno namestitev prek datoteke Docker Compose.
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
Več uporabnih slik Docker za domačo uporabo najdete v [Dockerverse]({{< ref "dockerverse" >}} "Dockerverse").
## Korak 1: Pripravite mapo za torbo
V imeniku programa Docker ustvarim nov imenik z imenom "wallabag".
{{< gallery match="images/1/*.png" >}}

## Korak 2: Namestitev podatkovne zbirke
Nato je treba ustvariti zbirko podatkov. V oknu Synology Docker kliknem na zavihek "Registracija" in poiščem "mariadb". Izberem sliko Docker "mariadb" in nato kliknem na oznako "latest".
{{< gallery match="images/2/*.png" >}}
Po prenosu slike je slika na voljo kot slika. Docker razlikuje med dvema stanjema, zabojnikom (dinamično stanje) in sliko (fiksno stanje). Preden iz slike ustvarimo vsebnik, je treba opraviti nekaj nastavitev. Dvakrat kliknem na svojo sliko mariadb.
{{< gallery match="images/3/*.png" >}}
Nato kliknem na "Napredne nastavitve" in aktiviram možnost "Samodejni ponovni zagon". Izberem zavihek "Zvezek" in kliknem na "Dodaj mapo". Tam ustvarim novo mapo podatkovne zbirke s to potjo za priklop "/var/lib/mysql".
{{< gallery match="images/4/*.png" >}}
V razdelku "Nastavitve vrat" so izbrisana vsa vrata. To pomeni, da izberem vrata "3306" in jih izbrišem z gumbom "-".
{{< gallery match="images/5/*.png" >}}
{{<table "table table-striped table-bordered">}}
|Ime spremenljivke|Vrednost|Kaj je to?|
|--- | --- |---|
|TZ| Europe/Berlin	|Časovni pas|
|MYSQL_ROOT_PASSWORD	 | wallaroot |Glavno geslo zbirke podatkov.|
{{</table>}}
Na koncu vnesem te okoljske spremenljivke: Glej:
{{< gallery match="images/6/*.png" >}}
Po teh nastavitvah lahko zaženete strežnik Mariadb! Povsod pritisnem "Uporabi".
{{< gallery match="images/7/*.png" >}}

## Korak 3: Namestite aplikacijo Wallabag
V oknu Synology Docker kliknem na zavihek "Registracija" in poiščem "wallabag". Izberem sliko Docker "wallabag/wallabag" in nato kliknem na oznako "latest".
{{< gallery match="images/8/*.png" >}}
Dvakrat kliknem na sliko svoje torbe. Nato kliknem na "Napredne nastavitve" in aktiviram možnost "Samodejni ponovni zagon".
{{< gallery match="images/9/*.png" >}}
Izberem zavihek "Zvezek" in kliknem na "Dodaj mapo". Tam ustvarim novo mapo s to potjo priklopa "/var/www/wallabag/web/assets/images".
{{< gallery match="images/10/*.png" >}}
Zabojniku "wallabag" dodelim fiksna vrata. Brez fiksnih vrat se lahko zgodi, da "strežnik wallabag" po ponovnem zagonu teče na drugih vratih. Prvo pristanišče za zabojnik lahko izbrišete. Ne pozabite na drugo pristanišče.
{{< gallery match="images/11/*.png" >}}
Poleg tega je treba ustvariti povezavo do vsebnika "mariadb". Kliknem na zavihek "Povezave" in izberem vsebnik zbirke podatkov. Ime vzdevka si je treba zapomniti za namestitev wallabaga.
{{< gallery match="images/12/*.png" >}}
{{<table "table table-striped table-bordered">}}
|Umgebungsvariable	|Vrednost|
|--- |---|
|MYSQL_ROOT_PASSWORD	|wallaroot|
|SYMFONY__ENV__DATABASE_DRIVER	|pdo_mysql|
|SYMFONY__ENV__DATABASE_HOST	|db|
|SYMFONY__ENV__DATABASE_PORT	|3306|
|SYMFONY__ENV__DATABASE_NAME	|wallabag|
|SYMFONY__ENV__DATABASE_USER	|wallabag|
|SYMFONY__ENV__DATABASE_PASSWORD	|wallapass|
|SYMFONY__ENV__DATABASE_CHARSET |utf8mb4|
|SYMFONY__ENV__DOMAIN_NAME	|"http://synology-ip:container-port" <- Prosimo, spremenite|
|SYMFONY__ENV__SERVER_NAME	|"Wallabag - strežnik"|
|SYMFONY__ENV__FOSUSER_CONFIRMATION	|lažno|
|SYMFONY__ENV__TWOFACTOR_AUTH	|lažno|
{{</table>}}
Na koncu vnesem te okoljske spremenljivke: Glej:
{{< gallery match="images/13/*.png" >}}
Posodo lahko zaženete. Ustvarjanje podatkovne zbirke lahko traja nekaj časa. Obnašanje lahko opazujete v podrobnostih o vsebniku.
{{< gallery match="images/14/*.png" >}}
Strežnik wallabag pokličem z naslovom IP Synology in vratom za zabojnik.
{{< gallery match="images/15/*.png" >}}
Vendar moram reči, da imam osebno raje shiori kot internetni arhiv.
