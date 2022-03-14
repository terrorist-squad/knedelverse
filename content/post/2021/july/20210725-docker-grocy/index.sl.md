+++
date = "2021-07-25"
title = "Velike stvari z zabojniki: upravljanje hladilnika z Grocyjem"
difficulty = "level-1"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "kühlschrank", "erp", "mhd", "Speispläne", "cms", "Cafe", "Bistro"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/july/20210725-docker-grocy/index.sl.md"
+++
Z Grocyjem lahko upravljate celotno gospodinjstvo, restavracijo, kavarno, bistro ali živilsko tržnico. Upravljate lahko hladilnike, menije, opravila, nakupovalne sezname in rok trajanja živil.
{{< gallery match="images/1/*.png" >}}
Danes bom pokazal, kako namestiti storitev Grocy na diskovno postajo Synology.
## Možnost za strokovnjake
Kot izkušen uporabnik Synologyja se lahko seveda prijavite s SSH in namestite celotno namestitev prek datoteke Docker Compose.
```
version: "2.1"
services:
  grocy:
    image: ghcr.io/linuxserver/grocy
    container_name: grocy
    environment:
      - PUID=1024
      - PGID=100
      - TZ=Europe/Berlin
    volumes:
      - ./data:/config
    ports:
      - 9283:80
    restart: unless-stopped

```
Več uporabnih slik Docker za domačo uporabo najdete v [Dockerverse]({{< ref "dockerverse" >}} "Dockerverse").
## Korak 1: Pripravite mapo Grocy
V imeniku programa Docker ustvarim nov imenik z imenom "grocy".
{{< gallery match="images/2/*.png" >}}

## Korak 2: Namestitev Grocyja
V oknu Synology Docker kliknem na zavihek "Registracija" in poiščem "Grocy". Izberem sliko Docker "linuxserver/grocy:latest" in nato kliknem na oznako "latest".
{{< gallery match="images/3/*.png" >}}
Dvakrat kliknem na sliko Grocy.
{{< gallery match="images/4/*.png" >}}
Nato kliknem na "Napredne nastavitve" in aktiviram možnost "Samodejni ponovni zagon". Izberem zavihek "Zvezek" in kliknem na "Dodaj mapo". Tam ustvarim novo mapo s to potjo "/config".
{{< gallery match="images/5/*.png" >}}
Zabojniku Grocy dodelim fiksna vrata. Brez fiksnih vrat se lahko zgodi, da strežnik Grocy po ponovnem zagonu deluje na drugih vratih.
{{< gallery match="images/6/*.png" >}}
{{<table "table table-striped table-bordered">}}
|Ime spremenljivke|Vrednost|Kaj je to?|
|--- | --- |---|
|TZ | Europe/Berlin |Časovni pas|
|PUID | 1024 |ID uporabnika iz Synology Admin User|
|PGID |	100 |ID skupine iz uporabnika Synology Admin|
{{</table>}}
Na koncu vnesem te okoljske spremenljivke: Glej:
{{< gallery match="images/7/*.png" >}}
Posodo lahko zaženete. Pokličem strežnik Grocy z naslovom IP strežnika Synology in pristaniščem za zabojnik ter se prijavim z uporabniškim imenom "admin" in geslom "admin".
{{< gallery match="images/8/*.png" >}}
