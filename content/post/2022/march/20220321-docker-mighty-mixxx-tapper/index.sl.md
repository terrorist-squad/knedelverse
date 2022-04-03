+++
date = "2022-03-21"
title = "Velike stvari z zabojniki: snemanje MP3-jev z radia"
difficulty = "level-1"
tags = ["diskstation", "Docker", "docker-compose", "docker-for-desktop", "radio", "mp3", "ripp", "streamripper", "radiorecorder"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2022/march/20220321-docker-mighty-mixxx-tapper/index.sl.md"
+++
Streamripper je orodje za ukazno vrstico, s katerim lahko snemate tokove MP3 ali OGG/Vorbis in jih shranite neposredno na trdi disk. Skladbe se samodejno poimenujejo po izvajalcu in shranijo posamično, format pa je tisti, ki je bil prvotno poslan (torej so ustvarjene datoteke s končnico .mp3 ali .ogg). Našel sem odličen vmesnik radiorecorderja in iz njega sestavil sliko Docker, glej: https://github.com/terrorist-squad/mightyMixxxTapper/
{{< gallery match="images/1/*.png" >}}

## Možnost za strokovnjake
Kot izkušen uporabnik Synologyja se lahko seveda prijavite s SSH in namestite celotno namestitev prek datoteke Docker Compose.
```
version: "2.0"
services:
  mealie:
    container_name: mighty-mixxx-tapper
    image: chrisknedel/mighty-mixxx-tapper:latest
    restart: always
    ports:
      - 9000:80
    environment:
      TZ: Europa/Berlin
    volumes:
      - ./ripps/:/tmp/ripps/

```

## Korak 1: Iskanje slike Docker
V oknu Synology Docker kliknem na zavihek "Registracija" in poiščem "mighty-mixxx-tapper". Izberem sliko Docker "chrisknedel/mighty-mixxx-tapper" in nato kliknem na oznako "latest".
{{< gallery match="images/2/*.png" >}}
Po prenosu slike je slika na voljo kot slika. Docker razlikuje med dvema stanjema, zabojnikom (dinamično stanje) in sliko/sliko (fiksno stanje). Preden lahko iz slike ustvarimo vsebnik, je treba opraviti nekaj nastavitev.
## Korak 2: Sliko uporabite v praksi:
Dvakrat kliknem na svojo sliko "mighty-mixxx-tapper".
{{< gallery match="images/3/*.png" >}}
Nato kliknem na "Napredne nastavitve" in aktiviram možnost "Samodejni ponovni zagon". Izberem zavihek "Zvezek" in kliknem na "Dodaj mapo". Tam ustvarim novo mapo s to potjo priklopa "/tmp/ripps/".
{{< gallery match="images/4/*.png" >}}
Za vsebnik "mighty-mixxx-tapper" dodelim fiksna vrata. Brez fiksnih vrat se lahko zgodi, da strežnik "mighty-mixxx-tapper-server" po ponovnem zagonu teče na drugih vratih.
{{< gallery match="images/5/*.png" >}}
Po teh nastavitvah lahko zaženete strežnik mighty-mixxx-tapper-server! Nato lahko pokličete mighty-mixxx-tapper prek naslova Ip naprave Synology in dodeljenih vrat, na primer http://192.168.21.23:8097.
{{< gallery match="images/6/*.png" >}}
