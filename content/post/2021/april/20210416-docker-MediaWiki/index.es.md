+++
date = "2021-04-16"
title = "Grandes cosas con contenedores: Instalar tu propio MediaWiki en la estación de disco Synology"
difficulty = "level-1"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "mediawiki", "wiki"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210416-docker-MediaWiki/index.es.md"
+++
MediaWiki es un sistema wiki basado en PHP que está disponible gratuitamente como producto de código abierto. Hoy muestro cómo instalar un servicio MediaWiki en la estación de disco Synology.
## Opción para profesionales
Como usuario experimentado de Synology, puede, por supuesto, iniciar sesión con SSH e instalar toda la configuración a través del archivo Docker Compose.
```
version: '3'
services:
  mediawiki:
    image: mediawiki
    restart: always
    ports:
      - 8081:80
    links:
      - database
    volumes:
      - ./images:/var/www/html/images
      # After initial setup, download LocalSettings.php to the same directory as
      # this yaml and uncomment the following line and use compose to restart
      # the mediawiki service
      # - ./LocalSettings.php:/var/www/html/LocalSettings.php

  database:
    image: mariadb
    restart: always
    volumes:
       - ./mysql:/var/lib/mysql
    environment:
      # @see https://phabricator.wikimedia.org/source/mediawiki/browse/master/includes/DefaultSettings.php
      MYSQL_ROOT_PASSWORD: my_wiki_pass1
      MYSQL_DATABASE: my_wiki
      MYSQL_USER: wikiuser
      MYSQL_PASSWORD: my_wiki_pass

```
Se pueden encontrar más imágenes Docker útiles para uso doméstico en la página web [Dockerverse]({{< ref "dockerverse" >}} "Dockerverse").
## Paso 1: Preparar la carpeta MediaWiki
Creo un nuevo directorio llamado "wiki" en el directorio de Docker.
{{< gallery match="images/1/*.png" >}}

## Paso 2: Instalar la base de datos
Después, hay que crear una base de datos. Hago clic en la pestaña "Registro" de la ventana de Synology Docker y busco "mariadb". Selecciono la imagen Docker "mariadb" y luego hago clic en la etiqueta "latest".
{{< gallery match="images/2/*.png" >}}
Después de la descarga de la imagen, ésta está disponible como imagen. Docker distingue entre 2 estados, contenedor "estado dinámico" e imagen (estado fijo). Antes de crear un contenedor a partir de la imagen, hay que hacer algunos ajustes. Hago doble clic en mi imagen mariadb.
{{< gallery match="images/3/*.png" >}}
Luego hago clic en "Configuración avanzada" y activo el "Reinicio automático". Selecciono la pestaña "Volumen" y hago clic en "Añadir carpeta". Allí creo una nueva carpeta de base de datos con esta ruta de montaje "/var/lib/mysql".
{{< gallery match="images/4/*.png" >}}
En "Configuración de puertos" se eliminan todos los puertos. Esto significa que selecciono el puerto "3306" y lo borro con el botón "-".
{{< gallery match="images/5/*.png" >}}
{{<table "table table-striped table-bordered">}}
|Nombre de la variable|Valor|¿Qué es?|
|--- | --- |---|
|TZ	| Europe/Berlin	|Zona horaria|
|MYSQL_ROOT_PASSWORD	| my_wiki_pass	|Contraseña maestra de la base de datos.|
|MYSQL_DATABASE |	my_wiki	|Este es el nombre de la base de datos.|
|MYSQL_USER	| wikiuser |Nombre de usuario de la base de datos del wiki.|
|MYSQL_PASSWORD	| my_wiki_pass |Contraseña del usuario de la base de datos wiki.|
{{</table>}}
Por último, introduzco estas variables de entorno:Ver:
{{< gallery match="images/6/*.png" >}}
Después de estos ajustes, el servidor Mariadb puede ser iniciado. Presiono "Aplicar" en todas partes.
## Paso 3: Instalar MediaWiki
Hago clic en la pestaña "Registro" de la ventana de Synology Docker y busco "mediawiki". Selecciono la imagen Docker "mediawiki" y luego hago clic en la etiqueta "latest".
{{< gallery match="images/7/*.png" >}}
Hago doble clic en mi imagen de Mediawiki.
{{< gallery match="images/8/*.png" >}}
Luego hago clic en "Configuración avanzada" y activo aquí también el "Reinicio automático". Selecciono la pestaña "Volumen" y hago clic en "Añadir carpeta". Allí creo una nueva carpeta con esta ruta de montaje "/var/www/html/images".
{{< gallery match="images/9/*.png" >}}
Asigno puertos fijos para el contenedor "MediaWiki". Sin puertos fijos, podría ser que el "servidor MediaWiki" se ejecute en un puerto diferente después de un reinicio.
{{< gallery match="images/10/*.png" >}}
Además, todavía hay que crear un "enlace" al contenedor "mariadb". Hago clic en la pestaña "Enlaces" y selecciono el contenedor de la base de datos. El nombre del alias debe ser recordado para la instalación del wiki.
{{< gallery match="images/11/*.png" >}}
Por último, introduzco una variable de entorno "TZ" con valor "Europa/Berlín".
{{< gallery match="images/12/*.png" >}}
El contenedor ya puede iniciarse. Llamo al servidor Mediawiki con la dirección IP del Synology y el puerto de mi contenedor. En Servidor de base de datos introduzco el nombre del alias del contenedor de la base de datos. También introduzco el nombre de la base de datos, el nombre de usuario y la contraseña del "Paso 2".
{{< gallery match="images/13/*.png" >}}
