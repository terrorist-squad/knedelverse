+++
date = "2021-04-17"
title = "Velike stvari z vsebniki: Zagon lastnega xWiki na diskovni postaji Synology"
difficulty = "level-1"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "xwiki", "wiki",]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210417-docker-xWiki/index.sl.md"
+++
XWiki je brezplačna programska platforma wiki, napisana v Javi in zasnovana z mislijo na razširljivost. Danes bom pokazal, kako namestiti storitev xWiki v strežnik Synology DiskStation.
## Možnost za strokovnjake
Kot izkušen uporabnik Synologyja se lahko seveda prijavite s SSH in namestite celotno namestitev prek datoteke Docker Compose.
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
Več uporabnih slik Docker za domačo uporabo najdete v [Dockerverse]({{< ref "dockerverse" >}} "Dockerverse").
## Korak 1: Pripravite mapo wiki
V imeniku programa Docker ustvarim nov imenik z imenom "wiki".
{{< gallery match="images/1/*.png" >}}

## Korak 2: Namestitev podatkovne zbirke
Nato je treba ustvariti zbirko podatkov. V oknu Synology Docker kliknem na zavihek "Registracija" in poiščem "postgres". Izberem sliko Docker "postgres" in nato kliknem na oznako "latest".
{{< gallery match="images/2/*.png" >}}
Po prenosu slike je slika na voljo kot slika. Docker razlikuje med dvema stanjema, zabojnikom (dinamično stanje) in sliko (fiksno stanje). Preden iz slike ustvarimo vsebnik, je treba opraviti nekaj nastavitev. Dvakrat kliknem na svojo sliko postgres.
{{< gallery match="images/3/*.png" >}}
Nato kliknem na "Napredne nastavitve" in aktiviram možnost "Samodejni ponovni zagon". Izberem zavihek "Obseg" in kliknem na "Dodaj mapo". Tam ustvarim novo mapo podatkovne zbirke s to potjo priklopa "/var/lib/postgresql/data".
{{< gallery match="images/4/*.png" >}}
V razdelku "Nastavitve vrat" so izbrisana vsa vrata. To pomeni, da izberem vrata "5432" in jih izbrišem z gumbom "-".
{{< gallery match="images/5/*.png" >}}
{{<table "table table-striped table-bordered">}}
|Ime spremenljivke|Vrednost|Kaj je to?|
|--- | --- |---|
|TZ	| Europe/Berlin	|Časovni pas|
|POSTGRES_DB	| xwiki |To je ime zbirke podatkov.|
|POSTGRES_USER	| xwiki |Uporabniško ime zbirke podatkov wiki.|
|POSTGRES_PASSWORD	| xwiki |Geslo uporabnika zbirke podatkov wiki.|
{{</table>}}
Na koncu vnesem te štiri okoljske spremenljivke:Glej:
{{< gallery match="images/6/*.png" >}}
Po teh nastavitvah lahko zaženete strežnik Mariadb! Povsod pritisnem "Uporabi".
## Korak 3: Namestitev xWiki
V oknu Synology Docker kliknem na zavihek "Registracija" in poiščem "xwiki". Izberem sliko Docker "xwiki" in nato kliknem na oznako "10-postgres-tomcat".
{{< gallery match="images/7/*.png" >}}
Dvakrat kliknem na svojo sliko xwiki. Nato kliknem na "Napredne nastavitve" in aktiviram možnost "Samodejni ponovni zagon".
{{< gallery match="images/8/*.png" >}}
Za vsebnik "xwiki" dodelim fiksna vrata. Brez fiksnih vrat se lahko zgodi, da strežnik xwiki po ponovnem zagonu teče na drugih vratih.
{{< gallery match="images/9/*.png" >}}
Poleg tega je treba ustvariti povezavo do vsebnika "postgres". Kliknem na zavihek "Povezave" in izberem vsebnik zbirke podatkov. Ime vzdevka si je treba zapomniti za namestitev wikija.
{{< gallery match="images/10/*.png" >}}
{{<table "table table-striped table-bordered">}}
|Ime spremenljivke|Vrednost|Kaj je to?|
|--- | --- |---|
|TZ |	Europe/Berlin	|Časovni pas|
|DB_HOST	| db |Imena aliasov / povezava na zabojnik|
|DB_DATABASE	| xwiki	|Podatki iz koraka 2|
|DB_USER	| xwiki	|Podatki iz koraka 2|
|DB_PASSWORD	| xwiki |Podatki iz koraka 2|
{{</table>}}
Na koncu vnesem te okoljske spremenljivke: Glej:
{{< gallery match="images/11/*.png" >}}
Posodo lahko zaženete. Strežnik xWiki pokličem z naslovom IP strežnika Synology in pristaniščem zabojnika.
{{< gallery match="images/12/*.png" >}}