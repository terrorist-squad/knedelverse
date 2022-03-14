+++
date = "2021-04-18"
title = "Velké věci s kontejnery: Instalace vlastní dokuWiki na diskové stanici Synology"
difficulty = "level-2"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "dokuwiki", "wiki"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210418-docker-dokuWiki/index.cs.md"
+++
DokuWiki je standardům vyhovující, snadno použitelný a zároveň velmi univerzální open source wiki software. Dnes ukážu, jak nainstalovat službu DokuWiki na diskovou stanici Synology.
## Možnost pro profesionály
Jako zkušený uživatel Synology se samozřejmě můžete přihlásit pomocí SSH a nainstalovat celou instalaci pomocí souboru Docker Compose.
```
version: '3'
services:
  dokuwiki:
    image:  bitnami/dokuwiki:latest
    restart: always
    ports:
      - 8080:8080
      - 8443:8443
    environment:
      TZ: 'Europe/Berlin'
      DOKUWIKI_USERNAME: 'admin'
      DOKUWIKI_FULL_NAME: 'wiki'
      DOKUWIKI_PASSWORD: 'password'
    volumes:
      - ./data:/bitnami/dokuwiki

```
Další užitečné obrazy Docker pro domácí použití najdete v [Dockerverse]({{< ref "dockerverse" >}} "Dockerverse").
## Krok 1: Příprava složky wiki
V adresáři Docker vytvořím nový adresář s názvem "wiki".
{{< gallery match="images/1/*.png" >}}

## Krok 2: Instalace DokuWiki
Poté je třeba vytvořit databázi. V okně Synology Docker kliknu na kartu "Registrace" a vyhledám "dokuwiki". Vyberu obraz Docker "bitnami/dokuwiki" a kliknu na značku "latest".
{{< gallery match="images/2/*.png" >}}
Po stažení obrázku je obrázek k dispozici jako obrázek. Docker rozlišuje 2 stavy, kontejner "dynamický stav" a image (pevný stav). Než z obrazu vytvoříme kontejner, je třeba provést několik nastavení. Poklepu na svůj obraz dokuwiki.
{{< gallery match="images/3/*.png" >}}
Pro kontejner "dokuwiki" přiřadím pevné porty. Bez pevných portů by se mohlo stát, že "dokuwiki server" po restartu poběží na jiném portu.
{{< gallery match="images/4/*.png" >}}
{{<table "table table-striped table-bordered">}}
|Název proměnné|Hodnota|Co to je?|
|--- | --- |---|
|TZ	| Europe/Berlin	|Časové pásmo|
|DOKUWIKI_USERNAME	| admin|Uživatelské jméno správce|
|DOKUWIKI_FULL_NAME |	wiki	|Název WIki|
|DOKUWIKI_PASSWORD	| password	|Heslo správce|
{{</table>}}
Nakonec zadám tyto proměnné prostředí:Viz:
{{< gallery match="images/5/*.png" >}}
Nyní lze kontejner spustit. Zavolám server dokuWIki s IP adresou Synology a portem kontejneru.
{{< gallery match="images/6/*.png" >}}
