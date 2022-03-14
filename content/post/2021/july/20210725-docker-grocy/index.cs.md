+++
date = "2021-07-25"
title = "Skvělé věci s kontejnery: správa lednice s Grocy"
difficulty = "level-1"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "kühlschrank", "erp", "mhd", "Speispläne", "cms", "Cafe", "Bistro"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/july/20210725-docker-grocy/index.cs.md"
+++
Pomocí Grocy můžete spravovat celou domácnost, restauraci, kavárnu, bistro nebo potravinový trh. Můžete spravovat ledničky, jídelníčky, úkoly, nákupní seznamy a data trvanlivosti potravin.
{{< gallery match="images/1/*.png" >}}
Dnes ukážu, jak nainstalovat službu Grocy na diskovou stanici Synology.
## Možnost pro profesionály
Jako zkušený uživatel Synology se samozřejmě můžete přihlásit pomocí SSH a nainstalovat celou instalaci pomocí souboru Docker Compose.
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
Další užitečné obrazy Docker pro domácí použití najdete v [Dockerverse]({{< ref "dockerverse" >}} "Dockerverse").
## Krok 1: Příprava složky Grocy
V adresáři Docker vytvořím nový adresář s názvem "grocy".
{{< gallery match="images/2/*.png" >}}

## Krok 2: Instalace Grocy
V okně Synology Docker kliknu na kartu "Registrace" a vyhledám položku "Grocy". Vyberu obraz Docker "linuxserver/grocy:latest" a kliknu na značku "latest".
{{< gallery match="images/3/*.png" >}}
Dvakrát kliknu na obrázek Grocyho.
{{< gallery match="images/4/*.png" >}}
Pak kliknu na "Rozšířené nastavení" a aktivuji zde také "Automatický restart". Vyberu kartu "Svazek" a kliknu na "Přidat složku". Tam vytvořím novou složku s touto přípojnou cestou "/config".
{{< gallery match="images/5/*.png" >}}
Pro kontejner "Grocy" přiřadím pevné porty. Bez pevných portů by se mohlo stát, že "Grocy server" po restartu poběží na jiném portu.
{{< gallery match="images/6/*.png" >}}
{{<table "table table-striped table-bordered">}}
|Název proměnné|Hodnota|Co to je?|
|--- | --- |---|
|TZ | Europe/Berlin |Časové pásmo|
|PUID | 1024 |ID uživatele od uživatele Synology Admin|
|PGID |	100 |ID skupiny od uživatele Synology Admin|
{{</table>}}
Nakonec zadám tyto proměnné prostředí:Viz:
{{< gallery match="images/7/*.png" >}}
Nyní lze kontejner spustit. Vyvolám server Grocy s IP adresou Synology a portem kontejneru a přihlásím se pomocí uživatelského jména "admin" a hesla "admin".
{{< gallery match="images/8/*.png" >}}
