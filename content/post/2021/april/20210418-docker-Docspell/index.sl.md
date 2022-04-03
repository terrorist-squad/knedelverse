+++
date = "2021-04-18"
title = "Velike stvari s posodami: Zagon sistema Docspell DMS na strežniku Synology DiskStation"
difficulty = "level-2"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "Document-Managment-System"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210418-docker-Docspell/index.sl.md"
+++
Docspell je sistem za upravljanje dokumentov za strežnik Synology DiskStation. S programom Docspell lahko dokumente veliko hitreje indeksirate, iščete in najdete. Danes prikazujem, kako namestiti storitev Docspell na diskovno postajo Synology.
## Korak 1: Pripravite Synology
Najprej je treba na napravi DiskStation aktivirati prijavo SSH. To storite tako, da greste v "Nadzorna plošča" > "Terminal".
{{< gallery match="images/1/*.png" >}}
Nato se lahko prijavite prek SSH, določenih vrat in skrbniškega gesla (uporabniki Windows uporabljajo Putty ali WinSCP).
{{< gallery match="images/2/*.png" >}}
Prijavim se prek terminala, winSCP ali Puttyja in pustim to konzolo odprto za pozneje.
## Korak 2: Ustvarite mapo Docspel
V imeniku programa Docker ustvarim nov imenik z imenom "docspell".
{{< gallery match="images/3/*.png" >}}
Zdaj je treba prenesti naslednjo datoteko in jo razpakirati v imeniku: https://github.com/eikek/docspell/archive/refs/heads/master.zip . Za to uporabljam konzolo:
{{< terminal >}}
cd /volume1/docker/docspell/
mkdir docs
mkdir postgres_data
wget https://github.com/eikek/docspell/archive/refs/heads/master.zip 
/bin/7z x master.zip

{{</ terminal >}}
Nato uredim datoteko "docker/docker-compose.yml" in v "consumedir" in "db" vnesem naslova Synology:
{{< gallery match="images/4/*.png" >}}
Nato lahko zaženem datoteko Compose:
{{< terminal >}}
cd docspell-master/docker/
docker-compose up -d

{{</ terminal >}}
Po nekaj minutah lahko pokličem strežnik Docspell z IP diskovne postaje in dodeljenimi vrati/7878.
{{< gallery match="images/5/*.png" >}}
Iskanje dokumentov deluje dobro. Škoda, da besedila v slikah niso indeksirana. S programom Papermerge lahko iščete tudi besedila v slikah.
