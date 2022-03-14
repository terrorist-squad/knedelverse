+++
date = "2021-03-07"
title = "Skvělé věci s kontejnery: správa a archivace receptů na zařízení Synology DiskStation"
difficulty = "level-1"
tags = ["diskstation", "Docker", "docker-compose", "docker-for-desktop", "rezepte", "speisen", "Synology"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/march/20210307-docker-mealie/index.cs.md"
+++
Shromážděte všechny své oblíbené recepty v kontejneru Docker a uspořádejte je podle svých představ. Napište si vlastní recepty nebo importujte recepty z webových stránek, například "Chefkoch", "Essen".
{{< gallery match="images/1/*.png" >}}

## Možnost pro profesionály
Jako zkušený uživatel Synology se samozřejmě můžete přihlásit pomocí SSH a nainstalovat celou instalaci pomocí souboru Docker Compose.
```
version: "2.0"
services:
  mealie:
    container_name: mealie
    image: hkotel/mealie:latest
    restart: always
    ports:
      - 9000:80
    environment:
      db_type: sqlite
      TZ: Europa/Berlin
    volumes:
      - ./mealie/data/:/app/data

```

## Krok 1: Vyhledání bitové kopie nástroje Docker
V okně Synology Docker kliknu na kartu "Registrace" a vyhledám položku "mealie". Vyberu obraz Docker "hkotel/mealie:latest" a kliknu na značku "latest".
{{< gallery match="images/2/*.png" >}}
Po stažení obrázku je obrázek k dispozici jako obrázek. Docker rozlišuje 2 stavy, kontejner "dynamický stav" a obraz/image (pevný stav). Před vytvořením kontejneru z bitové kopie je třeba provést několik nastavení.
## Krok 2: Zprovozněte obrázek:
Dvakrát kliknu na svůj obrázek "mealie".
{{< gallery match="images/3/*.png" >}}
Pak kliknu na "Rozšířené nastavení" a aktivuji "Automatický restart". Vyberu kartu "Svazek" a kliknu na "Přidat složku". Tam vytvořím novou složku s touto přípojnou cestou "/app/data".
{{< gallery match="images/4/*.png" >}}
Kontejneru "Mealie" přiřadím pevné porty. Bez pevných portů by se mohlo stát, že "server Mealie" po restartu poběží na jiném portu.
{{< gallery match="images/5/*.png" >}}
Nakonec zadám dvě proměnné prostředí. Proměnná "db_type" je typ databáze a "TZ" je časové pásmo "Europe/Berlin".
{{< gallery match="images/6/*.png" >}}
Po těchto nastaveních lze spustit server Mealie! Poté můžete zavolat Mealie prostřednictvím Ip adresy diskové stanice Synology a přiřazeného portu, například http://192.168.21.23:8096 .
{{< gallery match="images/7/*.png" >}}

## Jak Mealie funguje?
Pokud najedu myší na tlačítko "Plus" vpravo/dole a kliknu na symbol "Řetěz", mohu zadat url adresu. Aplikace Mealie pak automaticky vyhledá požadované metainformace a informace o schématu.
{{< gallery match="images/8/*.png" >}}
Import funguje skvěle (použil jsem tyto funkce s URL adresami ze stránek Chef, Food
{{< gallery match="images/9/*.png" >}}
V režimu úprav mohu také přidat kategorii. Je důležité, abych po každé kategorii jednou stiskl klávesu Enter. V opačném případě se toto nastavení nepoužije.
{{< gallery match="images/10/*.png" >}}

## Speciální funkce
Všiml jsem si, že se kategorie v nabídce automaticky neaktualizují. Musíte si zde pomoci znovunačtením prohlížeče.
{{< gallery match="images/11/*.png" >}}

## Další funkce
Samozřejmě můžete vyhledávat recepty a také vytvářet jídelníčky. Kromě toho můžete aplikaci "Mealie" velmi rozsáhle přizpůsobit.
{{< gallery match="images/12/*.png" >}}
Mealie vypadá skvěle i na mobilu:
{{< gallery match="images/13/*.*" >}}

## Rest-Api
Dokumentaci API najdete na adrese "http://gewaehlte-ip:und-port ... /docs". Zde najdete mnoho metod, které lze použít pro automatizaci.
{{< gallery match="images/14/*.png" >}}

## Příklad rozhraní Api
Představte si následující fikci: "Gruner und Jahr spouští internetový portál Essen.
{{< terminal >}}
wget --spider --force-html -r -l12  "https://www.essen-und-trinken.de/rezepte/archiv/"  2>&1 | grep '/rezepte/' | grep '^--' | awk '{ print $3 }' > liste.txt

{{</ terminal >}}
Poté tento seznam vyčistěte a zobrazte jej proti zbytku api, příklad:
```
#!/bin/bash
sort -u liste.txt > clear.txt

while read p; do
  echo "import url: $p"
  curl -d "{\"url\":\"$p\"}" -H "Content-Type: application/json" http://synology-ip:8096/api/recipes/create-url
  sleep 1
done < clear.txt

```
Nyní můžete k receptům přistupovat i offline:
{{< gallery match="images/15/*.png" >}}
