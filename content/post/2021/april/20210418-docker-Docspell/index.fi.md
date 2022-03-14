+++
date = "2021-04-18"
title = "Suuria asioita konttien avulla: Docspell DMS:n käyttäminen Synology DiskStationilla"
difficulty = "level-2"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "Document-Managment-System"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210418-docker-Docspell/index.fi.md"
+++
Docspell on asiakirjahallintajärjestelmä Synology DiskStationille. Docspellin avulla asiakirjat voidaan indeksoida, hakea ja löytää paljon nopeammin. Tänään näytän, miten Docspell-palvelu asennetaan Synologyn levyasemalle.
## Vaihe 1: Synologyn valmistelu
Ensin SSH-kirjautuminen on aktivoitava DiskStationissa. Tee tämä menemällä "Ohjauspaneeli" > "Pääte" > "Pääte".
{{< gallery match="images/1/*.png" >}}
Sitten voit kirjautua sisään "SSH:n", määritetyn portin ja järjestelmänvalvojan salasanan kautta (Windows-käyttäjät käyttävät Puttya tai WinSCP:tä).
{{< gallery match="images/2/*.png" >}}
Kirjaudun sisään terminaalin, winSCP:n tai Puttyn kautta ja jätän tämän konsolin auki myöhempää käyttöä varten.
## Vaihe 2: Luo Docspel-kansio
Luon Docker-hakemistoon uuden hakemiston nimeltä "docspell".
{{< gallery match="images/3/*.png" >}}
Nyt seuraava tiedosto on ladattava ja purettava hakemistoon: https://github.com/eikek/docspell/archive/refs/heads/master.zip . Käytän tähän konsolia:
{{< terminal >}}
cd /volume1/docker/docspell/
mkdir docs
mkdir postgres_data
wget https://github.com/eikek/docspell/archive/refs/heads/master.zip 
/bin/7z x master.zip

{{</ terminal >}}
Sitten muokkaan tiedostoa "docker/docker-compose.yml" ja kirjoitan Synologyn osoitteet kohdissa "consumedir" ja "db":
{{< gallery match="images/4/*.png" >}}
Sen jälkeen voin käynnistää Compose-tiedoston:
{{< terminal >}}
cd docspell-master/docker/
docker-compose up -d

{{</ terminal >}}
Muutaman minuutin kuluttua voin soittaa Docspell-palvelimelle levyaseman IP-osoitteella ja osoitetulla portilla/7878.
{{< gallery match="images/5/*.png" >}}
