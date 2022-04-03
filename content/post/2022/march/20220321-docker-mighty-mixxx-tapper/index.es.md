+++
date = "2022-03-21"
title = "Cosas geniales con contenedores: Grabación de MP3 desde la radio"
difficulty = "level-1"
tags = ["diskstation", "Docker", "docker-compose", "docker-for-desktop", "radio", "mp3", "ripp", "streamripper", "radiorecorder"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2022/march/20220321-docker-mighty-mixxx-tapper/index.es.md"
+++
Streamripper es una herramienta para la línea de comandos que permite grabar flujos de MP3 u OGG/Vorbis y guardarlos directamente en el disco duro. Las canciones se nombran automáticamente según el artista y se guardan individualmente, el formato es el que se envió originalmente (así que de hecho se crean archivos con la extensión .mp3 u .ogg). Encontré una gran interfaz de radiorecorder y construí una imagen Docker a partir de ella, ver: https://github.com/terrorist-squad/mightyMixxxTapper/
{{< gallery match="images/1/*.png" >}}

## Opción para profesionales
Como usuario experimentado de Synology, puede, por supuesto, iniciar sesión con SSH e instalar toda la configuración a través del archivo Docker Compose.
```
version: "2.0"
services:
  mealie:
    container_name: mighty-mixxx-tapper
    image: chrisknedel/mighty-mixxx-tapper:latest
    restart: always
    ports:
      - 9000:80
    environment:
      TZ: Europa/Berlin
    volumes:
      - ./ripps/:/tmp/ripps/

```

## Paso 1: Buscar la imagen Docker
Hago clic en la pestaña "Registro" de la ventana de Synology Docker y busco "mighty-mixxx-tapper". Selecciono la imagen Docker "chrisknedel/mighty-mixxx-tapper" y luego hago clic en la etiqueta "latest".
{{< gallery match="images/2/*.png" >}}
Después de la descarga de la imagen, ésta está disponible como imagen. Docker distingue entre 2 estados, contenedor "estado dinámico" e imagen/imagen (estado fijo). Antes de que podamos crear un contenedor a partir de la imagen, hay que realizar algunos ajustes.
## Paso 2: Poner la imagen en funcionamiento:
Hago doble clic en mi imagen "mighty-mixxx-tapper".
{{< gallery match="images/3/*.png" >}}
Luego hago clic en "Configuración avanzada" y activo el "Reinicio automático". Selecciono la pestaña "Volumen" y hago clic en "Añadir carpeta". Allí creo una nueva carpeta con esta ruta de montaje "/tmp/ripps/".
{{< gallery match="images/4/*.png" >}}
Asigno puertos fijos para el contenedor "mighty-mixxx-tapper". Sin puertos fijos, podría ser que el "mighty-mixxx-tapper-server" se ejecute en un puerto diferente después de un reinicio.
{{< gallery match="images/5/*.png" >}}
Después de estos ajustes, mighty-mixxx-tapper-server puede iniciarse. Después, puede llamar a mighty-mixxx-tapper a través de la dirección IP de la estación Synology y el puerto asignado, por ejemplo http://192.168.21.23:8097.
{{< gallery match="images/6/*.png" >}}
