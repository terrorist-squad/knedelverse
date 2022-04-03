+++
date = "2020-02-21"
title = "Hienoja asioita konttien kanssa: Calibren käyttäminen Docker Composen kanssa (Synology pro -asennus)"
difficulty = "level-3"
tags = ["calibre", "calibre-web", "Docker", "docker-compose", "Synology", "linux"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2020/february/20200221-docker-Calibre-pro/index.fi.md"
+++
Tässä blogissa on jo helpompi opetusohjelma: [Synology-Nas: Asenna Calibre Web e-kirjastoksi]({{< ref "post/2020/february/20200213-synology-calibreweb" >}} "Synology-Nas: Asenna Calibre Web e-kirjastoksi"). Tämä opetusohjelma on tarkoitettu kaikille Synology DS -ammattilaisille.
## Vaihe 1: Synologyn valmistelu
Ensin SSH-kirjautuminen on aktivoitava DiskStationissa. Tee tämä menemällä "Ohjauspaneeli" > "Pääte" > "Pääte".
{{< gallery match="images/1/*.png" >}}
Sitten voit kirjautua sisään "SSH:n", määritetyn portin ja järjestelmänvalvojan salasanan kautta (Windows-käyttäjät käyttävät Puttya tai WinSCP:tä).
{{< gallery match="images/2/*.png" >}}
Kirjaudun sisään terminaalin, winSCP:n tai Puttyn kautta ja jätän tämän konsolin auki myöhempää käyttöä varten.
## Vaihe 2: Luo kirjakansio
Luon uuden kansion Calibre-kirjastolle. Tätä varten kutsun "System Control" -> "Shared Folder" ja luon uuden kansion nimeltä "Books". Jos "Docker"-kansiota ei ole vielä olemassa, se on myös luotava.
{{< gallery match="images/3/*.png" >}}

## Vaihe 3: Valmista kirjakansio
Nyt on ladattava ja purettava seuraava tiedosto: https://drive.google.com/file/d/1zfeU7Jh3FO_jFlWSuZcZQfQOGD0NvXBm/view. Sisältö ("metadata.db") on sijoitettava uuteen kirjahakemistoon, katso:
{{< gallery match="images/4/*.png" >}}

## Vaihe 4: Valmistele Docker-kansio
Luon Docker-hakemistoon uuden hakemiston nimeltä "calibre":
{{< gallery match="images/5/*.png" >}}
Sitten vaihdan uuteen hakemistoon ja luon uuden tiedoston nimeltä "calibre.yml", jonka sisältö on seuraava:
```
version: '2'
services:
  calibre-web:
    image: linuxserver/calibre-web
    container_name: calibre-web-server
    environment:
      - PUID=1026
      - PGID=100
      - TZ=Europe/Berlin
    volumes:
      - /volume1/Buecher:/books
      - /volume1/docker/calibre:/briefkaste
    ports:
      - 8055:8083
    restart: unless-stopped

```
Tässä uudessa tiedostossa on muutettava useita kohtia seuraavasti:* PUID/PGID: DS-käyttäjän käyttäjä- ja ryhmätunnus on syötettävä kohtaan PUID/PGID. Tässä käytän konsolia "Vaiheesta 1" ja komentoja "id -u" nähdäksesi käyttäjätunnuksen. Komennolla "id -g" saan ryhmän ID:n.* portit: Portin etuosa "8055:" on korjattava.hakemistotKaikki tämän tiedoston hakemistot on korjattava. Oikeat osoitteet näkyvät DS:n ominaisuusikkunassa. (Kuvakaappaus seuraa)
{{< gallery match="images/6/*.png" >}}

## Vaihe 5: Testin käynnistys
Voin myös hyödyntää konsolia tässä vaiheessa. Siirryn Calibre-hakemistoon ja käynnistän Calibre-palvelimen siellä Docker Composen kautta.
{{< terminal >}}
cd /volume1/docker/calibre
sudo docker-compose -f calibre.yml up -d

{{</ terminal >}}

{{< gallery match="images/7/*.png" >}}

## Vaihe 6: Asetukset
Sitten voin soittaa Calibre-palvelimelle levyaseman IP-osoitteella ja vaiheessa 4 määritetyllä portilla. Käytän asennuksessa liitäntäpistettä "/books". Sen jälkeen palvelin on jo käyttökelpoinen.
{{< gallery match="images/8/*.png" >}}

## Vaihe 7: Asetusten viimeistely
Konsolia tarvitaan myös tässä vaiheessa. Käytän komentoa "exec" kontin sisäisen sovellustietokannan tallentamiseen.
{{< terminal >}}
sudo docker exec -it calibre-web-server cp /app/calibre-web/app.db /briefkaste/app.db

{{</ terminal >}}
Tämän jälkeen Calibre-hakemistossa on uusi "app.db"-tiedosto:
{{< gallery match="images/9/*.png" >}}
Tämän jälkeen pysäytän Calibre-palvelimen:
{{< terminal >}}
sudo docker-compose -f calibre.yml down

{{</ terminal >}}
Nyt muutan letterbox-polkua ja säilytän sovellustietokannan sen yli.
```
version: '2'
services:
  calibre-web:
    image: linuxserver/calibre-web
    container_name: calibre-web-server
    environment:
      - PUID=1026
      - PGID=100
      - TZ=Europe/Berlin
    volumes:
      - /volume1/Buecher:/books
      - /volume1/docker/calibre/app.db:/app/calibre-web/app.db
    ports:
      - 8055:8083
    restart: unless-stopped

```
Sen jälkeen palvelin voidaan käynnistää uudelleen:
{{< terminal >}}
sudo docker-compose -f calibre.yml up -d

{{</ terminal >}}
