+++
date = "2021-04-16"
title = "Velike stvari z vsebniki: lasten Bookstack Wiki na strežniku Synology DiskStation"
difficulty = "level-1"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "bookstack", "wiki"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210416-docker-Bookstack/index.sl.md"
+++
Bookstack je "odprtokodna" alternativa MediaWiki ali Confluence. Danes bom pokazal, kako namestiti storitev Bookstack na diskovno postajo Synology.
## Možnost za strokovnjake
Kot izkušen uporabnik Synologyja se lahko seveda prijavite s SSH in namestite celotno namestitev prek datoteke Docker Compose.
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
Več uporabnih slik Docker za domačo uporabo najdete v [Dockerverse]({{< ref "dockerverse" >}} "Dockerverse").
## Korak 1: Pripravite mapo za knjigoveznico
V imeniku programa Docker ustvarim nov imenik z imenom "wiki".
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
|TZ	| Europe/Berlin |Časovni pas|
|MYSQL_ROOT_PASSWORD	|  my_wiki_pass |Glavno geslo zbirke podatkov.|
|MYSQL_DATABASE | 	my_wiki	|To je ime zbirke podatkov.|
|MYSQL_USER	|  wikiuser	|Uporabniško ime zbirke podatkov wiki.|
|MYSQL_PASSWORD	|  my_wiki_pass	|Geslo uporabnika zbirke podatkov wiki.|
{{</table>}}
Na koncu vnesem te okoljske spremenljivke: Glej:
{{< gallery match="images/6/*.png" >}}
Po teh nastavitvah lahko zaženete strežnik Mariadb! Povsod pritisnem "Uporabi".
## Korak 3: Namestite Bookstack
V oknu Synology Docker kliknem na zavihek "Registracija" in poiščem "bookstack". Izberem sliko Docker "solidnerd/bookstack" in nato kliknem na oznako "latest".
{{< gallery match="images/7/*.png" >}}
Dvakrat kliknem na svojo sliko Bookstack. Nato kliknem na "Napredne nastavitve" in aktiviram možnost "Samodejni ponovni zagon".
{{< gallery match="images/8/*.png" >}}
Zabojniku "bookstack" dodelim fiksna vrata. Brez fiksnih vrat se lahko zgodi, da strežnik bookstack po ponovnem zagonu teče na drugih vratih. Prvo pristanišče za zabojnik lahko izbrišete. Ne pozabite na drugo pristanišče.
{{< gallery match="images/9/*.png" >}}
Poleg tega je treba ustvariti povezavo do vsebnika "mariadb". Kliknem na zavihek "Povezave" in izberem vsebnik zbirke podatkov. Ime vzdevka si je treba zapomniti za namestitev wikija.
{{< gallery match="images/10/*.png" >}}
{{<table "table table-striped table-bordered">}}
|Ime spremenljivke|Vrednost|Kaj je to?|
|--- | --- |---|
|TZ	| Europe/Berlin |Časovni pas|
|DB_HOST	| wiki-db:3306	|Imena aliasov / povezava na zabojnik|
|DB_DATABASE	| my_wiki |Podatki iz koraka 2|
|DB_USERNAME	| wikiuser |Podatki iz koraka 2|
|DB_PASSWORD	| my_wiki_pass	|Podatki iz koraka 2|
{{</table>}}
Na koncu vnesem te okoljske spremenljivke: Glej:
{{< gallery match="images/11/*.png" >}}
Posodo lahko zaženete. Ustvarjanje podatkovne zbirke lahko traja nekaj časa. Obnašanje lahko opazujete v podrobnostih o vsebniku.
{{< gallery match="images/12/*.png" >}}
Strežnik Bookstack pokličem z naslovom IP Synology in vratom za zabojnik. Prijavno ime je "admin@admin.com", geslo pa "password".
{{< gallery match="images/13/*.png" >}}
