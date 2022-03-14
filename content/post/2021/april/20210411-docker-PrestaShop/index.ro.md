+++
date = "2021-04-11"
title = "Ieșirea creativă din criză: magazin web profesionist cu PrestaShop"
difficulty = "level-4"
tags = ["corona", "Docker", "docker-compose", "kreativ", "krise", "online-shop", "presta", "shop", "shopsystem"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/april/20210411-docker-PrestaShop/index.ro.md"
+++
PrestaShop este o platformă europeană de comerț electronic open source cu, conform propriilor informații, peste 300.000 de instalări în prezent. Astăzi instalez acest software PHP pe serverul meu. Pentru acest tutorial sunt necesare anumite cunoștințe despre Linux, Docker și Docker Compose.
## Pasul 1: Instalați PrestaShop
Creez un nou director numit "prestashop" pe serverul meu:
{{< terminal >}}
mkdir prestashop
cd prestashop

{{</ terminal >}}
Apoi, mă duc în directorul prestashop și creez un nou fișier numit "prestashop.yml" cu următorul conținut.
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
Din nefericire, ultima versiune actuală nu a funcționat pentru mine, așa că am instalat versiunea "1.7.7.7.2". Acest fișier este pornit prin Docker Compose:
{{< terminal >}}
docker-compose -f prestashop.yml up

{{</ terminal >}}
Cel mai bine este să obțineți o cafea proaspătă, deoarece procesul durează mult timp. Interfața poate fi utilizată numai atunci când apare următorul text.
{{< gallery match="images/1/*.png" >}}
Pot apoi să apelez la serverul meu PrestaShop și să continui instalarea prin intermediul interfeței.
{{< gallery match="images/2/*.png" >}}
Închei Docker-Compose cu "Ctrl C" și apelez la subfolderul "prestadata" ("cd prestadata"). Acolo, dosarul "install" trebuie șters cu "rm -r install".
{{< gallery match="images/3/*.png" >}}
În plus, există un dosar "Admin" acolo, în cazul meu "admin697vqoryt". Îmi amintesc această abreviere pentru mai târziu și pornesc din nou serverul prin Docker Compose:
{{< terminal >}}
docker-compose -f prestashop.yml up -d

{{</ terminal >}}

## Pasul 2: Testați magazinul
După repornire, testez instalarea magazinului meu Presta și, de asemenea, apelez la interfața de administrare sub "shop-url/admin shortcuts".
{{< gallery match="images/4/*.png" >}}