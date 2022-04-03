+++
date = "2021-07-25"
title = "Suuria asioita säiliöillä: jääkaapin hallinta Grocyn avulla"
difficulty = "level-1"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "kühlschrank", "erp", "mhd", "Speispläne", "cms", "Cafe", "Bistro"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/july/20210725-docker-grocy/index.fi.md"
+++
Grocyn avulla voit hallita kokonaista kotitaloutta, ravintolaa, kahvilaa, bistroa tai ruokakauppaa. Voit hallita jääkaappeja, ruokalistoja, tehtäviä, ostoslistoja ja elintarvikkeiden parasta ennen -päivämääriä.
{{< gallery match="images/1/*.png" >}}
Tänään näytän, miten Grocy-palvelu asennetaan Synologyn levyasemalle.
## Vaihtoehto ammattilaisille
Kokeneena Synologyn käyttäjänä voit tietenkin kirjautua sisään SSH:lla ja asentaa koko asennuksen Docker Compose -tiedostolla.
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
Lisää hyödyllisiä Docker-kuvia kotikäyttöön löytyy [Dockerverse]({{< ref "dockerverse" >}} "Dockerverse").
## Vaihe 1: Valmistele Grocy-kansio
Luon Docker-hakemistoon uuden hakemiston nimeltä "grocy".
{{< gallery match="images/2/*.png" >}}

## Vaihe 2: Asenna Grocy
Napsautan Synology Docker -ikkunan "Registration"-välilehteä ja etsin "Grocy". Valitsen Docker-kuvan "linuxserver/grocy:latest" ja napsautan sitten tagia "latest".
{{< gallery match="images/3/*.png" >}}
Kaksoisnapsautan Grocy-kuvaani.
{{< gallery match="images/4/*.png" >}}
Sitten napsautan "Lisäasetukset" ja aktivoin "Automaattinen uudelleenkäynnistys" myös täällä. Valitsen välilehden "Volume" ja napsautan "Add Folder". Siellä luon uuden kansion, jossa on tämä liitäntäpolku "/config".
{{< gallery match="images/5/*.png" >}}
Määritän kiinteät portit Grocy-säiliölle. Ilman kiinteitä portteja voi olla, että "Grocy-palvelin" toimii eri portissa uudelleenkäynnistyksen jälkeen.
{{< gallery match="images/6/*.png" >}}
{{<table "table table-striped table-bordered">}}
|Muuttujan nimi|Arvo|Mikä se on?|
|--- | --- |---|
|TZ | Europe/Berlin |Aikavyöhyke|
|PUID | 1024 |Käyttäjätunnus Synology Admin User -käyttäjältä|
|PGID |	100 |Ryhmän ID Synology Admin User -käyttäjältä|
{{</table>}}
Lopuksi annan nämä ympäristömuuttujat: Ks:
{{< gallery match="images/7/*.png" >}}
Säiliö voidaan nyt käynnistää. Kutsun Grocy-palvelimen Synologyn IP-osoitteella ja konttiportilla ja kirjaudun sisään käyttäjänimellä "admin" ja salasanalla "admin".
{{< gallery match="images/8/*.png" >}}

