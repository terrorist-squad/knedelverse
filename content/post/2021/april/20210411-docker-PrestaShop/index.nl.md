+++
date = "2021-04-11"
title = "Creatief uit de crisis: professionele webshop met PrestaShop"
difficulty = "level-4"
tags = ["corona", "Docker", "docker-compose", "kreativ", "krise", "online-shop", "presta", "shop", "shopsystem"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210411-docker-PrestaShop/index.nl.md"
+++
PrestaShop is een Europees open source e-commerce platform met, volgens de eigen informatie, momenteel meer dan 300.000 installaties. Vandaag installeer ik deze PHP software op mijn server. Enige kennis van Linux, Docker en Docker Compose is vereist voor deze tutorial.
## Stap 1: Installeer PrestaShop
Ik maak een nieuwe map genaamd "prestashop" op mijn server:
{{< terminal >}}
mkdir prestashop
cd prestashop

{{</ terminal >}}
Dan ga ik in de prestashop directory en maak een nieuw bestand genaamd "prestashop.yml" met de volgende inhoud.
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
Helaas, de huidige Lastest versie werkte niet voor mij, dus installeerde ik de "1.7.7.2" versie. Dit bestand wordt gestart via Docker Compose:
{{< terminal >}}
docker-compose -f prestashop.yml up

{{</ terminal >}}
Het is het beste om een verse koffie te halen, want het proces duurt lang. De interface kan alleen worden gebruikt als de volgende tekst verschijnt.
{{< gallery match="images/1/*.png" >}}
Ik kan dan mijn PrestaShop server oproepen en de installatie voortzetten via de interface.
{{< gallery match="images/2/*.png" >}}
Ik sluit Docker-Compose af met "Ctrl C" en roep de submap "prestadata" op ("cd prestadata"). Daar moet de "install" map verwijderd worden met "rm -r install".
{{< gallery match="images/3/*.png" >}}
Bovendien is er een "Admin" map, in mijn geval "admin697vqoryt". Ik onthoud deze afkorting voor later en start de server opnieuw via Docker Compose:
{{< terminal >}}
docker-compose -f prestashop.yml up -d

{{</ terminal >}}

## Stap 2: Test de winkel
Na de herstart, test ik mijn Presta shop installatie en roep ook de admin interface op onder "shop-url/admin shortcuts".
{{< gallery match="images/4/*.png" >}}
