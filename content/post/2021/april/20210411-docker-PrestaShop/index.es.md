+++
date = "2021-04-11"
title = "Creatividad para salir de la crisis: tienda web profesional con PrestaShop"
difficulty = "level-4"
tags = ["corona", "Docker", "docker-compose", "kreativ", "krise", "online-shop", "presta", "shop", "shopsystem"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/april/20210411-docker-PrestaShop/index.es.md"
+++
PrestaShop es una plataforma europea de comercio electrónico de código abierto que, según sus propios datos, cuenta actualmente con más de 300.000 instalaciones. Hoy estoy instalando este software PHP en mi servidor. Para este tutorial se requieren algunos conocimientos de Linux, Docker y Docker Compose.
## Paso 1: Instalar PrestaShop
Creo un nuevo directorio llamado "prestashop" en mi servidor:
{{< terminal >}}
mkdir prestashop
cd prestashop

{{</ terminal >}}
Luego voy al directorio de prestashop y creo un nuevo archivo llamado "prestashop.yml" con el siguiente contenido.
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
Lamentablemente, la versión actual Lastest no me funcionó, así que instalé la versión "1.7.7.2". Este archivo se inicia a través de Docker Compose:
{{< terminal >}}
docker-compose -f prestashop.yml up

{{</ terminal >}}
Es mejor conseguir un café fresco, porque el proceso lleva mucho tiempo. La interfaz sólo puede utilizarse cuando aparece el siguiente texto.
{{< gallery match="images/1/*.png" >}}
A continuación, puedo llamar a mi servidor de PrestaShop y continuar la instalación a través de la interfaz.
{{< gallery match="images/2/*.png" >}}
Termino Docker-Compose con "Ctrl C" y llamo a la subcarpeta "prestadata" ("cd prestadata"). Allí hay que borrar la carpeta "install" con "rm -r install".
{{< gallery match="images/3/*.png" >}}
Además, allí hay una carpeta "Admin", en mi caso "admin697vqoryt". Me acuerdo de esta abreviatura para más tarde e inicio el servidor de nuevo a través de Docker Compose:
{{< terminal >}}
docker-compose -f prestashop.yml up -d

{{</ terminal >}}

## Paso 2: Probar la tienda
Tras el reinicio, pruebo la instalación de mi tienda Presta y también llamo a la interfaz de administración en "shop-url/admin shortcuts".
{{< gallery match="images/4/*.png" >}}