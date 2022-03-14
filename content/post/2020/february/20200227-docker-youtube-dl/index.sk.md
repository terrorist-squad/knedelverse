+++
date = "2020-02-27"
title = "Veľké veci s kontajnermi: Spustenie sťahovača Youtube na stanici Synology Diskstation"
difficulty = "level-1"
tags = ["Docker", "docker-compose", "download", "linux", "Synology", "video", "youtube"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2020/february/20200227-docker-youtube-dl/index.sk.md"
+++
Mnohí z mojich priateľov vedia, že prevádzkujem súkromný vzdelávací videoportál Homelab - Network. Videokurzy z minulých členstiev na vzdelávacích portáloch a dobré výukové programy z portálu Youtube som si uložil na použitie offline na svojom NAS.
{{< gallery match="images/1/*.png" >}}
Časom som zhromaždil 8845 videokurzov s 282616 jednotlivými videami. Celkový čas prevádzky je približne 2 roky. V tomto návode ukážem, ako zálohovať dobré výukové programy Youtube pomocou služby Docker na sťahovanie v režime offline.
## Možnosť pre profesionálov
Ako skúsený používateľ Synology sa môžete samozrejme prihlásiť pomocou SSH a nainštalovať celú inštaláciu prostredníctvom súboru Docker Compose.
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

## Krok 1
Najprv vytvorím priečinok na stiahnuté súbory. Prejdem do "Ovládanie systému" -> "Zdieľaný priečinok" a vytvorím nový priečinok s názvom "Stiahnuté súbory".
{{< gallery match="images/2/*.png" >}}

## Krok 2: Vyhľadanie obrazu aplikácie Docker
Kliknem na kartu "Registrácia" v okne Synology Docker a vyhľadám "youtube-dl-nas". Vyberiem obraz Docker "modenaf360/youtube-dl-nas" a potom kliknem na značku "latest".
{{< gallery match="images/3/*.png" >}}
Po stiahnutí obrázka je obrázok k dispozícii ako obrázok. Docker rozlišuje 2 stavy, kontajner "dynamický stav" a obraz/image (pevný stav). Pred vytvorením kontajnera z obrazu je potrebné vykonať niekoľko nastavení.
## Krok 3: Uvedenie obrazu do prevádzky:
Dvakrát kliknem na svoj obrázok z youtube-dl-nas.
{{< gallery match="images/4/*.png" >}}
Potom kliknem na "Rozšírené nastavenia" a aktivujem "Automatický reštart". Vyberiem kartu "Volume" a kliknem na "Add folder". Tam vytvorím nový priečinok databázy s touto prípojnou cestou "/downfolder".
{{< gallery match="images/5/*.png" >}}
Pre kontajner "Youtube Downloader" priraďujem pevné porty. Bez pevných portov by sa mohlo stať, že program "Youtube Downloader" sa po reštarte spustí na inom porte.
{{< gallery match="images/6/*.png" >}}
Nakoniec zadám dve premenné prostredia. Premenná "MY_ID" je moje používateľské meno a "MY_PW" je moje heslo.
{{< gallery match="images/7/*.png" >}}
Po týchto nastaveniach je možné Downloader spustiť! Potom môžete sťahovač zavolať prostredníctvom Ip adresy zariadenia Synology a priradeného portu, napríklad http://192.168.21.23:8070 .
{{< gallery match="images/8/*.png" >}}
Na overenie použite používateľské meno a heslo z položiek MY_ID a MY_PW.
## Krok 4: Ideme
Teraz môžete do poľa "URL" zadať URL adresy videí a zoznamov skladieb a všetky videá sa automaticky dostanú do priečinka na prevzatie na diskovej stanici Synology.
{{< gallery match="images/9/*.png" >}}
Priečinok na stiahnutie:
{{< gallery match="images/10/*.png" >}}