+++
date = "2020-02-27"
title = "Suuria asioita konttien avulla: Youtube-latausohjelman käyttäminen Synology Diskstationilla"
difficulty = "level-1"
tags = ["Docker", "docker-compose", "download", "linux", "Synology", "video", "youtube"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2020/february/20200227-docker-youtube-dl/index.fi.md"
+++
Monet ystäväni tietävät, että pidän yksityistä oppimisvideoportaalia Homelab -verkossani. Olen tallentanut videokursseja aiemmista oppimisportaali-jäsenyyksistä ja hyviä Youtube-oppaita offline-käyttöä varten NAS-asemalleni.
{{< gallery match="images/1/*.png" >}}
Ajan myötä olen kerännyt 8845 videokurssia, joissa on 282616 yksittäistä videota. Kokonaiskesto on noin 2 vuotta. Täysin hullua! Tässä opetusohjelmassa näytän, kuinka varmuuskopioida hyviä Youtube-opetuksia Docker-latauspalvelun avulla offline-tarkoituksiin.
## Vaihtoehto ammattilaisille
Kokeneena Synologyn käyttäjänä voit tietenkin kirjautua sisään SSH:lla ja asentaa koko asennuksen Docker Compose -tiedostolla.
```
version: "2"
services:
  youtube-dl:
    image: modenaf360/youtube-dl-nas
    container_name: youtube-dl
    environment:
      - MY_ID=admin
      - MY_PW=admin
    volumes:
      - ./YouTube:/downfolder
    ports:
      - 8080:8080
    restart: unless-stopped

```

## Vaihe 1
Ensin luon kansion latauksia varten. Siirryn kohtaan "Järjestelmänhallinta" -> "Jaettu kansio" ja luon uuden kansion nimeltä "Lataukset".
{{< gallery match="images/2/*.png" >}}

## Vaihe 2: Etsi Docker-kuva
Napsautan Synology Docker -ikkunan "Rekisteröinti"-välilehteä ja etsin "youtube-dl-nas". Valitsen Docker-kuvan "modenaf360/youtube-dl-nas" ja napsautan sitten tagia "latest".
{{< gallery match="images/3/*.png" >}}
Kuvan lataamisen jälkeen kuva on käytettävissä kuvana. Dockerissa erotetaan kaksi tilaa, kontti "dynaaminen tila" ja kuva/image (kiinteä tila). Ennen kuin voimme luoda säiliön kuvasta, on tehtävä muutamia asetuksia.
## Vaihe 3: Ota kuva käyttöön:
Kaksoisklikkaan youtube-dl-nas-kuvaani.
{{< gallery match="images/4/*.png" >}}
Sitten klikkaan "Lisäasetukset" ja aktivoin "Automaattinen uudelleenkäynnistys". Valitsen välilehden "Volume" ja napsautan "Add folder". Siellä luon uuden tietokantakansion, jonka kiinnityspolku on "/downfolder".
{{< gallery match="images/5/*.png" >}}
Määritän kiinteät portit kontille "Youtube Downloader". Ilman kiinteitä portteja voi olla, että "Youtube Downloader" toimii eri portissa uudelleenkäynnistyksen jälkeen.
{{< gallery match="images/6/*.png" >}}
Lopuksi annan kaksi ympäristömuuttujaa. Muuttuja "MY_ID" on käyttäjänimeni ja "MY_PW" on salasanani.
{{< gallery match="images/7/*.png" >}}
Näiden asetusten jälkeen Downloader voidaan käynnistää! Sen jälkeen voit soittaa latausohjelmaan Synology-aseman Ip-osoitteen ja määritetyn portin kautta, esimerkiksi http://192.168.21.23:8070 .
{{< gallery match="images/8/*.png" >}}
Ota todennusta varten käyttäjänimi ja salasana MY_ID- ja MY_PW-kohdista.
## Vaihe 4: Mennään
Nyt Youtube-videoiden URL-osoitteet ja soittolistan URL-osoitteet voidaan syöttää "URL"-kenttään, ja kaikki videot päätyvät automaattisesti Synologyn levyaseman latauskansioon.
{{< gallery match="images/9/*.png" >}}
Lataa kansio:
{{< gallery match="images/10/*.png" >}}