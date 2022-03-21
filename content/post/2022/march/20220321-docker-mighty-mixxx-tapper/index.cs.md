+++
date = "2022-03-21"
title = "Velké věci s kontejnery: Nahrávání MP3 z rádia"
difficulty = "level-1"
tags = ["diskstation", "Docker", "docker-compose", "docker-for-desktop", "radio", "mp3", "ripp", "streamripper", "radiorecorder"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2022/march/20220321-docker-mighty-mixxx-tapper/index.cs.md"
+++
Streamripper je nástroj pro příkazový řádek, který lze použít k nahrávání datových toků MP3 nebo OGG/Vorbis a jejich ukládání přímo na pevný disk. Skladby jsou automaticky pojmenovány podle interpreta a uloženy jednotlivě, formát je ten, který byl původně odeslán (takže jsou ve skutečnosti vytvořeny soubory s příponou .mp3 nebo .ogg). Našel jsem skvělé rozhraní radiorecorderu a vytvořil z něj obraz Dockeru, viz: https://github.com/terrorist-squad/mightyMixxxTapper/.
{{< gallery match="images/1/*.png" >}}

## Možnost pro profesionály
Jako zkušený uživatel Synology se samozřejmě můžete přihlásit pomocí SSH a nainstalovat celou instalaci pomocí souboru Docker Compose.
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

## Krok 1: Vyhledání bitové kopie nástroje Docker
V okně Synology Docker kliknu na kartu "Registrace" a vyhledám "mighty-mixxx-tapper". Vyberu obraz Docker "chrisknedel/mighty-mixxx-tapper" a kliknu na značku "latest".
{{< gallery match="images/2/*.png" >}}
Po stažení obrázku je obrázek k dispozici jako obrázek. Docker rozlišuje 2 stavy, kontejner "dynamický stav" a obraz/image (pevný stav). Před vytvořením kontejneru z bitové kopie je třeba provést několik nastavení.
## Krok 2: Zprovozněte obrázek:
Dvakrát kliknu na svůj obrázek "mighty-mixxx-tapper".
{{< gallery match="images/3/*.png" >}}
Pak kliknu na "Rozšířená nastavení" a aktivuji "Automatický restart". Vyberu kartu "Svazek" a kliknu na "Přidat složku". Tam vytvořím novou složku s touto přípojnou cestou "/tmp/ripps/".
{{< gallery match="images/4/*.png" >}}
Pro kontejner "mighty-mixxx-tapper" přiřadím pevné porty. Bez pevných portů by se mohlo stát, že "mighty-mixxx-tapper-server" po restartu poběží na jiném portu.
{{< gallery match="images/5/*.png" >}}
Po těchto nastaveních lze spustit mighty-mixxx-tapper-server! Poté můžete zavolat mighty-mixxx-tapper prostřednictvím Ip adresy stanice Synology a přiřazeného portu, například http://192.168.21.23:8097.
{{< gallery match="images/6/*.png" >}}