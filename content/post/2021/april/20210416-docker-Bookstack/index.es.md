+++
date = "2021-04-16"
title = "Grandes cosas con contenedores: su propio Bookstack Wiki en el Synology DiskStation"
difficulty = "level-1"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "bookstack", "wiki"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210416-docker-Bookstack/index.es.md"
+++
Bookstack es una alternativa de "código abierto" a MediaWiki o Confluence. Hoy muestro cómo instalar un servicio Bookstack en la estación de disco Synology.
## Opción para profesionales
Como usuario experimentado de Synology, puede, por supuesto, iniciar sesión con SSH e instalar toda la configuración a través del archivo Docker Compose.
```
version: '3'
services:
  bookstack:
    image: solidnerd/bookstack:0.27.4-1
    restart: always
    ports:
      - 8080:8080
    links:
      - database
    environment:
      DB_HOST: database:3306
      DB_DATABASE: my_wiki
      DB_USERNAME: wikiuser
      DB_PASSWORD: my_wiki_pass
      
  database:
    image: mariadb
    restart: always
    volumes:
       - ./mysql:/var/lib/mysql
    environment:
      MYSQL_ROOT_PASSWORD: my_wiki_pass1
      MYSQL_DATABASE: my_wiki
      MYSQL_USER: wikiuser
      MYSQL_PASSWORD: my_wiki_pass

```
Se pueden encontrar más imágenes Docker útiles para uso doméstico en la página web [Dockerverse]({{< ref "dockerverse" >}} "Dockerverse").
## Paso 1: Preparar la carpeta de la pila de libros
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
|TZ	| Europe/Berlin |Zona horaria|
|MYSQL_ROOT_PASSWORD	|  my_wiki_pass |Contraseña maestra de la base de datos.|
|MYSQL_DATABASE | 	my_wiki	|Este es el nombre de la base de datos.|
|MYSQL_USER	|  wikiuser	|Nombre de usuario de la base de datos del wiki.|
|MYSQL_PASSWORD	|  my_wiki_pass	|Contraseña del usuario de la base de datos wiki.|
{{</table>}}
Por último, introduzco estas variables de entorno:Ver:
{{< gallery match="images/6/*.png" >}}
Después de estos ajustes, el servidor Mariadb puede ser iniciado. Presiono "Aplicar" en todas partes.
## Paso 3: Instalar Bookstack
Hago clic en la pestaña "Registro" de la ventana de Synology Docker y busco "bookstack". Selecciono la imagen Docker "solidnerd/bookstack" y luego hago clic en la etiqueta "latest".
{{< gallery match="images/7/*.png" >}}
Hago doble clic en mi imagen de Bookstack. Luego hago clic en "Configuración avanzada" y activo aquí también el "Reinicio automático".
{{< gallery match="images/8/*.png" >}}
Asigno puertos fijos para el contenedor "bookstack". Sin puertos fijos, podría ser que el "servidor bookstack" se ejecute en un puerto diferente después de un reinicio. El primer puerto de contenedores puede ser eliminado. Hay que recordar el otro puerto.
{{< gallery match="images/9/*.png" >}}
Además, todavía hay que crear un "enlace" al contenedor "mariadb". Hago clic en la pestaña "Enlaces" y selecciono el contenedor de la base de datos. El nombre del alias debe ser recordado para la instalación del wiki.
{{< gallery match="images/10/*.png" >}}
{{<table "table table-striped table-bordered">}}
|Nombre de la variable|Valor|¿Qué es?|
|--- | --- |---|
|TZ	| Europe/Berlin |Zona horaria|
|DB_HOST	| wiki-db:3306	|Nombres de alias / enlace de contenedor|
|DB_DATABASE	| my_wiki |Datos del paso 2|
|DB_USERNAME	| wikiuser |Datos del paso 2|
|DB_PASSWORD	| my_wiki_pass	|Datos del paso 2|
{{</table>}}
Por último, introduzco estas variables de entorno:Ver:
{{< gallery match="images/11/*.png" >}}
El contenedor ya puede iniciarse. La creación de la base de datos puede llevar algún tiempo. El comportamiento se puede observar a través de los detalles del contenedor.
{{< gallery match="images/12/*.png" >}}
Llamo al servidor Bookstack con la dirección IP del Synology y el puerto de mi contenedor. El nombre de usuario es "admin@admin.com" y la contraseña es "password".
{{< gallery match="images/13/*.png" >}}
