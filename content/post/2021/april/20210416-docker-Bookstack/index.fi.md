+++
date = "2021-04-16"
title = "Suuria asioita konttien avulla: oma Bookstack Wiki Synology DiskStationilla"
difficulty = "level-1"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "bookstack", "wiki"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/april/20210416-docker-Bookstack/index.fi.md"
+++
Bookstack on "avoimen lähdekoodin" vaihtoehto MediaWikille tai Confluencelle. Tänään näytän, miten Bookstack-palvelu asennetaan Synologyn levyasemalle.
## Vaihtoehto ammattilaisille
Kokeneena Synologyn käyttäjänä voit tietenkin kirjautua sisään SSH:lla ja asentaa koko asennuksen Docker Compose -tiedostolla.
```
version: '3'
services:
  bookstack:
    image: solidnerd/bookstack:0.27.4-1
    restart: always
    ports:
      - 8080:8080
    links:
      - database
    environment:
      DB_HOST: database:3306
      DB_DATABASE: my_wiki
      DB_USERNAME: wikiuser
      DB_PASSWORD: my_wiki_pass
      
  database:
    image: mariadb
    restart: always
    volumes:
       - ./mysql:/var/lib/mysql
    environment:
      MYSQL_ROOT_PASSWORD: my_wiki_pass1
      MYSQL_DATABASE: my_wiki
      MYSQL_USER: wikiuser
      MYSQL_PASSWORD: my_wiki_pass

```
Lisää hyödyllisiä Docker-kuvia kotikäyttöön löytyy [Dockerverse]({{< ref "dockerverse" >}} "Dockerverse").
## Vaihe 1: Valmistele kirjapino-kansio
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
|TZ	| Europe/Berlin |Aikavyöhyke|
|MYSQL_ROOT_PASSWORD	|  my_wiki_pass |Tietokannan pääsalasana.|
|MYSQL_DATABASE | 	my_wiki	|Tämä on tietokannan nimi.|
|MYSQL_USER	|  wikiuser	|Wiki-tietokannan käyttäjänimi.|
|MYSQL_PASSWORD	|  my_wiki_pass	|Wiki-tietokannan käyttäjän salasana.|
{{</table>}}
Lopuksi annan nämä ympäristömuuttujat: Ks:
{{< gallery match="images/6/*.png" >}}
Näiden asetusten jälkeen Mariadb-palvelin voidaan käynnistää! Painan "Apply" kaikkialla.
## Vaihe 3: Asenna Bookstack
Napsautan Synology Docker -ikkunan "Rekisteröinti"-välilehteä ja etsin "bookstack". Valitsen Docker-kuvan "solidnerd/bookstack" ja napsautan sitten tagia "latest".
{{< gallery match="images/7/*.png" >}}
Kaksoisnapsautan Bookstack-kuvaani. Sitten napsautan "Lisäasetukset" ja aktivoin "Automaattinen uudelleenkäynnistys" myös täällä.
{{< gallery match="images/8/*.png" >}}
Määritän kiinteät portit kontille "bookstack". Ilman kiinteitä portteja voi olla, että "bookstack-palvelin" toimii eri portissa uudelleenkäynnistyksen jälkeen. Ensimmäinen konttisatama voidaan poistaa. Toinen satama olisi muistettava.
{{< gallery match="images/9/*.png" >}}
Lisäksi on vielä luotava "linkki" "mariadb"-säiliöön. Napsautan "Linkit"-välilehteä ja valitsen tietokantasäiliön. Alias-nimi on muistettava wikin asennusta varten.
{{< gallery match="images/10/*.png" >}}
{{<table "table table-striped table-bordered">}}
|Muuttujan nimi|Arvo|Mikä se on?|
|--- | --- |---|
|TZ	| Europe/Berlin |Aikavyöhyke|
|DB_HOST	| wiki-db:3306	|Alias-nimet / säiliölinkki|
|DB_DATABASE	| my_wiki |Vaiheen 2 tiedot|
|DB_USERNAME	| wikiuser |Vaiheen 2 tiedot|
|DB_PASSWORD	| my_wiki_pass	|Vaiheen 2 tiedot|
{{</table>}}
Lopuksi annan nämä ympäristömuuttujat: Ks:
{{< gallery match="images/11/*.png" >}}
Säiliö voidaan nyt käynnistää. Tietokannan luominen voi kestää jonkin aikaa. Käyttäytymistä voi tarkkailla säiliön yksityiskohdista.
{{< gallery match="images/12/*.png" >}}
Soitan Bookstack-palvelimelle Synologyn IP-osoitteella ja konttiportilla. Kirjautumisnimi on "admin@admin.com" ja salasana "password".
{{< gallery match="images/13/*.png" >}}
