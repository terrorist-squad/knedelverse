+++
date = "2022-03-21"
title = "Suuria asioita säiliöillä: MP3-tiedostojen tallentaminen radiosta"
difficulty = "level-1"
tags = ["diskstation", "Docker", "docker-compose", "docker-for-desktop", "radio", "mp3", "ripp", "streamripper", "radiorecorder"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2022/march/20220321-docker-mighty-mixxx-tapper/index.fi.md"
+++
Streamripper on komentorivin työkalu, jolla voi tallentaa MP3- tai OGG/Vorbis-virtoja ja tallentaa ne suoraan kiintolevylle. Kappaleet nimetään automaattisesti esittäjän mukaan ja tallennetaan erikseen, ja tiedostomuoto on se, joka on alun perin lähetetty (eli itse asiassa luodaan tiedostoja, joiden tiedostopääte on .mp3 tai .ogg). Löysin loistavan radiorekisteröintilaitteen käyttöliittymän ja rakensin siitä Docker-kuvan, katso: https://github.com/terrorist-squad/mightyMixxxTapper/.
{{< gallery match="images/1/*.png" >}}

## Vaihtoehto ammattilaisille
Kokeneena Synologyn käyttäjänä voit tietenkin kirjautua sisään SSH:lla ja asentaa koko asennuksen Docker Compose -tiedostolla.
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

## Vaihe 1: Etsi Docker-kuva
Napsautan Synology Docker -ikkunan "Rekisteröinti"-välilehteä ja etsin "mighty-mixxx-tapper". Valitsen Docker-kuvan "chrisknedel/mighty-mixxx-tapper" ja napsautan sitten tagia "latest".
{{< gallery match="images/2/*.png" >}}
Kuvan lataamisen jälkeen kuva on käytettävissä kuvana. Dockerissa erotetaan kaksi tilaa, kontti "dynaaminen tila" ja kuva/image (kiinteä tila). Ennen kuin voimme luoda kontin kuvasta, on tehtävä muutamia asetuksia.
## Vaihe 2: Ota kuva käyttöön:
Kaksoisklikkaan "mighty-mixxx-tapper"-kuvaani.
{{< gallery match="images/3/*.png" >}}
Sitten klikkaan "Lisäasetukset" ja aktivoin "Automaattinen uudelleenkäynnistys". Valitsen välilehden "Volume" ja napsautan "Add Folder". Luon siellä uuden kansion, jossa on tämä kiinnityspolku "/tmp/ripps/".
{{< gallery match="images/4/*.png" >}}
Määritän kiinteät portit kontille "mighty-mixxx-tapper". Ilman kiinteitä portteja voi olla, että "mighty-mixxx-tapper-server" toimii eri portissa uudelleenkäynnistyksen jälkeen.
{{< gallery match="images/5/*.png" >}}
Näiden asetusten jälkeen mighty-mixxx-tapper-server voidaan käynnistää! Sen jälkeen voit soittaa mighty-mixxx-tapperiin Synology-aseman Ip-osoitteen ja osoitetun portin, esimerkiksi http://192.168.21.23:8097, kautta.
{{< gallery match="images/6/*.png" >}}