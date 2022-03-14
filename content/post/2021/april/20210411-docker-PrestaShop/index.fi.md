+++
date = "2021-04-11"
title = "Luova ulos kriisistä: ammattimainen verkkokauppa PrestaShopilla"
difficulty = "level-4"
tags = ["corona", "Docker", "docker-compose", "kreativ", "krise", "online-shop", "presta", "shop", "shopsystem"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210411-docker-PrestaShop/index.fi.md"
+++
PrestaShop on eurooppalainen avoimen lähdekoodin verkkokauppa-alusta, jolla on sen omien tietojen mukaan tällä hetkellä yli 300 000 asennusta. Asennan tänään tämän PHP-ohjelmiston palvelimelleni. Tämä opetusohjelma edellyttää jonkin verran Linux-, Docker- ja Docker Compose -tietämystä.
## Vaihe 1: Asenna PrestaShop
Luon palvelimelle uuden hakemiston nimeltä "prestashop":
{{< terminal >}}
mkdir prestashop
cd prestashop

{{</ terminal >}}
Sitten menen prestashop-hakemistoon ja luon uuden tiedoston nimeltä "prestashop.yml", jonka sisältö on seuraava.
```
version: '2'

services:
  mariadb:
    image: mysql:5.7
    environment:
      - MYSQL_ROOT_PASSWORD=admin
      - MYSQL_DATABASE=prestashop
      - MYSQL_USER=prestashop
      - MYSQL_PASSWORD=prestashop
    volumes:
      - ./mysql:/var/lib/mysql
    expose:
      - 3306
    networks:
      - shop-network
    restart: always

  prestashop:
    image: prestashop/prestashop:1.7.7.2
    ports:
      - 8090:80
    depends_on:
      - mariadb
    volumes:
      - ./prestadata:/var/www/html
      - ./prestadata/modules:/var/www/html/modules
      - ./prestadata/themes:/var/www/html/themes
      - ./prestadata/override:/var/www/html/override
    environment:
      - PS_INSTALL_AUTO=0
    networks:
      - shop-network
    restart: always

networks:
  shop-network:

```
Valitettavasti nykyinen uusin versio ei toiminut minulle, joten asensin version "1.7.7.7.2". Tämä tiedosto käynnistetään Docker Composen kautta:
{{< terminal >}}
docker-compose -f prestashop.yml up

{{</ terminal >}}
On parasta hankkia tuoretta kahvia, koska prosessi kestää kauan. Käyttöliittymää voidaan käyttää vain, kun seuraava teksti näkyy.
{{< gallery match="images/1/*.png" >}}
Sen jälkeen voin kutsua PrestaShop-palvelimeni ja jatkaa asennusta käyttöliittymän kautta.
{{< gallery match="images/2/*.png" >}}
Lopetan Docker-Composen painamalla "Ctrl C" ja kutsun alikansion "prestadata" ("cd prestadata"). Siellä "install"-kansio on poistettava komennolla "rm -r install".
{{< gallery match="images/3/*.png" >}}
Lisäksi siellä on "Admin"-kansio, minun tapauksessani "admin697vqoryt". Muistan tämän lyhenteen myöhempää käyttöä varten ja käynnistän palvelimen uudelleen Docker Composen kautta:
{{< terminal >}}
docker-compose -f prestashop.yml up -d

{{</ terminal >}}

## Vaihe 2: Testaa myymälä
Uudelleenkäynnistyksen jälkeen testaan Presta-myymäläni asennuksen ja kutsun myös hallintakäyttöliittymän "shop-url/admin-pikakuvakkeet" -kohdasta.
{{< gallery match="images/4/*.png" >}}