+++
date = "2021-04-16"
title = "Velike stvari z zabojniki: Namestitev lastnega MediaWikija na diskovno postajo Synology"
difficulty = "level-1"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "mediawiki", "wiki"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/april/20210416-docker-MediaWiki/index.sl.md"
+++
MediaWiki je sistem wiki, ki temelji na PHP in je na voljo brezplačno kot odprtokodni izdelek. Danes bom pokazal, kako namestiti storitev MediaWiki na diskovno postajo Synology.
## Možnost za strokovnjake
Kot izkušen uporabnik Synologyja se lahko seveda prijavite s SSH in namestite celotno namestitev prek datoteke Docker Compose.
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
Več uporabnih slik Docker za domačo uporabo najdete v [Dockerverse]({{< ref "dockerverse" >}} "Dockerverse").
## Korak 1: Pripravite mapo MediaWiki
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
|TZ	| Europe/Berlin	|Časovni pas|
|MYSQL_ROOT_PASSWORD	| my_wiki_pass	|Glavno geslo zbirke podatkov.|
|MYSQL_DATABASE |	my_wiki	|To je ime zbirke podatkov.|
|MYSQL_USER	| wikiuser |Uporabniško ime zbirke podatkov wiki.|
|MYSQL_PASSWORD	| my_wiki_pass |Geslo uporabnika zbirke podatkov wiki.|
{{</table>}}
Na koncu vnesem te okoljske spremenljivke: Glej:
{{< gallery match="images/6/*.png" >}}
Po teh nastavitvah lahko zaženete strežnik Mariadb! Povsod pritisnem "Uporabi".
## Korak 3: Namestitev MediaWiki
V oknu Synology Docker kliknem na zavihek "Registracija" in poiščem "mediawiki". Izberem sliko Docker "mediawiki" in nato kliknem na oznako "latest".
{{< gallery match="images/7/*.png" >}}
Dvakrat kliknem na sliko Mediawiki.
{{< gallery match="images/8/*.png" >}}
Nato kliknem na "Napredne nastavitve" in aktiviram možnost "Samodejni ponovni zagon". Izberem zavihek "Zvezek" in kliknem na "Dodaj mapo". Tam ustvarim novo mapo s to potjo "/var/www/html/images".
{{< gallery match="images/9/*.png" >}}
Za vsebnik "MediaWiki" dodelim fiksna vrata. Brez fiksnih vrat se lahko zgodi, da strežnik MediaWiki po ponovnem zagonu teče na drugih vratih.
{{< gallery match="images/10/*.png" >}}
Poleg tega je treba ustvariti povezavo do vsebnika "mariadb". Kliknem na zavihek "Povezave" in izberem vsebnik zbirke podatkov. Ime vzdevka si je treba zapomniti za namestitev wikija.
{{< gallery match="images/11/*.png" >}}
Na koncu vnesem okoljsko spremenljivko "TZ" z vrednostjo "Europe/Berlin".
{{< gallery match="images/12/*.png" >}}
Posodo lahko zaženete. Strežnik Mediawiki pokličem z naslovom IP strežnika Synology in pristaniščem zabojnika. Pod strežnik podatkovne baze vnesem vzdevek imena vsebnika podatkovne baze. Vnesem tudi ime podatkovne zbirke, uporabniško ime in geslo iz koraka 2.
{{< gallery match="images/13/*.png" >}}