+++
date = "2022-03-21"
title = "Veľké veci s kontajnermi: Nahrávanie MP3 z rádia"
difficulty = "level-1"
tags = ["diskstation", "Docker", "docker-compose", "docker-for-desktop", "radio", "mp3", "ripp", "streamripper", "radiorecorder"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2022/march/20220321-docker-mighty-mixxx-tapper/index.sk.md"
+++
Streamripper je nástroj pre príkazový riadok, ktorý možno použiť na nahrávanie prúdov MP3 alebo OGG/Vorbis a ich ukladanie priamo na pevný disk. Skladby sa automaticky pomenujú podľa interpreta a uložia sa jednotlivo, pričom formát je ten, ktorý bol pôvodne odoslaný (takže sa v skutočnosti vytvoria súbory s príponou .mp3 alebo .ogg). Našiel som skvelé rozhranie radiorecorder a vytvoril som z neho obraz Docker, pozri: https://github.com/terrorist-squad/mightyMixxxTapper/
{{< gallery match="images/1/*.png" >}}

## Možnosť pre profesionálov
Ako skúsený používateľ Synology sa môžete samozrejme prihlásiť pomocou SSH a nainštalovať celú inštaláciu prostredníctvom súboru Docker Compose.
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

## Krok 1: Vyhľadanie obrazu aplikácie Docker
Kliknem na kartu "Registrácia" v okne Synology Docker a vyhľadám "mighty-mixxx-tapper". Vyberiem obraz Docker "chrisknedel/mighty-mixxx-tapper" a potom kliknem na značku "latest".
{{< gallery match="images/2/*.png" >}}
Po stiahnutí obrázka je obrázok k dispozícii ako obrázok. Docker rozlišuje 2 stavy, kontajner "dynamický stav" a obraz/image (pevný stav). Pred vytvorením kontajnera z obrazu je potrebné vykonať niekoľko nastavení.
## Krok 2: Uvedenie obrazu do prevádzky:
Dvakrát kliknem na svoj obrázok "mighty-mixxx-tapper".
{{< gallery match="images/3/*.png" >}}
Potom kliknem na "Rozšírené nastavenia" a aktivujem "Automatický reštart". Vyberiem kartu "Zväzok" a kliknem na "Pridať priečinok". Tam vytvorím nový priečinok s touto prípojnou cestou "/tmp/ripps/".
{{< gallery match="images/4/*.png" >}}
Pre kontajner "mighty-mixxx-tapper" priraďujem pevné porty. Bez pevných portov by sa mohlo stať, že "mighty-mixxx-tapper-server" po reštarte beží na inom porte.
{{< gallery match="images/5/*.png" >}}
Po týchto nastaveniach je možné spustiť mighty-mixxx-tapper-server! Potom môžete zavolať mighty-mixxx-tapper prostredníctvom Ip adresy dislokácie Synology a priradeného portu, napríklad http://192.168.21.23:8097.
{{< gallery match="images/6/*.png" >}}