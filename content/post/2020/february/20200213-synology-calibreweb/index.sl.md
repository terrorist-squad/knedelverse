+++
date = "2020-02-13"
title = "Synology-Nas: Namestite Calibre Web kot knjižnico e-knjig"
difficulty = "level-1"
tags = ["calbre-web", "calibre", "Docker", "ds918", "ebook", "epub", "nas", "pdf", "Synology"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2020/february/20200213-synology-calibreweb/index.sl.md"
+++
Kako lahko namestim Calibre-Web kot vsebnik Docker na svoj Synology NAS? Pozor: Ta način namestitve je zastarel in ni združljiv s trenutno programsko opremo Calibre. Oglejte si to novo navodilo:[Velike stvari s posodami: Zagon programa Calibre s programom Docker Compose]({{< ref "post/2020/february/20200221-docker-Calibre-pro" >}} "Velike stvari s posodami: Zagon programa Calibre s programom Docker Compose"). Ta vadnica je namenjena vsem strokovnjakom za Synology DS.
## Korak 1: Ustvarite mapo
Najprej ustvarim mapo za knjižnico Calibre.  Prikličem "Nadzor sistema" -> "Skupna mapa" in ustvarim novo mapo "Knjige".
{{< gallery match="images/1/*.png" >}}

##  Korak 2: Ustvarite knjižnico Calibre
Zdaj kopiram obstoječo knjižnico ali "[ta prazna knjižnica vzorca](https://drive.google.com/file/d/1zfeU7Jh3FO_jFlWSuZcZQfQOGD0NvXBm/view)" v novi imenik. Sam sem kopiral obstoječo knjižnico namizne aplikacije.
{{< gallery match="images/2/*.png" >}}

## Korak 3: Iskanje slike Docker
V oknu Synology Docker kliknem na zavihek "Registracija" in poiščem "Calibre". Izberem sliko Docker "janeczku/calibre-web" in nato kliknem na oznako "latest".
{{< gallery match="images/3/*.png" >}}
Po prenosu slike je slika na voljo kot slika. Docker razlikuje med dvema stanjema, zabojnikom (dinamično stanje) in sliko/sliko (fiksno stanje). Preden lahko iz slike ustvarimo vsebnik, je treba opraviti nekaj nastavitev.
## Korak 4: Sliko uporabite:
Dvakrat kliknem na svojo sliko v Calibre.
{{< gallery match="images/4/*.png" >}}
Nato kliknem na "Napredne nastavitve" in aktiviram možnost "Samodejni ponovni zagon". Izberem zavihek "Zvezek" in kliknem na "Dodaj mapo". Tam ustvarim novo mapo zbirke podatkov s to potjo priklopa "/calibre".
{{< gallery match="images/5/*.png" >}}
Zabojniku Calibre dodelim fiksna vrata. Brez fiksnih vrat se lahko zgodi, da se Calibre po ponovnem zagonu zažene na drugih vratih.
{{< gallery match="images/6/*.png" >}}
Po teh nastavitvah lahko zaženete Calibre!
{{< gallery match="images/7/*.png" >}}
Zdaj prikličem svoj Synology IP z dodeljenimi Calibre pristanišči in vidim naslednjo sliko. Vnesem "/calibre" kot "Location of Calibre Database". Ostale nastavitve so stvar okusa.
{{< gallery match="images/8/*.png" >}}
Privzeta prijava je "admin" z geslom "admin123".
{{< gallery match="images/9/*.png" >}}
Končano! Seveda lahko zdaj namizno aplikacijo povežem tudi prek mape s knjigami. V aplikaciji zamenjam knjižnico in nato izberem mapo Nas.
{{< gallery match="images/10/*.png" >}}
Nekako takole:
{{< gallery match="images/11/*.png" >}}
Če zdaj urejam metainfo v namizni aplikaciji, se samodejno posodobijo tudi v spletni aplikaciji.
{{< gallery match="images/12/*.png" >}}