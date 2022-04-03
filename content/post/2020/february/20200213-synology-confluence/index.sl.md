+++
date = "2020-02-13"
title = "Synology-Nas: Confluence kot sistem wiki"
difficulty = "level-4"
tags = ["atlassian", "confluence", "Docker", "ds918", "Synology", "wiki", "nas"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2020/february/20200213-synology-confluence/index.sl.md"
+++
Če želite namestiti program Atlassian Confluence v napravo Synology NAS, ste prišli na pravo mesto.
## Korak 1
Najprej odprem aplikacijo Docker v vmesniku Synology in nato preidem na podpostavko "Registracija". Tam poiščem "Confluence" in kliknem na prvo sliko "Atlassian Confluence".
{{< gallery match="images/1/*.png" >}}

## Korak 2
Po prenosu slike je slika na voljo kot slika. Docker razlikuje med dvema stanjema, zabojnikom (dinamično stanje) in sliko/sliko (fiksno stanje). Preden lahko iz slike ustvarimo vsebnik, je treba opraviti nekaj nastavitev.
## Samodejni ponovni zagon
Dvakrat kliknem na sliko Confluence.
{{< gallery match="images/2/*.png" >}}
Nato kliknem na "Napredne nastavitve" in aktiviram možnost "Samodejni ponovni zagon".
{{< gallery match="images/3/*.png" >}}

## Pristanišča
Zabojniku Confluence dodelim fiksna vrata. Brez fiksnih vrat lahko Confluence po ponovnem zagonu deluje na drugih vratih.
{{< gallery match="images/4/*.png" >}}

## Spomin
Ustvarim fizično mapo in jo namestim v vsebnik (/var/atlassian/application-data/confluence/). Ta nastavitev olajša varnostno kopiranje in obnavljanje podatkov.
{{< gallery match="images/5/*.png" >}}
Po teh nastavitvah lahko zaženete Confluence!
{{< gallery match="images/6/*.png" >}}
