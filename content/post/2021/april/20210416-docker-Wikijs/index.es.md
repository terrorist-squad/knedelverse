+++
date = "2021-04-16"
title = "Grandes cosas con contenedores: Instalación de Wiki.js en el Synology Diskstation"
difficulty = "level-1"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "wikijs", "wiki"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/april/20210416-docker-Wikijs/index.es.md"
+++
Wiki.js es un potente software wiki de código abierto que convierte la documentación en un placer gracias a su sencilla interfaz. Hoy muestro cómo instalar un servicio Wiki.js en el Synology DiskStation.
## Opción para profesionales
Como usuario experimentado de Synology, puede, por supuesto, iniciar sesión con SSH e instalar toda la configuración a través del archivo Docker Compose.
```
version: '3'
services:
  wikijs:
    image: requarks/wiki:latest
    restart: always
    ports:
      - 8082:3000
    links:
      - database
    environment:
      DB_TYPE: mysql
      DB_HOST: database
      DB_PORT: 3306
      DB_NAME: my_wiki
      DB_USER: wikiuser
      DB_PASS: my_wiki_pass
      TZ: 'Europe/Berlin'

  database:
    image: mysql
    restart: always
    expose:
      - 3306
    volumes:
       - ./mysql:/var/lib/mysql
    environment:
      MYSQL_ROOT_PASSWORD: my_wiki_pass
      MYSQL_DATABASE: my_wiki
      MYSQL_USER: wikiuser
      MYSQL_PASSWORD: my_wiki_pass

```
Puedes encontrar más imágenes Docker útiles para uso doméstico en el Dockerverse.
## Paso 1: Preparar la carpeta wiki
Creo un nuevo directorio llamado "wiki" en el directorio de Docker.
{{< gallery match="images/1/*.png" >}}

## Paso 2: Instalar la base de datos
Después, hay que crear una base de datos. Hago clic en la pestaña "Registro" de la ventana de Synology Docker y busco "mysql". Selecciono la imagen Docker "mysql" y luego hago clic en la etiqueta "latest".
{{< gallery match="images/2/*.png" >}}
Después de la descarga de la imagen, ésta está disponible como imagen. Docker distingue entre 2 estados, contenedor "estado dinámico" e imagen (estado fijo). Antes de crear un contenedor a partir de la imagen, hay que hacer algunos ajustes. Hago doble clic en mi imagen mysql.
{{< gallery match="images/3/*.png" >}}
Luego hago clic en "Configuración avanzada" y activo el "Reinicio automático". Selecciono la pestaña "Volumen" y hago clic en "Añadir carpeta". Allí creo una nueva carpeta de base de datos con esta ruta de montaje "/var/lib/mysql".
{{< gallery match="images/4/*.png" >}}
En "Configuración de puertos" se eliminan todos los puertos. Esto significa que selecciono el puerto "3306" y lo borro con el botón "-".
{{< gallery match="images/5/*.png" >}}
{{<table "table table-striped table-bordered">}}
|Nombre de la variable|Valor|¿Qué es?|
|--- | --- |---|
|TZ	| Europe/Berlin |Zona horaria|
|MYSQL_ROOT_PASSWORD	| my_wiki_pass |Contraseña maestra de la base de datos.|
|MYSQL_DATABASE |	my_wiki |Este es el nombre de la base de datos.|
|MYSQL_USER	| wikiuser |Nombre de usuario de la base de datos del wiki.|
|MYSQL_PASSWORD |	my_wiki_pass	|Contraseña del usuario de la base de datos wiki.|
{{</table>}}
Por último, introduzco estas cuatro variables de entorno:Ver:
{{< gallery match="images/6/*.png" >}}
Después de estos ajustes, el servidor Mariadb puede ser iniciado. Presiono "Aplicar" en todas partes.
## Paso 3: Instalar Wiki.js
Hago clic en la pestaña "Registro" de la ventana de Synology Docker y busco "wiki". Selecciono la imagen Docker "requarks/wiki" y luego hago clic en la etiqueta "latest".
{{< gallery match="images/7/*.png" >}}
Hago doble clic en mi imagen WikiJS. Luego hago clic en "Configuración avanzada" y activo aquí también el "Reinicio automático".
{{< gallery match="images/8/*.png" >}}
Asigno puertos fijos para el contenedor "WikiJS". Sin puertos fijos, podría ser que el "servidor bookstack" se ejecute en un puerto diferente después de un reinicio.
{{< gallery match="images/9/*.png" >}}
Además, todavía hay que crear un "enlace" al contenedor "mysql". Hago clic en la pestaña "Enlaces" y selecciono el contenedor de la base de datos. El nombre del alias debe ser recordado para la instalación del wiki.
{{< gallery match="images/10/*.png" >}}
{{<table "table table-striped table-bordered">}}
|Nombre de la variable|Valor|¿Qué es?|
|--- | --- |---|
|TZ	| Europe/Berlin	|Zona horaria|
|DB_HOST	| wiki-db	|Nombres de alias / enlace de contenedor|
|DB_TYPE	| mysql	||
|DB_PORT	| 3306	 ||
|DB_PASSWORD	| my_wiki	|Datos del paso 2|
|DB_USER	| wikiuser |Datos del paso 2|
|DB_PASS	| my_wiki_pass	|Datos del paso 2|
{{</table>}}
Por último, introduzco estas variables de entorno:Ver:
{{< gallery match="images/11/*.png" >}}
El contenedor ya puede iniciarse. Llamo al servidor Wiki.js con la dirección IP del Synology y mi puerto contenedor/3000.
{{< gallery match="images/12/*.png" >}}