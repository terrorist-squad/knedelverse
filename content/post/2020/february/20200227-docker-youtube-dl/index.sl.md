+++
date = "2020-02-27"
title = "Velike stvari z zabojniki: Zagon programa za prenos datotek Youtube na strežniku Synology Diskstation"
difficulty = "level-1"
tags = ["Docker", "docker-compose", "download", "linux", "Synology", "video", "youtube"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2020/february/20200227-docker-youtube-dl/index.sl.md"
+++
Mnogi moji prijatelji vedo, da na svojem portalu Homelab - Network vodim zasebni učni video portal. Video tečaje iz preteklih članstev v učnih portalih in dobre vaje iz YouTuba imam shranjene za uporabo brez povezave na svojem strežniku NAS.
{{< gallery match="images/1/*.png" >}}
Sčasoma sem zbral 8845 video tečajev z 282616 posameznimi videoposnetki. Skupni čas delovanja je približno 2 leti. Popolnoma noro! V tem vodniku prikazujem, kako lahko s storitvijo Docker za prenos v načinu brez povezave naredite varnostno kopijo dobrih učnih gradiv iz YouTuba.
## Možnost za strokovnjake
Kot izkušen uporabnik Synologyja se lahko seveda prijavite s SSH in namestite celotno namestitev prek datoteke Docker Compose.
```
version: "2"
services:
  youtube-dl:
    image: modenaf360/youtube-dl-nas
    container_name: youtube-dl
    environment:
      - MY_ID=admin
      - MY_PW=admin
    volumes:
      - ./YouTube:/downfolder
    ports:
      - 8080:8080
    restart: unless-stopped

```

## Korak 1
Najprej ustvarim mapo za prenose. Grem v "Nadzor sistema" -> "Skupna mapa" in ustvarim novo mapo z imenom "Prenosi".
{{< gallery match="images/2/*.png" >}}

## Korak 2: Iskanje slike Docker
V oknu Synology Docker kliknem na zavihek "Registracija" in poiščem "youtube-dl-nas". Izberem sliko Docker "modenaf360/youtube-dl-nas" in nato kliknem na oznako "latest".
{{< gallery match="images/3/*.png" >}}
Po prenosu slike je slika na voljo kot slika. Docker razlikuje med dvema stanjema, zabojnikom (dinamično stanje) in sliko/sliko (fiksno stanje). Preden lahko iz slike ustvarimo vsebnik, je treba opraviti nekaj nastavitev.
## Korak 3: Sliko uporabite v praksi:
Dvakrat kliknem na svojo sliko youtube-dl-nas.
{{< gallery match="images/4/*.png" >}}
Nato kliknem na "Napredne nastavitve" in aktiviram možnost "Samodejni ponovni zagon". Izberem zavihek "Obseg" in kliknem na "Dodaj mapo". Tam ustvarim novo mapo zbirke podatkov s to potjo priklopa "/downfolder".
{{< gallery match="images/5/*.png" >}}
Za vsebnik "Youtube Downloader" dodelim fiksna vrata. Brez fiksnih vrat je mogoče, da se program "Youtube Downloader" po ponovnem zagonu zažene na drugih vratih.
{{< gallery match="images/6/*.png" >}}
Na koncu vnesem dve okoljski spremenljivki. Spremenljivka "MY_ID" je moje uporabniško ime, spremenljivka "MY_PW" pa je moje geslo.
{{< gallery match="images/7/*.png" >}}
Po teh nastavitvah lahko zaženete Downloader! Nato lahko pokličete prenosnik prek naslova IP dislokacije Synology in dodeljenih vrat, na primer http://192.168.21.23:8070 .
{{< gallery match="images/8/*.png" >}}
Za preverjanje pristnosti vzemite uporabniško ime in geslo iz MY_ID in MY_PW.
## Korak 4: Gremo
Zdaj lahko v polje "URL" vnesete naslove videoposnetkov Youtube in naslove seznamov predvajanja, vsi videoposnetki pa se samodejno znajdejo v mapi za prenos na diskovni postaji Synology.
{{< gallery match="images/9/*.png" >}}
Prenos mape:
{{< gallery match="images/10/*.png" >}}