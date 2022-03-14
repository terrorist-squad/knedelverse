+++
date = "2021-04-11"
title = "Kreatívan ki a válságból: professzionális webshop a PrestaShop segítségével"
difficulty = "level-4"
tags = ["corona", "Docker", "docker-compose", "kreativ", "krise", "online-shop", "presta", "shop", "shopsystem"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/april/20210411-docker-PrestaShop/index.hu.md"
+++
A PrestaShop egy európai nyílt forráskódú e-kereskedelmi platform, amely saját információi szerint jelenleg több mint 300 000 telepítéssel rendelkezik. Ma telepítem ezt a PHP-szoftvert a szerveremre. Ehhez a bemutatóhoz szükséges némi Linux, Docker és Docker Compose ismeret.
## 1. lépés: Telepítse a PrestaShopot
Létrehozok egy új könyvtárat "prestashop" néven a szerveremen:
{{< terminal >}}
mkdir prestashop
cd prestashop

{{</ terminal >}}
Ezután bemegyek a prestashop könyvtárba, és létrehozok egy új fájlt "prestashop.yml" néven a következő tartalommal.
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
Sajnos a jelenlegi Lastest verzió nem működött nálam, ezért telepítettem az "1.7.7.7.2" verziót. Ez a fájl a Docker Compose segítségével indul:
{{< terminal >}}
docker-compose -f prestashop.yml up

{{</ terminal >}}
A legjobb, ha friss kávét veszünk, mert a folyamat sokáig tart. A felület csak akkor használható, ha a következő szöveg jelenik meg.
{{< gallery match="images/1/*.png" >}}
Ezután felhívhatom a PrestaShop szerveremet, és folytathatom a telepítést a felületen keresztül.
{{< gallery match="images/2/*.png" >}}
A Docker-Compose-t a "Ctrl C" billentyűvel fejezem be, és meghívom a "prestadata" almappát ("cd prestadata"). Ott az "install" mappát az "rm -r install" paranccsal kell törölni.
{{< gallery match="images/3/*.png" >}}
Ezenkívül van ott egy "Admin" mappa, az én esetemben "admin697vqoryt". Ezt a rövidítést megjegyzem későbbre, és újra elindítom a szervert a Docker Compose-on keresztül:
{{< terminal >}}
docker-compose -f prestashop.yml up -d

{{</ terminal >}}

## 2. lépés: Tesztelje a boltot
Az újraindítás után tesztelem a Presta shop telepítését, és a "shop-url/admin parancsikonok" alatt az admin felületet is meghívom.
{{< gallery match="images/4/*.png" >}}