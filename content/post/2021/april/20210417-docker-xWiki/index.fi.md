+++
date = "2021-04-17"
title = "Suuria asioita konttien avulla: oman xWikin käyttäminen Synologyn levyasemalla"
difficulty = "level-1"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "xwiki", "wiki",]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/april/20210417-docker-xWiki/index.fi.md"
+++
XWiki on ilmainen wikiohjelmistoalusta, joka on kirjoitettu Javalla ja suunniteltu laajennettavuutta silmällä pitäen. Tänään näytän, miten xWiki-palvelu asennetaan Synology DiskStationiin.
## Vaihtoehto ammattilaisille
Kokeneena Synologyn käyttäjänä voit tietenkin kirjautua sisään SSH:lla ja asentaa koko asennuksen Docker Compose -tiedostolla.
```
version: '3'
services:
  xwiki:
    image: xwiki:10-postgres-tomcat
    restart: always
    ports:
      - 8080:8080
    links:
      - db
    environment:
      DB_HOST: db
      DB_DATABASE: xwiki
      DB_DATABASE: xwiki
      DB_PASSWORD: xwiki
      TZ: 'Europe/Berlin'

  db:
    image: postgres:latest
    restart: always
    volumes:
      - ./postgresql:/var/lib/postgresql/data
    environment:
      - POSTGRES_USER=xwiki
      - POSTGRES_PASSWORD=xwiki
      - POSTGRES_DB=xwiki
      - TZ='Europe/Berlin'

```
Lisää hyödyllisiä Docker-kuvia kotikäyttöön löytyy [Dockerverse]({{< ref "dockerverse" >}} "Dockerverse").
## Vaihe 1: Valmistele wikikansio
Luon Docker-hakemistoon uuden hakemiston nimeltä "wiki".
{{< gallery match="images/1/*.png" >}}

## Vaihe 2: Asenna tietokanta
Tämän jälkeen on luotava tietokanta. Napsautan Synology Docker -ikkunan "Rekisteröinti"-välilehteä ja etsin "postgres". Valitsen Docker-kuvan "postgres" ja napsautan sitten tagia "latest".
{{< gallery match="images/2/*.png" >}}
Kuvan lataamisen jälkeen kuva on käytettävissä kuvana. Dockerissa erotetaan kaksi tilaa, kontti (dynaaminen tila) ja kuva (kiinteä tila). Ennen kuin luomme kontin kuvasta, on tehtävä muutamia asetuksia. Kaksoisnapsautan postgres-kuvaani.
{{< gallery match="images/3/*.png" >}}
Sitten klikkaan "Lisäasetukset" ja aktivoin "Automaattinen uudelleenkäynnistys". Valitsen välilehden "Volume" ja napsautan "Add folder". Siellä luon uuden tietokantakansio, jossa on tämä liitäntäpolku "/var/lib/postgresql/data".
{{< gallery match="images/4/*.png" >}}
Porttiasetukset-kohdasta poistetaan kaikki portit. Tämä tarkoittaa, että valitsen portin "5432" ja poistan sen painikkeella "-".
{{< gallery match="images/5/*.png" >}}
{{<table "table table-striped table-bordered">}}
|Muuttujan nimi|Arvo|Mikä se on?|
|--- | --- |---|
|TZ	| Europe/Berlin	|Aikavyöhyke|
|POSTGRES_DB	| xwiki |Tämä on tietokannan nimi.|
|POSTGRES_USER	| xwiki |Wiki-tietokannan käyttäjänimi.|
|POSTGRES_PASSWORD	| xwiki |Wiki-tietokannan käyttäjän salasana.|
{{</table>}}
Lopuksi annan nämä neljä ympäristömuuttujaa:Katso:
{{< gallery match="images/6/*.png" >}}
Näiden asetusten jälkeen Mariadb-palvelin voidaan käynnistää! Painan "Apply" kaikkialla.
## Vaihe 3: Asenna xWiki
Napsautan Synology Docker -ikkunan "Rekisteröinti"-välilehteä ja etsin "xwiki". Valitsen Docker-kuvan "xwiki" ja napsautan sitten tagia "10-postgres-tomcat".
{{< gallery match="images/7/*.png" >}}
Kaksoisklikkaan xwiki-kuvaani. Sitten napsautan "Lisäasetukset" ja aktivoin "Automaattinen uudelleenkäynnistys" myös täällä.
{{< gallery match="images/8/*.png" >}}
Määritän kiinteät portit kontille "xwiki". Ilman kiinteitä portteja voi olla, että "xwiki-palvelin" toimii eri portissa uudelleenkäynnistyksen jälkeen.
{{< gallery match="images/9/*.png" >}}
Lisäksi on luotava linkki "postgres"-konttiin. Napsautan "Linkit"-välilehteä ja valitsen tietokantasäiliön. Alias-nimi on muistettava wikin asennusta varten.
{{< gallery match="images/10/*.png" >}}
{{<table "table table-striped table-bordered">}}
|Muuttujan nimi|Arvo|Mikä se on?|
|--- | --- |---|
|TZ |	Europe/Berlin	|Aikavyöhyke|
|DB_HOST	| db |Alias-nimet / säiliölinkki|
|DB_DATABASE	| xwiki	|Vaiheen 2 tiedot|
|DB_USER	| xwiki	|Vaiheen 2 tiedot|
|DB_PASSWORD	| xwiki |Vaiheen 2 tiedot|
{{</table>}}
Lopuksi annan nämä ympäristömuuttujat: Ks:
{{< gallery match="images/11/*.png" >}}
Säiliö voidaan nyt käynnistää. Kutsun xWiki-palvelinta Synologyn IP-osoitteella ja konttiportilla.
{{< gallery match="images/12/*.png" >}}