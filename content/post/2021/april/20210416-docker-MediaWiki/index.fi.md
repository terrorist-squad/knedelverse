+++
date = "2021-04-16"
title = "Suuria asioita konttien avulla: oman MediaWikin asentaminen Synologyn levyasemalle"
difficulty = "level-1"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "mediawiki", "wiki"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210416-docker-MediaWiki/index.fi.md"
+++
MediaWiki on PHP-pohjainen wikijärjestelmä, joka on saatavilla ilmaiseksi avoimen lähdekoodin tuotteena. Tänään näytän, miten MediaWiki-palvelu asennetaan Synologyn levyasemalle.
## Vaihtoehto ammattilaisille
Kokeneena Synologyn käyttäjänä voit tietenkin kirjautua sisään SSH:lla ja asentaa koko asennuksen Docker Compose -tiedostolla.
```
version: '3'
services:
  mediawiki:
    image: mediawiki
    restart: always
    ports:
      - 8081:80
    links:
      - database
    volumes:
      - ./images:/var/www/html/images
      # After initial setup, download LocalSettings.php to the same directory as
      # this yaml and uncomment the following line and use compose to restart
      # the mediawiki service
      # - ./LocalSettings.php:/var/www/html/LocalSettings.php

  database:
    image: mariadb
    restart: always
    volumes:
       - ./mysql:/var/lib/mysql
    environment:
      # @see https://phabricator.wikimedia.org/source/mediawiki/browse/master/includes/DefaultSettings.php
      MYSQL_ROOT_PASSWORD: my_wiki_pass1
      MYSQL_DATABASE: my_wiki
      MYSQL_USER: wikiuser
      MYSQL_PASSWORD: my_wiki_pass

```
Lisää hyödyllisiä Docker-kuvia kotikäyttöön löytyy [Dockerverse]({{< ref "dockerverse" >}} "Dockerverse").
## Vaihe 1: MediaWiki-kansion valmistelu
Luon Docker-hakemistoon uuden hakemiston nimeltä "wiki".
{{< gallery match="images/1/*.png" >}}

## Vaihe 2: Asenna tietokanta
Tämän jälkeen on luotava tietokanta. Napsautan Synology Docker -ikkunan "Registration"-välilehteä ja etsin "mariadb". Valitsen Docker-kuvan "mariadb" ja napsautan sitten tagia "latest".
{{< gallery match="images/2/*.png" >}}
Kuvan lataamisen jälkeen kuva on käytettävissä kuvana. Dockerissa erotetaan kaksi tilaa, kontti (dynaaminen tila) ja kuva (kiinteä tila). Ennen kuin luomme kontin kuvasta, on tehtävä muutama asetus. Kaksoisnapsautan mariadb-kuvaani.
{{< gallery match="images/3/*.png" >}}
Sitten klikkaan "Lisäasetukset" ja aktivoin "Automaattinen uudelleenkäynnistys". Valitsen välilehden "Volume" ja napsautan "Add Folder". Siellä luon uuden tietokantakansio, jossa on tämä liitäntäpolku "/var/lib/mysql".
{{< gallery match="images/4/*.png" >}}
Porttiasetukset-kohdasta poistetaan kaikki portit. Tämä tarkoittaa, että valitsen portin "3306" ja poistan sen painikkeella "-".
{{< gallery match="images/5/*.png" >}}
{{<table "table table-striped table-bordered">}}
|Muuttujan nimi|Arvo|Mikä se on?|
|--- | --- |---|
|TZ	| Europe/Berlin	|Aikavyöhyke|
|MYSQL_ROOT_PASSWORD	| my_wiki_pass	|Tietokannan pääsalasana.|
|MYSQL_DATABASE |	my_wiki	|Tämä on tietokannan nimi.|
|MYSQL_USER	| wikiuser |Wiki-tietokannan käyttäjänimi.|
|MYSQL_PASSWORD	| my_wiki_pass |Wiki-tietokannan käyttäjän salasana.|
{{</table>}}
Lopuksi annan nämä ympäristömuuttujat: Ks:
{{< gallery match="images/6/*.png" >}}
Näiden asetusten jälkeen Mariadb-palvelin voidaan käynnistää! Painan "Apply" kaikkialla.
## Vaihe 3: Asenna MediaWiki
Napsautan Synology Docker -ikkunan "Rekisteröinti"-välilehteä ja etsin "mediawiki". Valitsen Docker-kuvan "mediawiki" ja napsautan sitten tagia "latest".
{{< gallery match="images/7/*.png" >}}
Kaksoisnapsautan Mediawikin kuvaa.
{{< gallery match="images/8/*.png" >}}
Sitten napsautan "Lisäasetukset" ja aktivoin "Automaattinen uudelleenkäynnistys" myös täällä. Valitsen välilehden "Volume" ja napsautan "Add Folder". Siellä luon uuden kansion, jossa on tämä kiinnityspolku "/var/www/html/images".
{{< gallery match="images/9/*.png" >}}
Määritän kiinteät portit "MediaWiki"-kontille. Ilman kiinteitä portteja voi olla, että "MediaWiki-palvelin" toimii eri portissa uudelleenkäynnistyksen jälkeen.
{{< gallery match="images/10/*.png" >}}
Lisäksi on vielä luotava "linkki" "mariadb"-säiliöön. Napsautan "Linkit"-välilehteä ja valitsen tietokantasäiliön. Alias-nimi on muistettava wikin asennusta varten.
{{< gallery match="images/11/*.png" >}}
Lopuksi annan ympäristömuuttujan "TZ" arvoksi "Europe/Berlin".
{{< gallery match="images/12/*.png" >}}
Säiliö voidaan nyt käynnistää. Kutsun Mediawiki-palvelinta Synologyn IP-osoitteella ja konttiportilla. Kohdassa Tietokantapalvelin annan tietokantasäiliön alias-nimen. Syötän myös tietokannan nimen, käyttäjänimen ja salasanan vaiheesta 2.
{{< gallery match="images/13/*.png" >}}