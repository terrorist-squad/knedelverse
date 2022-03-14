+++
date = "2021-07-25"
title = "Grandes cosas con contenedores: gestión de la nevera con Grocy"
difficulty = "level-1"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "kühlschrank", "erp", "mhd", "Speispläne", "cms", "Cafe", "Bistro"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/july/20210725-docker-grocy/index.es.md"
+++
Con Grocy puede gestionar toda una casa, un restaurante, una cafetería, un bistró o un mercado de alimentos. Puede gestionar las neveras, los menús, las tareas, las listas de la compra y la fecha de consumo preferente de los alimentos.
{{< gallery match="images/1/*.png" >}}
Hoy muestro cómo instalar un servicio Grocy en la estación de disco Synology.
## Opción para profesionales
Como usuario experimentado de Synology, puede, por supuesto, iniciar sesión con SSH e instalar toda la configuración a través del archivo Docker Compose.
```
version: "2.1"
services:
  grocy:
    image: ghcr.io/linuxserver/grocy
    container_name: grocy
    environment:
      - PUID=1024
      - PGID=100
      - TZ=Europe/Berlin
    volumes:
      - ./data:/config
    ports:
      - 9283:80
    restart: unless-stopped

```
Se pueden encontrar más imágenes Docker útiles para uso doméstico en la página web [Dockerverse]({{< ref "dockerverse" >}} "Dockerverse").
## Paso 1: Preparar la carpeta Grocy
Creo un nuevo directorio llamado "grocy" en el directorio de Docker.
{{< gallery match="images/2/*.png" >}}

## Paso 2: Instalar Grocy
Hago clic en la pestaña "Registro" de la ventana de Synology Docker y busco "Grocy". Selecciono la imagen Docker "linuxserver/grocy:latest" y luego hago clic en la etiqueta "latest".
{{< gallery match="images/3/*.png" >}}
Hago doble clic en mi imagen de Grocy.
{{< gallery match="images/4/*.png" >}}
Luego hago clic en "Configuración avanzada" y activo aquí también el "Reinicio automático". Selecciono la pestaña "Volumen" y hago clic en "Añadir carpeta". Allí creo una nueva carpeta con esta ruta de montaje "/config".
{{< gallery match="images/5/*.png" >}}
Asigno puertos fijos para el contenedor "Grocy". Sin puertos fijos, podría ser que el "servidor Grocy" se ejecute en un puerto diferente después de un reinicio.
{{< gallery match="images/6/*.png" >}}
{{<table "table table-striped table-bordered">}}
|Nombre de la variable|Valor|¿Qué es?|
|--- | --- |---|
|TZ | Europe/Berlin |Zona horaria|
|PUID | 1024 |ID de usuario de Synology Admin User|
|PGID |	100 |ID de grupo del usuario administrador de Synology|
{{</table>}}
Por último, introduzco estas variables de entorno:Ver:
{{< gallery match="images/7/*.png" >}}
El contenedor ya puede iniciarse. Llamo al servidor Grocy con la dirección IP del Synology y el puerto de mi contenedor y me conecto con el nombre de usuario "admin" y la contraseña "admin".
{{< gallery match="images/8/*.png" >}}
