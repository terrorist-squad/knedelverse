+++
date = "2021-04-11"
title = "Kreatívne z krízy: profesionálny internetový obchod s PrestaShop"
difficulty = "level-4"
tags = ["corona", "Docker", "docker-compose", "kreativ", "krise", "online-shop", "presta", "shop", "shopsystem"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/april/20210411-docker-PrestaShop/index.sk.md"
+++
PrestaShop je európska open source platforma elektronického obchodu, ktorá má podľa vlastných informácií v súčasnosti viac ako 300 000 inštalácií. Dnes inštalujem tento softvér PHP na svoj server. Pre tento návod sú potrebné určité znalosti o Linuxe, Dockeri a Docker Compose.
## Krok 1: Inštalácia PrestaShop
Na serveri vytvorím nový adresár s názvom "prestashop":
{{< terminal >}}
mkdir prestashop
cd prestashop

{{</ terminal >}}
Potom prejdem do adresára prestashop a vytvorím nový súbor s názvom "prestashop.yml" s nasledujúcim obsahom.
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
Bohužiaľ, aktuálna najnovšia verzia mi nefungovala, takže som nainštaloval verziu "1.7.7.2". Tento súbor sa spúšťa prostredníctvom nástroja Docker Compose:
{{< terminal >}}
docker-compose -f prestashop.yml up

{{</ terminal >}}
Najlepšie je zaobstarať si čerstvú kávu, pretože proces trvá dlho. Rozhranie je možné používať len vtedy, keď sa zobrazí nasledujúci text.
{{< gallery match="images/1/*.png" >}}
Potom môžem vyvolať svoj server PrestaShop a pokračovať v inštalácii prostredníctvom rozhrania.
{{< gallery match="images/2/*.png" >}}
Program Docker-Compose ukončím klávesom Ctrl C a vyvolám podpriečinok "prestadata" ("cd prestadata"). V ňom je potrebné odstrániť priečinok "install" príkazom "rm -r install".
{{< gallery match="images/3/*.png" >}}
Okrem toho je tam priečinok "Admin", v mojom prípade "admin697vqoryt". Túto skratku si zapamätám na neskôr a spustím server znova cez Docker Compose:
{{< terminal >}}
docker-compose -f prestashop.yml up -d

{{</ terminal >}}

## Krok 2: Otestujte obchod
Po reštarte otestujem svoju inštaláciu obchodu Presta a tiež vyvolám administrátorské rozhranie v časti "shop-url/admin shortcuts".
{{< gallery match="images/4/*.png" >}}