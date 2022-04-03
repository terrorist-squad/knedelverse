+++
date = "2021-04-18"
title = "Grandes cosas con los contenedores: WallaBag propio en la estación de discos Synology"
difficulty = "level-1"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "archiv", "wallabag"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210418-docker-WallaBag/index.es.md"
+++
Wallabag es un programa para archivar páginas web o artículos interesantes. Hoy muestro cómo instalar un servicio Wallabag en la estación de disco Synology.
## Opción para profesionales
Como usuario experimentado de Synology, puede, por supuesto, iniciar sesión con SSH e instalar toda la configuración a través del archivo Docker Compose.
```
version: '3'
services:
  wallabag:
    image: wallabag/wallabag
    environment:
      - MYSQL_ROOT_PASSWORD=wallaroot
      - SYMFONY__ENV__DATABASE_DRIVER=pdo_mysql
      - SYMFONY__ENV__DATABASE_HOST=db
      - SYMFONY__ENV__DATABASE_PORT=3306
      - SYMFONY__ENV__DATABASE_NAME=wallabag
      - SYMFONY__ENV__DATABASE_USER=wallabag
      - SYMFONY__ENV__DATABASE_PASSWORD=wallapass
      - SYMFONY__ENV__DATABASE_CHARSET=utf8mb4
      - SYMFONY__ENV__DOMAIN_NAME=http://192.168.178.50:8089
      - SYMFONY__ENV__SERVER_NAME="Your wallabag instance"
      - SYMFONY__ENV__FOSUSER_CONFIRMATION=false
      - SYMFONY__ENV__TWOFACTOR_AUTH=false
    ports:
      - "8089:80"
    volumes:
      - ./wallabag/images:/var/www/wallabag/web/assets/images

  db:
    image: mariadb
    environment:
      - MYSQL_ROOT_PASSWORD=wallaroot
    volumes:
      - ./mariadb:/var/lib/mysql

```
Se pueden encontrar más imágenes Docker útiles para uso doméstico en la página web [Dockerverse]({{< ref "dockerverse" >}} "Dockerverse").
## Paso 1: Preparar la carpeta del bolso de pared
Creo un nuevo directorio llamado "wallabag" en el directorio Docker.
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
|TZ| Europe/Berlin	|Zona horaria|
|MYSQL_ROOT_PASSWORD	 | wallaroot |Contraseña maestra de la base de datos.|
{{</table>}}
Por último, introduzco estas variables de entorno:Ver:
{{< gallery match="images/6/*.png" >}}
Después de estos ajustes, el servidor Mariadb puede ser iniciado. Presiono "Aplicar" en todas partes.
{{< gallery match="images/7/*.png" >}}

## Paso 3: Instalar Wallabag
Hago clic en la pestaña "Registro" de la ventana de Synology Docker y busco "wallabag". Selecciono la imagen Docker "wallabag/wallabag" y luego hago clic en la etiqueta "latest".
{{< gallery match="images/8/*.png" >}}
Hago doble clic en la imagen de mi bolso de pared. Luego hago clic en "Configuración avanzada" y activo aquí también el "Reinicio automático".
{{< gallery match="images/9/*.png" >}}
Selecciono la pestaña "Volumen" y hago clic en "Añadir carpeta". Allí creo una nueva carpeta con esta ruta de montaje "/var/www/wallabag/web/assets/images".
{{< gallery match="images/10/*.png" >}}
Asigno puertos fijos para el contenedor "wallabag". Sin puertos fijos, podría ser que el "servidor wallabag" se ejecute en un puerto diferente después de un reinicio. El primer puerto de contenedores puede ser eliminado. Hay que recordar el otro puerto.
{{< gallery match="images/11/*.png" >}}
Además, todavía hay que crear un "enlace" al contenedor "mariadb". Hago clic en la pestaña "Enlaces" y selecciono el contenedor de la base de datos. El nombre del alias debe ser recordado para la instalación de wallabag.
{{< gallery match="images/12/*.png" >}}
{{<table "table table-striped table-bordered">}}
|Umgebungsvariable	|Valor|
|--- |---|
|MYSQL_ROOT_PASSWORD	|wallaroot|
|SYMFONY__ENV__DATABASE_DRIVER	|pdo_mysql|
|SYMFONY__ENV__DATABASE_HOST	|db|
|SYMFONY__ENV__DATABASE_PORT	|3306|
|SYMFONY__ENV__DATABASE_NAME	|bolsa de pared|
|SYMFONY__ENV__DATABASE_USER	|bolsa de pared|
|SYMFONY__ENV__DATABASE_PASSWORD	|wallapass|
|SYMFONY__ENV__DATABASE_CHARSET |utf8mb4|
|SYMFONY__ENV__DOMAIN_NAME	|"http://synology-ip:container-port" <- Por favor, cambie|
|SYMFONY__ENV__SERVER_NAME	|"Wallabag - Servidor"|
|SYMFONY__ENV__FOSUSER_CONFIRMATION	|falso|
|SYMFONY__ENV__TWOFACTOR_AUTH	|falso|
{{</table>}}
Por último, introduzco estas variables de entorno:Ver:
{{< gallery match="images/13/*.png" >}}
El contenedor ya puede iniciarse. La creación de la base de datos puede llevar algún tiempo. El comportamiento se puede observar a través de los detalles del contenedor.
{{< gallery match="images/14/*.png" >}}
Llamo al servidor wallabag con la dirección IP del Synology y el puerto de mi contenedor.
{{< gallery match="images/15/*.png" >}}
Sin embargo, debo decir que personalmente prefiero shiori como archivo de Internet.
