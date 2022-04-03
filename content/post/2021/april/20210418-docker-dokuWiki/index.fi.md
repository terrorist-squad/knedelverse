+++
date = "2021-04-18"
title = "Suuria asioita konttien avulla: Oman dokuWikin asentaminen Synologyn levyasemalle"
difficulty = "level-2"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "dokuwiki", "wiki"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210418-docker-dokuWiki/index.fi.md"
+++
DokuWiki on standardien mukainen, helppokäyttöinen ja samalla erittäin monipuolinen avoimen lähdekoodin wikiohjelmisto. Tänään näytän, miten DokuWiki-palvelu asennetaan Synologyn levyasemalle.
## Vaihtoehto ammattilaisille
Kokeneena Synologyn käyttäjänä voit tietenkin kirjautua sisään SSH:lla ja asentaa koko asennuksen Docker Compose -tiedostolla.
```
version: '3'
services:
  dokuwiki:
    image:  bitnami/dokuwiki:latest
    restart: always
    ports:
      - 8080:8080
      - 8443:8443
    environment:
      TZ: 'Europe/Berlin'
      DOKUWIKI_USERNAME: 'admin'
      DOKUWIKI_FULL_NAME: 'wiki'
      DOKUWIKI_PASSWORD: 'password'
    volumes:
      - ./data:/bitnami/dokuwiki

```
Lisää hyödyllisiä Docker-kuvia kotikäyttöön löytyy [Dockerverse]({{< ref "dockerverse" >}} "Dockerverse").
## Vaihe 1: Valmistele wikikansio
Luon Docker-hakemistoon uuden hakemiston nimeltä "wiki".
{{< gallery match="images/1/*.png" >}}

## Vaihe 2: Asenna DokuWiki
Tämän jälkeen on luotava tietokanta. Napsautan Synology Docker -ikkunan "Rekisteröinti"-välilehteä ja etsin "dokuwiki". Valitsen Docker-kuvan "bitnami/dokuwiki" ja napsautan sitten tagia "latest".
{{< gallery match="images/2/*.png" >}}
Kuvan lataamisen jälkeen kuva on käytettävissä kuvana. Dockerissa erotetaan kaksi tilaa, kontti (dynaaminen tila) ja kuva (kiinteä tila). Ennen kuin luomme kontin kuvasta, on tehtävä muutama asetus. Kaksoisnapsautan dokuwiki-kuvaani.
{{< gallery match="images/3/*.png" >}}
Määritän kiinteät portit dokuwiki-säiliölle. Ilman kiinteitä portteja voi olla, että "dokuwiki-palvelin" toimii eri portissa uudelleenkäynnistyksen jälkeen.
{{< gallery match="images/4/*.png" >}}
{{<table "table table-striped table-bordered">}}
|Muuttujan nimi|Arvo|Mikä se on?|
|--- | --- |---|
|TZ	| Europe/Berlin	|Aikavyöhyke|
|DOKUWIKI_USERNAME	| admin|Järjestelmänvalvojan käyttäjätunnus|
|DOKUWIKI_FULL_NAME |	wiki	|WIki-nimi|
|DOKUWIKI_PASSWORD	| password	|Ylläpitäjän salasana|
{{</table>}}
Lopuksi annan nämä ympäristömuuttujat: Ks:
{{< gallery match="images/5/*.png" >}}
Säiliö voidaan nyt käynnistää. Kutsun dokuWIki-palvelinta Synologyn IP-osoitteella ja konttiportilla.
{{< gallery match="images/6/*.png" >}}

