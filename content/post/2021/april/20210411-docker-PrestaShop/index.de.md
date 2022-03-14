+++
date = "2021-04-11"
title = "Kreativ aus der Krise: professioneller Webshop mit PrestaShop"
difficulty = "level-4"
tags = ["corona", "Docker", "docker-compose", "kreativ", "krise", "online-shop", "presta", "shop", "shopsystem"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/april/20210411-docker-PrestaShop/index.de.md"
+++

PrestaShop ist eine europäische Open-Source-E-Commerce-Plattform mit nach eigenen Angaben aktuell über 300.000 Installationen. Heute installiere ich diese PHP-Software auf meinem Server. Für dieses Tutorial wird etwas Linux-, Docker- und Docker-Compose- Wissen benötigt.

## Schritt 1: PrestaShop installieren
Ich erstelle ein neues Verzeichnis namens „prestashop“ auf meinem Server:
{{< terminal >}}
mkdir prestashop
cd prestashop
{{</ terminal >}}

Danach gehe ich in das prestashop–Verzeichnis und erstelle dort neue Datei namens „prestashop.yml“ mit folgendem Inhalt.
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

Leider hat die aktuelle Lastest-Version bei mir nicht funktioniert, darum habe ich die „1.7.7.2“-Version installiert. Diese Datei wird via Docker-Compose gestartet:
{{< terminal >}}
docker-compose -f prestashop.yml up
{{</ terminal >}}

Am besten holt man sich einen frischen Kaffee, denn der Vorgang dauert sehr lang. Erst wenn der folgende Text erscheint, kann das Interface genutzt werden.
{{< gallery match="images/1/*.png" >}}

Danach kann ich meinen PrestaShop-Server aufrufen und die Installation via Interface fortsetzen.
{{< gallery match="images/2/*.png" >}}

Ich beende Docker-Compose mit „Ctrl+C“ und rufe den Unterordner „prestadata“ auf („cd prestadata“). Dort muss der „install“-Ordner mit „rm -r install“ gelöscht werden. 
{{< gallery match="images/3/*.png" >}}

Außerdem ist dort ein „Admin“-Ordner zusehen, bei mir „admin697vqoryt“. Dieses Kürzel merke ich mir für später und starte den Server wieder via Docker-Compose:
{{< terminal >}}
docker-compose -f prestashop.yml up -d
{{</ terminal >}}

## Schritt 2: Shop testen
Nach dem Neustart teste ich meine Presta-Shop-installation durch und rufe auch das Admin-Interface unter „shop-url/Admin-Kürzel“ auf.
{{< gallery match="images/4/*.png" >}}