+++
date = "2020-02-28"
title = "Velike stvari s posodami: Zagon sistema Papermerge DMS na strežniku Synology NAS"
difficulty = "level-3"
tags = ["archiv", "automatisch", "dms", "Docker", "Document-Managment-System", "google", "ocr", "papermerge", "Synology", "tesseract", "texterkennung"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2020/february/20200228-docker-papermerge/index.sl.md"
+++
Papermerge je mladi sistem za upravljanje dokumentov (DMS), ki lahko samodejno dodeljuje in obdeluje dokumente. V tem vodniku prikazujem, kako sem namestil Papermerge na svojo diskovno postajo Synology in kako deluje DMS.
## Možnost za strokovnjake
Kot izkušen uporabnik Synologyja se lahko seveda prijavite s SSH in namestite celotno namestitev prek datoteke Docker Compose.
```
version: "2.1"
services:
  papermerge:
    image: ghcr.io/linuxserver/papermerge
    container_name: papermerge
    environment:
      - PUID=1024
      - PGID=100
      - TZ=Europe/Berlin
    volumes:
      - ./config>:/config
      - ./appdata/data>:/data
    ports:
      - 8090:8000
    restart: unless-stopped

```

## Korak 1: Ustvarite mapo
Najprej ustvarim mapo za združitev papirja. Grem v "Nadzor sistema" -> "Skupna mapa" in ustvarim novo mapo z imenom "Arhiv dokumentov".
{{< gallery match="images/1/*.png" >}}
Korak 2: Iskanje slike DockerKliknem na zavihek "Registracija" v oknu Synology Docker in poiščem "Papermerge". Izberem sliko Docker "linuxserver/papermerge" in nato kliknem na oznako "latest".
{{< gallery match="images/2/*.png" >}}
Po prenosu slike je slika na voljo kot slika. Docker razlikuje med dvema stanjema, zabojnikom (dinamično stanje) in sliko/sliko (fiksno stanje). Preden lahko iz slike ustvarimo vsebnik, je treba opraviti nekaj nastavitev.
## Korak 3: Sliko uporabite v praksi:
Dvakrat kliknem na sliko za združevanje papirja.
{{< gallery match="images/3/*.png" >}}
Nato kliknem na "Napredne nastavitve" in aktiviram možnost "Samodejni ponovni zagon". Izberem zavihek "Obseg" in kliknem na "Dodaj mapo". Tam ustvarim novo mapo zbirke podatkov s to potjo priklopa "/data".
{{< gallery match="images/4/*.png" >}}
Tu shranim tudi drugo mapo, ki jo vključim v pot za priklop "/config". Ni pomembno, kje je ta mapa. Vendar je pomembno, da pripada uporabniku Synology admin.
{{< gallery match="images/5/*.png" >}}
Zabojniku "Papermerge" dodelim fiksna vrata. Brez fiksnih vrat bi se lahko zgodilo, da bi "strežnik Papermerge" po ponovnem zagonu deloval na drugih vratih.
{{< gallery match="images/6/*.png" >}}
Na koncu vnesem tri okoljske spremenljivke. Spremenljivka "PUID" je ID uporabnika, spremenljivka "PGID" pa je ID skupine mojega uporabnika administratorja. PGID/PUID lahko prek SSH ugotovite z ukazom "cat /etc/passwd | grep admin".
{{< gallery match="images/7/*.png" >}}
Po teh nastavitvah lahko zaženete strežnik Papermerge! Nato lahko program Papermerge pokličete prek naslova Ip naprave Synology in dodeljenih vrat, na primer http://192.168.21.23:8095.
{{< gallery match="images/8/*.png" >}}
Privzeta prijava je admin z geslom admin.
## Kako deluje Papermerge?
Papermerge analizira besedilo dokumentov in slik. Papermerge uporablja knjižnico OCR/"optičnega prepoznavanja znakov", imenovano tesseract, ki jo je objavil Goolge.
{{< gallery match="images/9/*.png" >}}
Ustvaril sem mapo z imenom "Vse z Loremom", da bi preizkusil samodejno dodeljevanje dokumentov. Nato sem v meniju "Avtomatizira" kliknil nov vzorec prepoznavanja.
{{< gallery match="images/10/*.png" >}}
Vsi novi dokumenti, ki vsebujejo besedo "Lorem", so nameščeni v mapo "Vse z Lorem" in označeni z "has-lorem". Pomembno je, da v oznakah uporabite vejico, sicer se oznaka ne bo nastavila. Če naložite dokument, bo označen in razvrščen.
{{< gallery match="images/11/*.png" >}}
