+++
date = "2021-03-07"
title = "Suuria asioita säiliöillä: reseptien hallinta ja arkistointi Synology DiskStationilla"
difficulty = "level-1"
tags = ["diskstation", "Docker", "docker-compose", "docker-for-desktop", "rezepte", "speisen", "Synology"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/march/20210307-docker-mealie/index.fi.md"
+++
Kerää kaikki suosikkireseptisi Docker-säiliöön ja järjestä ne haluamallasi tavalla. Kirjoita omia reseptejäsi tai tuo reseptejä verkkosivustoilta, esimerkiksi "Chefkoch", "Essen", "Essen
{{< gallery match="images/1/*.png" >}}

## Vaihtoehto ammattilaisille
Kokeneena Synologyn käyttäjänä voit tietenkin kirjautua sisään SSH:lla ja asentaa koko asennuksen Docker Compose -tiedostolla.
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

## Vaihe 1: Etsi Docker-kuva
Napsautan Synology Docker -ikkunan "Rekisteröinti"-välilehteä ja etsin "mealie". Valitsen Docker-kuvan "hkotel/mealie:latest" ja napsautan sitten tagia "latest".
{{< gallery match="images/2/*.png" >}}
Kuvan lataamisen jälkeen kuva on käytettävissä kuvana. Dockerissa erotetaan kaksi tilaa, kontti "dynaaminen tila" ja kuva/image (kiinteä tila). Ennen kuin voimme luoda säiliön kuvasta, on tehtävä muutamia asetuksia.
## Vaihe 2: Ota kuva käyttöön:
Kaksoisklikkaan "mealie"-kuvaani.
{{< gallery match="images/3/*.png" >}}
Sitten klikkaan "Lisäasetukset" ja aktivoin "Automaattinen uudelleenkäynnistys". Valitsen välilehden "Volume" ja napsautan "Add Folder". Luon siellä uuden kansion, jossa on tämä kiinnityspolku "/app/data".
{{< gallery match="images/4/*.png" >}}
Määritän kiinteät portit Mealie-säiliölle. Ilman kiinteitä portteja voi olla, että "Mealie-palvelin" toimii eri portissa uudelleenkäynnistyksen jälkeen.
{{< gallery match="images/5/*.png" >}}
Lopuksi annan kaksi ympäristömuuttujaa. Muuttuja "db_type" on tietokantatyyppi ja "TZ" on aikavyöhyke "Eurooppa/Berliini".
{{< gallery match="images/6/*.png" >}}
Näiden asetusten jälkeen Mealie Server voidaan käynnistää! Sen jälkeen voit soittaa Mealieen Synology-aseman Ip-osoitteen ja osoitetun portin kautta, esimerkiksi http://192.168.21.23:8096 .
{{< gallery match="images/7/*.png" >}}

## Miten Mealie toimii?
Jos siirrän hiiren oikealla/alhaalla olevan "Plus"-painikkeen päälle ja napsautan sitten "Ketju"-symbolia, voin syöttää url-osoitteen. Tämän jälkeen Mealie-sovellus etsii automaattisesti tarvittavat meta- ja skeematiedot.
{{< gallery match="images/8/*.png" >}}
Tuonti toimii loistavasti (olen käyttänyt näitä funktioita urlilla Chefistä, Food
{{< gallery match="images/9/*.png" >}}
Muokkaustilassa voin myös lisätä luokan. On tärkeää, että painan Enter-näppäintä kerran jokaisen luokan jälkeen. Muussa tapauksessa tätä asetusta ei käytetä.
{{< gallery match="images/10/*.png" >}}

## Erityisominaisuudet
Huomasin, että valikkoluokat eivät päivity automaattisesti. Sinun on autettava tässä selaimen uudelleenlatauksella.
{{< gallery match="images/11/*.png" >}}

## Muut ominaisuudet
Voit tietysti etsiä reseptejä ja myös luoda ruokalistoja. Lisäksi voit muokata "Mealie"-ohjelmaa hyvin laajasti.
{{< gallery match="images/12/*.png" >}}
Mealie näyttää hyvältä myös mobiilissa:
{{< gallery match="images/13/*.*" >}}

## Rest-Api
API:n dokumentaatio löytyy osoitteesta "http://gewaehlte-ip:und-port ... /docs". Täältä löydät monia menetelmiä, joita voidaan käyttää automatisointiin.
{{< gallery match="images/14/*.png" >}}

## Api-esimerkki
Kuvittele seuraava fiktio: "Gruner und Jahr käynnistää Essenin internetportaalin.
{{< terminal >}}
wget --spider --force-html -r -l12  "https://www.essen-und-trinken.de/rezepte/archiv/"  2>&1 | grep '/rezepte/' | grep '^--' | awk '{ print $3 }' > liste.txt

{{</ terminal >}}
Siivoa sitten tämä lista ja laukaise se loput api, esim:
```
#!/bin/bash
sort -u liste.txt > clear.txt

while read p; do
  echo "import url: $p"
  curl -d "{\"url\":\"$p\"}" -H "Content-Type: application/json" http://synology-ip:8096/api/recipes/create-url
  sleep 1
done < clear.txt

```
Nyt voit käyttää reseptejä myös offline-tilassa:
{{< gallery match="images/15/*.png" >}}
