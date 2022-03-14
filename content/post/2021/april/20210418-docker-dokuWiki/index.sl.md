+++
date = "2021-04-18"
title = "Velike stvari s posodami: namestitev lastnega dokuWiki na diskovno postajo Synology"
difficulty = "level-2"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "dokuwiki", "wiki"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/april/20210418-docker-dokuWiki/index.sl.md"
+++
DokuWiki je s standardi skladna, enostavna za uporabo in hkrati izjemno vsestranska odprtokodna programska oprema wiki. Danes bom pokazal, kako namestiti storitev DokuWiki na diskovno postajo Synology.
## Možnost za strokovnjake
Kot izkušen uporabnik Synologyja se lahko seveda prijavite s SSH in namestite celotno namestitev prek datoteke Docker Compose.
```
version: '3'
services:
  dokuwiki:
    image:  bitnami/dokuwiki:latest
    restart: always
    ports:
      - 8080:8080
      - 8443:8443
    environment:
      TZ: 'Europe/Berlin'
      DOKUWIKI_USERNAME: 'admin'
      DOKUWIKI_FULL_NAME: 'wiki'
      DOKUWIKI_PASSWORD: 'password'
    volumes:
      - ./data:/bitnami/dokuwiki

```
Več uporabnih slik Docker za domačo uporabo najdete v [Dockerverse]({{< ref "dockerverse" >}} "Dockerverse").
## Korak 1: Pripravite mapo wiki
V imeniku programa Docker ustvarim nov imenik z imenom "wiki".
{{< gallery match="images/1/*.png" >}}

## Korak 2: Namestite DokuWiki
Nato je treba ustvariti zbirko podatkov. V oknu Synology Docker kliknem na zavihek "Registracija" in poiščem "dokuwiki". Izberem sliko Docker "bitnami/dokuwiki" in nato kliknem na oznako "latest".
{{< gallery match="images/2/*.png" >}}
Po prenosu slike je slika na voljo kot slika. Docker razlikuje med dvema stanjema, zabojnikom (dinamično stanje) in sliko (fiksno stanje). Preden iz slike ustvarimo vsebnik, je treba opraviti nekaj nastavitev. Dvakrat kliknem na svojo sliko dokuwiki.
{{< gallery match="images/3/*.png" >}}
Za vsebnik "dokuwiki" dodelim fiksna vrata. Brez fiksnih vrat se lahko zgodi, da strežnik dokuwiki po ponovnem zagonu teče na drugih vratih.
{{< gallery match="images/4/*.png" >}}
{{<table "table table-striped table-bordered">}}
|Ime spremenljivke|Vrednost|Kaj je to?|
|--- | --- |---|
|TZ	| Europe/Berlin	|Časovni pas|
|DOKUWIKI_USERNAME	| admin|Uporabniško ime administratorja|
|DOKUWIKI_FULL_NAME |	wiki	|Ime WIki|
|DOKUWIKI_PASSWORD	| password	|Administratorsko geslo|
{{</table>}}
Na koncu vnesem te okoljske spremenljivke: Glej:
{{< gallery match="images/5/*.png" >}}
Posodo lahko zaženete. Strežnik dokuWIki pokličem z naslovom IP strežnika Synology in pristaniščem zabojnika.
{{< gallery match="images/6/*.png" >}}
