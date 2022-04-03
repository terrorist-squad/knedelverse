+++
date = "2021-04-11"
title = "Creativi fuori dalla crisi: webshop professionale con PrestaShop"
difficulty = "level-4"
tags = ["corona", "Docker", "docker-compose", "kreativ", "krise", "online-shop", "presta", "shop", "shopsystem"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210411-docker-PrestaShop/index.it.md"
+++
PrestaShop è una piattaforma europea di e-commerce open source con, secondo le sue stesse informazioni, attualmente più di 300.000 installazioni. Oggi sto installando questo software PHP sul mio server. Per questo tutorial è richiesta una certa conoscenza di Linux, Docker e Docker Compose.
## Passo 1: installare PrestaShop
Creo una nuova directory chiamata "prestashop" sul mio server:
{{< terminal >}}
mkdir prestashop
cd prestashop

{{</ terminal >}}
Poi vado nella directory prestashop e creo un nuovo file chiamato "prestashop.yml" con il seguente contenuto.
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
Purtroppo, l'attuale versione Lastest non ha funzionato per me, così ho installato la versione "1.7.7.2". Questo file viene avviato tramite Docker Compose:
{{< terminal >}}
docker-compose -f prestashop.yml up

{{</ terminal >}}
È meglio ottenere un caffè fresco, perché il processo richiede molto tempo. L'interfaccia può essere utilizzata solo quando appare il seguente testo.
{{< gallery match="images/1/*.png" >}}
Posso quindi richiamare il mio server PrestaShop e continuare l'installazione tramite l'interfaccia.
{{< gallery match="images/2/*.png" >}}
Termino Docker-Compose con "Ctrl C" e richiamo la sottocartella "prestadata" ("cd prestadata"). Lì, la cartella "install" deve essere cancellata con "rm -r install".
{{< gallery match="images/3/*.png" >}}
Inoltre, c'è una cartella "Admin" lì, nel mio caso "admin697vqoryt". Ricordo questa abbreviazione per dopo e avvio nuovamente il server tramite Docker Compose:
{{< terminal >}}
docker-compose -f prestashop.yml up -d

{{</ terminal >}}

## Passo 2: Testare il negozio
Dopo il riavvio, provo l'installazione del mio negozio Presta e richiamo anche l'interfaccia amministrativa sotto "shop-url/admin shortcuts".
{{< gallery match="images/4/*.png" >}}
