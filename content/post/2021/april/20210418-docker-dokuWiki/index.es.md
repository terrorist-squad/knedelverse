+++
date = "2021-04-18"
title = "Grandes cosas con contenedores: Instalar su propio dokuWiki en la estación de disco Synology"
difficulty = "level-2"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "dokuwiki", "wiki"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/april/20210418-docker-dokuWiki/index.es.md"
+++
DokuWiki es un software wiki de código abierto que cumple con los estándares, es fácil de usar y al mismo tiempo muy versátil. Hoy muestro cómo instalar un servicio DokuWiki en la estación de disco Synology.
## Opción para profesionales
Como usuario experimentado de Synology, puede, por supuesto, iniciar sesión con SSH e instalar toda la configuración a través del archivo Docker Compose.
```
version: '3'
services:
  dokuwiki:
    image:  bitnami/dokuwiki:latest
    restart: always
    ports:
      - 8080:8080
      - 8443:8443
    environment:
      TZ: 'Europe/Berlin'
      DOKUWIKI_USERNAME: 'admin'
      DOKUWIKI_FULL_NAME: 'wiki'
      DOKUWIKI_PASSWORD: 'password'
    volumes:
      - ./data:/bitnami/dokuwiki

```
Se pueden encontrar más imágenes Docker útiles para uso doméstico en la página web [Dockerverse]({{< ref "dockerverse" >}} "Dockerverse").
## Paso 1: Preparar la carpeta wiki
Creo un nuevo directorio llamado "wiki" en el directorio de Docker.
{{< gallery match="images/1/*.png" >}}

## Paso 2: Instalar DokuWiki
Después, hay que crear una base de datos. Hago clic en la pestaña "Registro" de la ventana de Synology Docker y busco "dokuwiki". Selecciono la imagen Docker "bitnami/dokuwiki" y luego hago clic en la etiqueta "latest".
{{< gallery match="images/2/*.png" >}}
Después de la descarga de la imagen, ésta está disponible como imagen. Docker distingue entre 2 estados, contenedor "estado dinámico" e imagen (estado fijo). Antes de crear un contenedor a partir de la imagen, hay que hacer algunos ajustes. Hago doble clic en mi imagen dokuwiki.
{{< gallery match="images/3/*.png" >}}
Asigno puertos fijos para el contenedor "dokuwiki". Sin puertos fijos, podría ser que el "servidor dokuwiki" se ejecute en un puerto diferente después de un reinicio.
{{< gallery match="images/4/*.png" >}}
{{<table "table table-striped table-bordered">}}
|Nombre de la variable|Valor|¿Qué es?|
|--- | --- |---|
|TZ	| Europe/Berlin	|Zona horaria|
|DOKUWIKI_USERNAME	| admin|Nombre de usuario del administrador|
|DOKUWIKI_FULL_NAME |	wiki	|Nombre de WIki|
|DOKUWIKI_PASSWORD	| password	|Contraseña de administrador|
{{</table>}}
Por último, introduzco estas variables de entorno:Ver:
{{< gallery match="images/5/*.png" >}}
El contenedor ya puede iniciarse. Llamo al servidor dokuWIki con la dirección IP del Synology y el puerto de mi contenedor.
{{< gallery match="images/6/*.png" >}}
