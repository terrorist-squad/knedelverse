+++
date = "2021-04-17"
title = "Grandes cosas con contenedores: ejecutar su propio xWiki en la estación de disco de Synology"
difficulty = "level-1"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "xwiki", "wiki",]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/april/20210417-docker-xWiki/index.es.md"
+++
XWiki es una plataforma de software wiki libre escrita en Java y diseñada pensando en la extensibilidad. Hoy muestro cómo instalar un servicio xWiki en el Synology DiskStation.
## Opción para profesionales
Como usuario experimentado de Synology, puede, por supuesto, iniciar sesión con SSH e instalar toda la configuración a través del archivo Docker Compose.
```
version: '3'
services:
  xwiki:
    image: xwiki:10-postgres-tomcat
    restart: always
    ports:
      - 8080:8080
    links:
      - db
    environment:
      DB_HOST: db
      DB_DATABASE: xwiki
      DB_DATABASE: xwiki
      DB_PASSWORD: xwiki
      TZ: 'Europe/Berlin'

  db:
    image: postgres:latest
    restart: always
    volumes:
      - ./postgresql:/var/lib/postgresql/data
    environment:
      - POSTGRES_USER=xwiki
      - POSTGRES_PASSWORD=xwiki
      - POSTGRES_DB=xwiki
      - TZ='Europe/Berlin'

```
Se pueden encontrar más imágenes Docker útiles para uso doméstico en la página web [Dockerverse]({{< ref "dockerverse" >}} "Dockerverse").
## Paso 1: Preparar la carpeta wiki
Creo un nuevo directorio llamado "wiki" en el directorio de Docker.
{{< gallery match="images/1/*.png" >}}

## Paso 2: Instalar la base de datos
Después, hay que crear una base de datos. Hago clic en la pestaña "Registro" de la ventana de Synology Docker y busco "postgres". Selecciono la imagen Docker "postgres" y luego hago clic en la etiqueta "latest".
{{< gallery match="images/2/*.png" >}}
Después de la descarga de la imagen, ésta está disponible como imagen. Docker distingue entre 2 estados, contenedor "estado dinámico" e imagen (estado fijo). Antes de crear un contenedor a partir de la imagen, hay que hacer algunos ajustes. Hago doble clic en mi imagen postgres.
{{< gallery match="images/3/*.png" >}}
Luego hago clic en "Configuración avanzada" y activo el "Reinicio automático". Selecciono la pestaña "Volumen" y hago clic en "Añadir carpeta". Allí creo una nueva carpeta de base de datos con esta ruta de montaje "/var/lib/postgresql/data".
{{< gallery match="images/4/*.png" >}}
En "Configuración de puertos" se eliminan todos los puertos. Esto significa que selecciono el puerto "5432" y lo borro con el botón "-".
{{< gallery match="images/5/*.png" >}}
{{<table "table table-striped table-bordered">}}
|Nombre de la variable|Valor|¿Qué es?|
|--- | --- |---|
|TZ	| Europe/Berlin	|Zona horaria|
|POSTGRES_DB	| xwiki |Este es el nombre de la base de datos.|
|POSTGRES_USER	| xwiki |Nombre de usuario de la base de datos del wiki.|
|POSTGRES_PASSWORD	| xwiki |Contraseña del usuario de la base de datos wiki.|
{{</table>}}
Por último, introduzco estas cuatro variables de entorno:Ver:
{{< gallery match="images/6/*.png" >}}
Después de estos ajustes, el servidor Mariadb puede ser iniciado. Presiono "Aplicar" en todas partes.
## Paso 3: Instalar xWiki
Hago clic en la pestaña "Registro" de la ventana de Synology Docker y busco "xwiki". Selecciono la imagen Docker "xwiki" y luego hago clic en la etiqueta "10-postgres-tomcat".
{{< gallery match="images/7/*.png" >}}
Hago doble clic en mi imagen xwiki. Luego hago clic en "Configuración avanzada" y activo aquí también el "Reinicio automático".
{{< gallery match="images/8/*.png" >}}
Asigno puertos fijos para el contenedor "xwiki". Sin puertos fijos, podría ser que el "servidor xwiki" se ejecute en un puerto diferente después de un reinicio.
{{< gallery match="images/9/*.png" >}}
Además, hay que crear un "enlace" al contenedor "postgres". Hago clic en la pestaña "Enlaces" y selecciono el contenedor de la base de datos. El nombre del alias debe ser recordado para la instalación del wiki.
{{< gallery match="images/10/*.png" >}}
{{<table "table table-striped table-bordered">}}
|Nombre de la variable|Valor|¿Qué es?|
|--- | --- |---|
|TZ |	Europe/Berlin	|Zona horaria|
|DB_HOST	| db |Nombres de alias / enlace de contenedor|
|DB_DATABASE	| xwiki	|Datos del paso 2|
|DB_USER	| xwiki	|Datos del paso 2|
|DB_PASSWORD	| xwiki |Datos del paso 2|
{{</table>}}
Por último, introduzco estas variables de entorno:Ver:
{{< gallery match="images/11/*.png" >}}
El contenedor ya puede iniciarse. Llamo al servidor xWiki con la dirección IP del Synology y el puerto de mi contenedor.
{{< gallery match="images/12/*.png" >}}