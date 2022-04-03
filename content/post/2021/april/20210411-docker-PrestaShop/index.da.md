+++
date = "2021-04-11"
title = "Kreativ ud af krisen: professionel webshop med PrestaShop"
difficulty = "level-4"
tags = ["corona", "Docker", "docker-compose", "kreativ", "krise", "online-shop", "presta", "shop", "shopsystem"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210411-docker-PrestaShop/index.da.md"
+++
PrestaShop er en europæisk open source e-handelsplatform med, ifølge deres egne oplysninger, i øjeblikket over 300.000 installationer. I dag er jeg ved at installere denne PHP-software på min server. Der kræves en vis viden om Linux, Docker og Docker Compose for at kunne bruge denne vejledning.
## Trin 1: Installer PrestaShop
Jeg opretter en ny mappe med navnet "prestashop" på min server:
{{< terminal >}}
mkdir prestashop
cd prestashop

{{</ terminal >}}
Derefter går jeg ind i prestashop-mappen og opretter en ny fil med navnet "prestashop.yml" med følgende indhold.
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
Desværre virkede den aktuelle Lastest-version ikke for mig, så jeg installerede "1.7.7.7.2"-versionen. Denne fil startes via Docker Compose:
{{< terminal >}}
docker-compose -f prestashop.yml up

{{</ terminal >}}
Det er bedst at få frisk kaffe, da processen tager lang tid. Grænsefladen kan kun bruges, når følgende tekst vises.
{{< gallery match="images/1/*.png" >}}
Jeg kan derefter ringe til min PrestaShop-server og fortsætte installationen via grænsefladen.
{{< gallery match="images/2/*.png" >}}
Jeg afslutter Docker-Compose med "Ctrl C" og kalder undermappen "prestadata" op ("cd prestadata"). Her skal mappen "install" slettes med "rm -r install".
{{< gallery match="images/3/*.png" >}}
Desuden er der en "Admin"-mappe der, i mit tilfælde "admin697vqoryt". Jeg husker denne forkortelse til senere og starter serveren igen via Docker Compose:
{{< terminal >}}
docker-compose -f prestashop.yml up -d

{{</ terminal >}}

## Trin 2: Test butikken
Efter genstarten tester jeg min Presta shop-installation og kalder også admin-grænsefladen under "shop-url/admin shortcuts".
{{< gallery match="images/4/*.png" >}}
