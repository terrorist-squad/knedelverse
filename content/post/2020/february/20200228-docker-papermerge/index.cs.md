+++
date = "2020-02-28"
title = "Velké věci s kontejnery: Spuštění Papermerge DMS na zařízení Synology NAS"
difficulty = "level-3"
tags = ["archiv", "automatisch", "dms", "Docker", "Document-Managment-System", "google", "ocr", "papermerge", "Synology", "tesseract", "texterkennung"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2020/february/20200228-docker-papermerge/index.cs.md"
+++
Papermerge je mladý systém správy dokumentů (DMS), který dokáže automaticky přiřazovat a zpracovávat dokumenty. V tomto návodu ukážu, jak jsem nainstaloval Papermerge na svou diskovou stanici Synology a jak funguje DMS.
## Možnost pro profesionály
Jako zkušený uživatel Synology se samozřejmě můžete přihlásit pomocí SSH a nainstalovat celou instalaci pomocí souboru Docker Compose.
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

## Krok 1: Vytvoření složky
Nejprve vytvořím složku pro sloučení papíru. Přejdu do "Ovládání systému" -> "Sdílená složka" a vytvořím novou složku s názvem "Archiv dokumentů".
{{< gallery match="images/1/*.png" >}}
Krok 2: Vyhledání obrazu DockerKliknu na kartu "Registrace" v okně Synology Docker a vyhledám "Papermerge". Vyberu obraz Docker "linuxserver/papermerge" a kliknu na značku "latest".
{{< gallery match="images/2/*.png" >}}
Po stažení obrázku je obrázek k dispozici jako obrázek. Docker rozlišuje 2 stavy, kontejner "dynamický stav" a obraz/image (pevný stav). Před vytvořením kontejneru z bitové kopie je třeba provést několik nastavení.
## Krok 3: Zprovoznění obrázku:
Dvakrát kliknu na obrázek sloučení papíru.
{{< gallery match="images/3/*.png" >}}
Pak kliknu na "Rozšířené nastavení" a aktivuji "Automatický restart". Vyberu kartu "Svazek" a kliknu na "Přidat složku". Tam vytvořím novou složku databáze s touto přípojnou cestou "/data".
{{< gallery match="images/4/*.png" >}}
Zde ukládám také druhou složku, kterou zahrnuji do přípojné cesty "/config". Nezáleží na tom, kde se tato složka nachází. Je však důležité, aby patřil uživateli Synology admin.
{{< gallery match="images/5/*.png" >}}
Pro kontejner "Papermerge" přiřadím pevné porty. Bez pevných portů by se mohlo stát, že "server Papermerge" po restartu poběží na jiném portu.
{{< gallery match="images/6/*.png" >}}
Nakonec zadám tři proměnné prostředí. Proměnná "PUID" je ID uživatele a "PGID" je ID skupiny mého uživatele správce. PGID/PUID můžete zjistit přes SSH příkazem "cat /etc/passwd | grep admin".
{{< gallery match="images/7/*.png" >}}
Po těchto nastaveních lze server Papermerge spustit! Poté lze aplikaci Papermerge zavolat prostřednictvím Ip adresy diskové stanice Synology a přiřazeného portu, například http://192.168.21.23:8095.
{{< gallery match="images/8/*.png" >}}
Výchozí přihlašovací jméno je admin s heslem admin.
## Jak Papermerge funguje?
Papermerge analyzuje text dokumentů a obrázků. Papermerge používá knihovnu OCR/"optického rozpoznávání znaků" s názvem tesseract, kterou vydala společnost Goolge.
{{< gallery match="images/9/*.png" >}}
Vytvořil jsem složku s názvem "Vše s Lorem", abych otestoval automatické přiřazování dokumentů. Poté jsem kliknul na nový rozpoznávací vzor v položce nabídky "Automaty".
{{< gallery match="images/10/*.png" >}}
Všechny nové dokumenty obsahující slovo "Lorem" jsou zařazeny do složky "Vše s Lorem" a označeny "has-lorem". Je důležité, abyste ve značkách používali čárku, jinak se značka nenastaví. Pokud nahrajete dokument, bude označen a seřazen.
{{< gallery match="images/11/*.png" >}}
