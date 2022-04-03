+++
date = "2021-04-16"
title = "Velike stvari s posodami: namestitev Wiki.js na strežnik Synology Diskstation"
difficulty = "level-1"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "wikijs", "wiki"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210416-docker-Wikijs/index.sl.md"
+++
Wiki.js je zmogljiva odprtokodna programska oprema wiki, ki s svojim preprostim vmesnikom poskrbi za prijetno dokumentiranje. Danes bom pokazal, kako v strežnik Synology DiskStation namestiti storitev Wiki.js.
## Možnost za strokovnjake
Kot izkušen uporabnik Synologyja se lahko seveda prijavite s SSH in namestite celotno namestitev prek datoteke Docker Compose.
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
Več uporabnih slik Docker za domačo uporabo najdete v Dockerverse.
## Korak 1: Pripravite mapo wiki
V imeniku programa Docker ustvarim nov imenik z imenom "wiki".
{{< gallery match="images/1/*.png" >}}

## Korak 2: Namestitev podatkovne zbirke
Nato je treba ustvariti zbirko podatkov. V oknu Synology Docker kliknem na zavihek "Registracija" in poiščem "mysql". Izberem sliko Docker "mysql" in nato kliknem na oznako "latest".
{{< gallery match="images/2/*.png" >}}
Po prenosu slike je slika na voljo kot slika. Docker razlikuje med dvema stanjema, zabojnikom (dinamično stanje) in sliko (fiksno stanje). Preden iz slike ustvarimo vsebnik, je treba opraviti nekaj nastavitev. Dvakrat kliknem na svojo sliko mysql.
{{< gallery match="images/3/*.png" >}}
Nato kliknem na "Napredne nastavitve" in aktiviram možnost "Samodejni ponovni zagon". Izberem zavihek "Zvezek" in kliknem na "Dodaj mapo". Tam ustvarim novo mapo podatkovne zbirke s to potjo za priklop "/var/lib/mysql".
{{< gallery match="images/4/*.png" >}}
V razdelku "Nastavitve vrat" so izbrisana vsa vrata. To pomeni, da izberem vrata "3306" in jih izbrišem z gumbom "-".
{{< gallery match="images/5/*.png" >}}
{{<table "table table-striped table-bordered">}}
|Ime spremenljivke|Vrednost|Kaj je to?|
|--- | --- |---|
|TZ	| Europe/Berlin |Časovni pas|
|MYSQL_ROOT_PASSWORD	| my_wiki_pass |Glavno geslo zbirke podatkov.|
|MYSQL_DATABASE |	my_wiki |To je ime zbirke podatkov.|
|MYSQL_USER	| wikiuser |Uporabniško ime zbirke podatkov wiki.|
|MYSQL_PASSWORD |	my_wiki_pass	|Geslo uporabnika zbirke podatkov wiki.|
{{</table>}}
Na koncu vnesem te štiri okoljske spremenljivke:Glej:
{{< gallery match="images/6/*.png" >}}
Po teh nastavitvah lahko zaženete strežnik Mariadb! Povsod pritisnem "Uporabi".
## Korak 3: Namestite Wiki.js
V oknu Synology Docker kliknem na zavihek "Registracija" in poiščem "wiki". Izberem sliko Docker "requarks/wiki" in nato kliknem na oznako "latest".
{{< gallery match="images/7/*.png" >}}
Dvakrat kliknem na svojo sliko WikiJS. Nato kliknem na "Napredne nastavitve" in aktiviram možnost "Samodejni ponovni zagon".
{{< gallery match="images/8/*.png" >}}
Za vsebnik "WikiJS" dodelim fiksna vrata. Brez fiksnih vrat se lahko zgodi, da "strežnik bookstack" po ponovnem zagonu teče na drugih vratih.
{{< gallery match="images/9/*.png" >}}
Poleg tega je treba ustvariti povezavo do vsebnika "mysql". Kliknem na zavihek "Povezave" in izberem vsebnik zbirke podatkov. Ime vzdevka si je treba zapomniti za namestitev wikija.
{{< gallery match="images/10/*.png" >}}
{{<table "table table-striped table-bordered">}}
|Ime spremenljivke|Vrednost|Kaj je to?|
|--- | --- |---|
|TZ	| Europe/Berlin	|Časovni pas|
|DB_HOST	| wiki-db	|Imena aliasov / povezava na zabojnik|
|DB_TYPE	| mysql	||
|DB_PORT	| 3306	 ||
|DB_PASSWORD	| my_wiki	|Podatki iz koraka 2|
|DB_USER	| wikiuser |Podatki iz koraka 2|
|DB_PASS	| my_wiki_pass	|Podatki iz koraka 2|
{{</table>}}
Na koncu vnesem te okoljske spremenljivke: Glej:
{{< gallery match="images/11/*.png" >}}
Posodo lahko zaženete. Strežnik Wiki.js pokličem z naslovom IP Synology in pristaniščem za zabojnik/3000.
{{< gallery match="images/12/*.png" >}}
