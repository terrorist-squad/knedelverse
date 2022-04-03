+++
date = "2021-04-18"
title = "Veľké veci s kontajnermi: Spustenie systému Docspell DMS na stanici Synology DiskStation"
difficulty = "level-2"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "Document-Managment-System"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210418-docker-Docspell/index.sk.md"
+++
Docspell je systém správy dokumentov pre zariadenie Synology DiskStation. Prostredníctvom služby Docspell je možné dokumenty indexovať, vyhľadávať a nájsť oveľa rýchlejšie. Dnes ukážem, ako nainštalovať službu Docspell na diskovú stanicu Synology.
## Krok 1: Príprava spoločnosti Synology
Najprv je potrebné aktivovať prihlásenie SSH na zariadení DiskStation. Ak to chcete urobiť, prejdite na "Ovládací panel" > "Terminál".
{{< gallery match="images/1/*.png" >}}
Potom sa môžete prihlásiť cez "SSH", zadaný port a heslo správcu (používatelia systému Windows používajú Putty alebo WinSCP).
{{< gallery match="images/2/*.png" >}}
Prihlásim sa cez terminál, winSCP alebo Putty a túto konzolu nechám otvorenú na neskôr.
## Krok 2: Vytvorenie priečinka Docspel
V adresári Docker vytvorím nový adresár s názvom "docspell".
{{< gallery match="images/3/*.png" >}}
Teraz je potrebné stiahnuť a rozbaliť nasledujúci súbor do adresára: https://github.com/eikek/docspell/archive/refs/heads/master.zip . Používam na to konzolu:
{{< terminal >}}
cd /volume1/docker/docspell/
mkdir docs
mkdir postgres_data
wget https://github.com/eikek/docspell/archive/refs/heads/master.zip 
/bin/7z x master.zip

{{</ terminal >}}
Potom upravím súbor "docker/docker-compose.yml" a do položiek "consumedir" a "db" zadám adresy Synology:
{{< gallery match="images/4/*.png" >}}
Potom môžem spustiť súbor Compose:
{{< terminal >}}
cd docspell-master/docker/
docker-compose up -d

{{</ terminal >}}
Po niekoľkých minútach môžem zavolať svoj server Docspell pomocou IP adresy diskovej stanice a priradeného portu/7878.
{{< gallery match="images/5/*.png" >}}
Vyhľadávanie dokumentov funguje dobre. Je škoda, že texty v obrázkoch nie sú indexované. Pomocou aplikácie Papermerge môžete vyhľadávať aj texty v obrázkoch.
