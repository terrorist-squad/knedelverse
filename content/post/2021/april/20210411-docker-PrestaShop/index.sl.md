+++
date = "2021-04-11"
title = "Kreativni izhod iz krize: profesionalna spletna trgovina s PrestaShopom"
difficulty = "level-4"
tags = ["corona", "Docker", "docker-compose", "kreativ", "krise", "online-shop", "presta", "shop", "shopsystem"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210411-docker-PrestaShop/index.sl.md"
+++
PrestaShop je evropska odprtokodna platforma za e-trgovino, ki je po lastnih podatkih trenutno nameščena v več kot 300.000 sistemih. Danes nameščam to programsko opremo PHP na svoj strežnik. Za to vadnico je potrebno nekaj znanja o Linuxu, Dockerju in Docker Compose.
## Korak 1: Namestite PrestaShop
Na strežniku ustvarim nov imenik z imenom "prestashop":
{{< terminal >}}
mkdir prestashop
cd prestashop

{{</ terminal >}}
Nato grem v imenik prestashop in ustvarim novo datoteko z imenom "prestashop.yml" z naslednjo vsebino.
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
Na žalost mi trenutna različica Lastest ni delovala, zato sem namestil različico "1.7.7.7.2". Ta datoteka se zažene prek programa Docker Compose:
{{< terminal >}}
docker-compose -f prestashop.yml up

{{</ terminal >}}
Najbolje je kupiti svežo kavo, saj postopek traja dlje časa. Vmesnik lahko uporabljate le, če je prikazano naslednje besedilo.
{{< gallery match="images/1/*.png" >}}
Nato lahko pokličem strežnik PrestaShop in nadaljujem namestitev prek vmesnika.
{{< gallery match="images/2/*.png" >}}
Program Docker-Compose končam s "Ctrl C" in prikličem podmapo "prestadata" ("cd prestadata"). Tam je treba mapo "install" izbrisati z ukazom "rm -r install".
{{< gallery match="images/3/*.png" >}}
Poleg tega je tam tudi mapa "Admin", v mojem primeru "admin697vqoryt". To okrajšavo si zapomnim za pozneje in znova zaženem strežnik prek programa Docker Compose:
{{< terminal >}}
docker-compose -f prestashop.yml up -d

{{</ terminal >}}

## Korak 2: Preizkus trgovine
Po ponovnem zagonu preizkusim namestitev trgovine Presta in prikličem tudi skrbniški vmesnik pod "shop-url/admin shortcuts".
{{< gallery match="images/4/*.png" >}}
