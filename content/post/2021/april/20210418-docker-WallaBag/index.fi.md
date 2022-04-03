+++
date = "2021-04-18"
title = "Suuria asioita säiliöillä: Oma WallaBag Synologyn levyasemalla"
difficulty = "level-1"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "archiv", "wallabag"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210418-docker-WallaBag/index.fi.md"
+++
Wallabag on ohjelma mielenkiintoisten verkkosivustojen tai artikkelien arkistointiin. Tänään näytän, miten Wallabag-palvelu asennetaan Synologyn levyasemaan.
## Vaihtoehto ammattilaisille
Kokeneena Synologyn käyttäjänä voit tietenkin kirjautua sisään SSH:lla ja asentaa koko asennuksen Docker Compose -tiedostolla.
```
version: '3'
services:
  wallabag:
    image: wallabag/wallabag
    environment:
      - MYSQL_ROOT_PASSWORD=wallaroot
      - SYMFONY__ENV__DATABASE_DRIVER=pdo_mysql
      - SYMFONY__ENV__DATABASE_HOST=db
      - SYMFONY__ENV__DATABASE_PORT=3306
      - SYMFONY__ENV__DATABASE_NAME=wallabag
      - SYMFONY__ENV__DATABASE_USER=wallabag
      - SYMFONY__ENV__DATABASE_PASSWORD=wallapass
      - SYMFONY__ENV__DATABASE_CHARSET=utf8mb4
      - SYMFONY__ENV__DOMAIN_NAME=http://192.168.178.50:8089
      - SYMFONY__ENV__SERVER_NAME="Your wallabag instance"
      - SYMFONY__ENV__FOSUSER_CONFIRMATION=false
      - SYMFONY__ENV__TWOFACTOR_AUTH=false
    ports:
      - "8089:80"
    volumes:
      - ./wallabag/images:/var/www/wallabag/web/assets/images

  db:
    image: mariadb
    environment:
      - MYSQL_ROOT_PASSWORD=wallaroot
    volumes:
      - ./mariadb:/var/lib/mysql

```
Lisää hyödyllisiä Docker-kuvia kotikäyttöön löytyy [Dockerverse]({{< ref "dockerverse" >}} "Dockerverse").
## Vaihe 1: Valmista wallabag-kansio
Luon Docker-hakemistoon uuden hakemiston nimeltä "wallabag".
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
|TZ| Europe/Berlin	|Aikavyöhyke|
|MYSQL_ROOT_PASSWORD	 | wallaroot |Tietokannan pääsalasana.|
{{</table>}}
Lopuksi annan nämä ympäristömuuttujat: Ks:
{{< gallery match="images/6/*.png" >}}
Näiden asetusten jälkeen Mariadb-palvelin voidaan käynnistää! Painan "Apply" kaikkialla.
{{< gallery match="images/7/*.png" >}}

## Vaihe 3: Asenna Wallabag
Napsautan Synology Docker -ikkunan "Registration"-välilehteä ja etsin "wallabag". Valitsen Docker-kuvan "wallabag/wallabag" ja napsautan sitten tagia "latest".
{{< gallery match="images/8/*.png" >}}
Kaksoisnapsautan seinäpussini kuvaa. Sitten napsautan "Lisäasetukset" ja aktivoin "Automaattinen uudelleenkäynnistys" myös tässä.
{{< gallery match="images/9/*.png" >}}
Valitsen "Volume"-välilehden ja napsautan "Add Folder". Luon sinne uuden kansion, jossa on tämä liitäntäpolku "/var/www/wallabag/web/assets/images".
{{< gallery match="images/10/*.png" >}}
Määritän kiinteät portit "wallabag"-säiliölle. Ilman kiinteitä portteja voi olla, että "wallabag-palvelin" toimii eri portissa uudelleenkäynnistyksen jälkeen. Ensimmäinen konttisatama voidaan poistaa. Toinen satama olisi muistettava.
{{< gallery match="images/11/*.png" >}}
Lisäksi on vielä luotava "linkki" "mariadb"-säiliöön. Napsautan "Linkit"-välilehteä ja valitsen tietokantasäiliön. Alias-nimi on muistettava wallabag-asennusta varten.
{{< gallery match="images/12/*.png" >}}
{{<table "table table-striped table-bordered">}}
|Umgebungsvariable	|Arvo|
|--- |---|
|MYSQL_ROOT_PASSWORD	|wallaroot|
|SYMFONY__ENV__DATABASE_DRIVER	|pdo_mysql|
|SYMFONY__ENV__DATABASE_HOST	|db|
|SYMFONY__ENV__DATABASE_PORT	|3306|
|SYMFONY__ENV__DATABASE_NAME	|wallabag|
|SYMFONY__ENV__DATABASE_USER	|wallabag|
|SYMFONY__ENV__DATABASE_PASSWORD	|wallapass|
|SYMFONY__ENV__DATABASE_CHARSET |utf8mb4|
|SYMFONY__ENV__DOMAIN_NAME	|"http://synology-ip:container-port" <- Vaihda|
|SYMFONY__ENV__SERVER_NAME	|"Wallabag - palvelin"|
|SYMFONY__ENV__FOSUSER_CONFIRMATION	|väärä|
|SYMFONY__ENV__TWOFACTOR_AUTH	|väärä|
{{</table>}}
Lopuksi annan nämä ympäristömuuttujat: Ks:
{{< gallery match="images/13/*.png" >}}
Säiliö voidaan nyt käynnistää. Tietokannan luominen voi kestää jonkin aikaa. Käyttäytymistä voi tarkkailla säiliön yksityiskohdista.
{{< gallery match="images/14/*.png" >}}
Soitan wallabag-palvelimelle Synologyn IP-osoitteella ja konttiportilla.
{{< gallery match="images/15/*.png" >}}
Minun on kuitenkin sanottava, että itse pidän enemmän shiorista Internet-arkistona.
