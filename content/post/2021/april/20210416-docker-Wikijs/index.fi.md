+++
date = "2021-04-16"
title = "Suuria asioita konttien avulla: Wiki.js:n asentaminen Synology Diskstationiin"
difficulty = "level-1"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "wikijs", "wiki"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210416-docker-Wikijs/index.fi.md"
+++
Wiki.js on tehokas avoimen lähdekoodin wikiohjelmisto, joka tekee dokumentoinnista iloa yksinkertaisen käyttöliittymänsä ansiosta. Tänään näytän, miten Wiki.js-palvelu asennetaan Synology DiskStationiin.
## Vaihtoehto ammattilaisille
Kokeneena Synologyn käyttäjänä voit tietenkin kirjautua sisään SSH:lla ja asentaa koko asennuksen Docker Compose -tiedostolla.
```
version: '3'
services:
  wikijs:
    image: requarks/wiki:latest
    restart: always
    ports:
      - 8082:3000
    links:
      - database
    environment:
      DB_TYPE: mysql
      DB_HOST: database
      DB_PORT: 3306
      DB_NAME: my_wiki
      DB_USER: wikiuser
      DB_PASS: my_wiki_pass
      TZ: 'Europe/Berlin'

  database:
    image: mysql
    restart: always
    expose:
      - 3306
    volumes:
       - ./mysql:/var/lib/mysql
    environment:
      MYSQL_ROOT_PASSWORD: my_wiki_pass
      MYSQL_DATABASE: my_wiki
      MYSQL_USER: wikiuser
      MYSQL_PASSWORD: my_wiki_pass

```
Löydät lisää hyödyllisiä Docker-kuvia kotikäyttöön Dockerverse-sivustolta.
## Vaihe 1: Valmistele wikikansio
Luon Docker-hakemistoon uuden hakemiston nimeltä "wiki".
{{< gallery match="images/1/*.png" >}}

## Vaihe 2: Asenna tietokanta
Tämän jälkeen on luotava tietokanta. Napsautan Synology Docker -ikkunan "Registration"-välilehteä ja etsin "mysql". Valitsen Docker-kuvan "mysql" ja napsautan sitten tagia "latest".
{{< gallery match="images/2/*.png" >}}
Kuvan lataamisen jälkeen kuva on käytettävissä kuvana. Dockerissa erotetaan kaksi tilaa, kontti (dynaaminen tila) ja kuva (kiinteä tila). Ennen kuin luomme kontin kuvasta, on tehtävä muutamia asetuksia. Kaksoisnapsautan mysql-kuvaani.
{{< gallery match="images/3/*.png" >}}
Sitten klikkaan "Lisäasetukset" ja aktivoin "Automaattinen uudelleenkäynnistys". Valitsen välilehden "Volume" ja napsautan "Add Folder". Siellä luon uuden tietokantakansio, jossa on tämä liitäntäpolku "/var/lib/mysql".
{{< gallery match="images/4/*.png" >}}
Porttiasetukset-kohdasta poistetaan kaikki portit. Tämä tarkoittaa, että valitsen portin "3306" ja poistan sen painikkeella "-".
{{< gallery match="images/5/*.png" >}}
{{<table "table table-striped table-bordered">}}
|Muuttujan nimi|Arvo|Mikä se on?|
|--- | --- |---|
|TZ	| Europe/Berlin |Aikavyöhyke|
|MYSQL_ROOT_PASSWORD	| my_wiki_pass |Tietokannan pääsalasana.|
|MYSQL_DATABASE |	my_wiki |Tämä on tietokannan nimi.|
|MYSQL_USER	| wikiuser |Wiki-tietokannan käyttäjänimi.|
|MYSQL_PASSWORD |	my_wiki_pass	|Wiki-tietokannan käyttäjän salasana.|
{{</table>}}
Lopuksi annan nämä neljä ympäristömuuttujaa:Katso:
{{< gallery match="images/6/*.png" >}}
Näiden asetusten jälkeen Mariadb-palvelin voidaan käynnistää! Painan "Apply" kaikkialla.
## Vaihe 3: Asenna Wiki.js
Napsautan Synology Docker -ikkunan "Rekisteröinti"-välilehteä ja etsin "wiki". Valitsen Docker-kuvan "requarks/wiki" ja napsautan sitten tagia "latest".
{{< gallery match="images/7/*.png" >}}
Kaksoisnapsautan WikiJS-kuvaani. Sitten napsautan "Lisäasetukset" ja aktivoin "Automaattinen uudelleenkäynnistys" myös tässä.
{{< gallery match="images/8/*.png" >}}
Määritän kiinteät portit WikiJS-säiliölle. Ilman kiinteitä portteja voi olla, että "bookstack-palvelin" toimii eri portissa uudelleenkäynnistyksen jälkeen.
{{< gallery match="images/9/*.png" >}}
Lisäksi on vielä luotava "linkki" "mysql"-säiliöön. Napsautan "Linkit"-välilehteä ja valitsen tietokantasäiliön. Alias-nimi on muistettava wikin asennusta varten.
{{< gallery match="images/10/*.png" >}}
{{<table "table table-striped table-bordered">}}
|Muuttujan nimi|Arvo|Mikä se on?|
|--- | --- |---|
|TZ	| Europe/Berlin	|Aikavyöhyke|
|DB_HOST	| wiki-db	|Alias-nimet / säiliölinkki|
|DB_TYPE	| mysql	||
|DB_PORT	| 3306	 ||
|DB_PASSWORD	| my_wiki	|Vaiheen 2 tiedot|
|DB_USER	| wikiuser |Vaiheen 2 tiedot|
|DB_PASS	| my_wiki_pass	|Vaiheen 2 tiedot|
{{</table>}}
Lopuksi annan nämä ympäristömuuttujat: Ks:
{{< gallery match="images/11/*.png" >}}
Säiliö voidaan nyt käynnistää. Kutsun Wiki.js-palvelinta Synologyn IP-osoitteella ja konttiportilla/3000.
{{< gallery match="images/12/*.png" >}}
