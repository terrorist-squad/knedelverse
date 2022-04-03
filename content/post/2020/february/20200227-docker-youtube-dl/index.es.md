+++
date = "2020-02-27"
title = "Grandes cosas con contenedores: ejecutar el descargador de Youtube en Synology Diskstation"
difficulty = "level-1"
tags = ["Docker", "docker-compose", "download", "linux", "Synology", "video", "youtube"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2020/february/20200227-docker-youtube-dl/index.es.md"
+++
Muchos de mis amigos saben que dirijo un portal privado de vídeos de aprendizaje en mi Homelab - Network. He guardado los cursos en vídeo de anteriores afiliaciones a portales de aprendizaje y buenos tutoriales de Youtube para utilizarlos sin conexión en mi NAS.
{{< gallery match="images/1/*.png" >}}
A lo largo del tiempo he recopilado 8845 cursos de vídeo con 282616 vídeos individuales. El tiempo total de funcionamiento equivale a unos 2 años. Absolutamente loco! En este tutorial muestro cómo hacer una copia de seguridad de buenos tutoriales de Youtube con un servicio de descarga de Docker para fines offline.
## Opción para profesionales
Como usuario experimentado de Synology, puede, por supuesto, iniciar sesión con SSH e instalar toda la configuración a través del archivo Docker Compose.
```
version: "2"
services:
  youtube-dl:
    image: modenaf360/youtube-dl-nas
    container_name: youtube-dl
    environment:
      - MY_ID=admin
      - MY_PW=admin
    volumes:
      - ./YouTube:/downfolder
    ports:
      - 8080:8080
    restart: unless-stopped

```

## Paso 1
Primero creo una carpeta para las descargas. Voy a "Control del sistema" -> "Carpeta compartida" y creo una nueva carpeta llamada "Descargas".
{{< gallery match="images/2/*.png" >}}

## Paso 2: Buscar la imagen Docker
Hago clic en la pestaña "Registro" de la ventana de Synology Docker y busco "youtube-dl-nas". Selecciono la imagen Docker "modenaf360/youtube-dl-nas" y luego hago clic en la etiqueta "latest".
{{< gallery match="images/3/*.png" >}}
Después de la descarga de la imagen, ésta está disponible como imagen. Docker distingue entre 2 estados, contenedor "estado dinámico" e imagen/imagen (estado fijo). Antes de que podamos crear un contenedor a partir de la imagen, hay que realizar algunos ajustes.
## Paso 3: Poner la imagen en funcionamiento:
Hago doble clic en mi imagen de youtube-dl-nas.
{{< gallery match="images/4/*.png" >}}
Luego hago clic en "Configuración avanzada" y activo el "Reinicio automático". Selecciono la pestaña "Volumen" y hago clic en "Añadir carpeta". Allí creo una nueva carpeta de base de datos con esta ruta de montaje "/downfolder".
{{< gallery match="images/5/*.png" >}}
Asigno puertos fijos para el contenedor "Youtube Downloader". Sin puertos fijos, podría ser que el "Youtube Downloader" se ejecute en un puerto diferente después de un reinicio.
{{< gallery match="images/6/*.png" >}}
Por último, introduzco dos variables de entorno. La variable "MY_ID" es mi nombre de usuario y "MY_PW" es mi contraseña.
{{< gallery match="images/7/*.png" >}}
Después de estos ajustes, ¡el Downloader puede iniciarse! A continuación, puede llamar al descargador a través de la dirección Ip de la estación Synology y el puerto asignado, por ejemplo http://192.168.21.23:8070 .
{{< gallery match="images/8/*.png" >}}
Para la autenticación, tome el nombre de usuario y la contraseña de MY_ID y MY_PW.
## Paso 4: Vamos
Ahora se pueden introducir las urls de los vídeos de Youtube y de las listas de reproducción en el campo "URL" y todos los vídeos acaban automáticamente en la carpeta de descargas de la estación de disco Synology.
{{< gallery match="images/9/*.png" >}}
Descargue la carpeta:
{{< gallery match="images/10/*.png" >}}
