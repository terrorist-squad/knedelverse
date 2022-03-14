+++
date = "2020-02-27"
title = "Skvělé věci s kontejnery: Spuštění downloaderu Youtube na stanici Synology Diskstation"
difficulty = "level-1"
tags = ["Docker", "docker-compose", "download", "linux", "Synology", "video", "youtube"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2020/february/20200227-docker-youtube-dl/index.cs.md"
+++
Mnozí z mých přátel vědí, že na svém portálu Homelab - Network provozuji soukromý výukový videoportál. Videokurzy z minulých členství na vzdělávacích portálech a dobré výukové programy z Youtube jsem si uložil pro offline použití na svém NAS.
{{< gallery match="images/1/*.png" >}}
Postupně jsem shromáždil 8845 videokurzů s 282616 jednotlivými videi. Celková doba provozu činí přibližně 2 roky. Naprosto bláznivé! V tomto návodu ukážu, jak zálohovat dobré výukové programy z Youtube pomocí služby Docker pro stahování v režimu offline.
## Možnost pro profesionály
Jako zkušený uživatel Synology se samozřejmě můžete přihlásit pomocí SSH a nainstalovat celou instalaci pomocí souboru Docker Compose.
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
Nejprve vytvořím složku pro stahování. Přejdu do "Ovládání systému" -> "Sdílená složka" a vytvořím novou složku s názvem "Stažené soubory".
{{< gallery match="images/2/*.png" >}}

## Krok 2: Vyhledání obrazu nástroje Docker
V okně Synology Docker kliknu na kartu "Registrace" a vyhledám "youtube-dl-nas". Vyberu obraz Docker "modenaf360/youtube-dl-nas" a kliknu na značku "latest".
{{< gallery match="images/3/*.png" >}}
Po stažení obrázku je obrázek k dispozici jako obrázek. Docker rozlišuje 2 stavy, kontejner "dynamický stav" a obraz/image (pevný stav). Před vytvořením kontejneru z bitové kopie je třeba provést několik nastavení.
## Krok 3: Zprovozněte obrázek:
Dvakrát kliknu na svůj obrázek na youtube-dl-nas.
{{< gallery match="images/4/*.png" >}}
Pak kliknu na "Rozšířené nastavení" a aktivuji "Automatický restart". Vyberu kartu "Svazek" a kliknu na "Přidat složku". Tam vytvořím novou složku databáze s touto přípojnou cestou "/downfolder".
{{< gallery match="images/5/*.png" >}}
Pro kontejner "Youtube Downloader" přiřadím pevné porty. Bez pevných portů by se mohlo stát, že "Youtube Downloader" po restartu poběží na jiném portu.
{{< gallery match="images/6/*.png" >}}
Nakonec zadám dvě proměnné prostředí. Proměnná "MY_ID" je moje uživatelské jméno a "MY_PW" je moje heslo.
{{< gallery match="images/7/*.png" >}}
Po těchto nastaveních lze Downloader spustit! Poté můžete zavolat stahovač prostřednictvím Ip adresy zařízení Synology a přiřazeného portu, například http://192.168.21.23:8070 .
{{< gallery match="images/8/*.png" >}}
Pro ověření převezměte uživatelské jméno a heslo z položek MY_ID a MY_PW.
## Krok 4: Jdeme na to
Nyní lze do pole "URL" zadat adresy URL videí a seznamů skladeb a všechna videa automaticky skončí ve složce pro stahování na diskové stanici Synology.
{{< gallery match="images/9/*.png" >}}
Složka ke stažení:
{{< gallery match="images/10/*.png" >}}