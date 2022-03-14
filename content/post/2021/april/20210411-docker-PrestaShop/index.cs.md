+++
date = "2021-04-11"
title = "Kreativní východisko z krize: profesionální webový obchod s PrestaShopem"
difficulty = "level-4"
tags = ["corona", "Docker", "docker-compose", "kreativ", "krise", "online-shop", "presta", "shop", "shopsystem"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210411-docker-PrestaShop/index.cs.md"
+++
PrestaShop je evropská open source platforma pro elektronické obchodování, která má podle vlastních údajů v současnosti více než 300 000 instalací. Dnes jsem nainstaloval tento software PHP na můj server. Pro tento výukový kurz jsou nutné určité znalosti Linuxu, Dockeru a Docker Compose.
## Krok 1: Instalace PrestaShopu
Na serveru vytvořím nový adresář s názvem "prestashop":
{{< terminal >}}
mkdir prestashop
cd prestashop

{{</ terminal >}}
Poté přejdu do adresáře prestashop a vytvořím nový soubor s názvem "prestashop.yml" s následujícím obsahem.
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
Bohužel mi aktuální verze Lastest nefungovala, takže jsem nainstaloval verzi "1.7.7.2". Tento soubor se spouští pomocí nástroje Docker Compose:
{{< terminal >}}
docker-compose -f prestashop.yml up

{{</ terminal >}}
Nejlepší je pořídit si čerstvou kávu, protože proces trvá dlouho. Rozhraní lze použít pouze tehdy, když se zobrazí následující text.
{{< gallery match="images/1/*.png" >}}
Poté mohu vyvolat svůj server PrestaShop a pokračovat v instalaci prostřednictvím rozhraní.
{{< gallery match="images/2/*.png" >}}
Ukončím Docker-Compose klávesou "Ctrl C" a vyvolám podsložku "prestadata" ("cd prestadata"). Tam je třeba smazat složku "install" příkazem "rm -r install".
{{< gallery match="images/3/*.png" >}}
Kromě toho je tam složka "Admin", v mém případě "admin697vqoryt". Tuto zkratku si zapamatuji na později a znovu spustím server pomocí nástroje Docker Compose:
{{< terminal >}}
docker-compose -f prestashop.yml up -d

{{</ terminal >}}

## Krok 2: Otestujte obchod
Po restartu otestuji instalaci obchodu Presta a také vyvolám rozhraní správce pod položkou "shop-url/admin shortcuts".
{{< gallery match="images/4/*.png" >}}