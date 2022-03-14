+++
date = "2020-02-28"
title = "Grandes cosas con contenedores: ejecutar Papermerge DMS en un NAS de Synology"
difficulty = "level-3"
tags = ["archiv", "automatisch", "dms", "Docker", "Document-Managment-System", "google", "ocr", "papermerge", "Synology", "tesseract", "texterkennung"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2020/february/20200228-docker-papermerge/index.es.md"
+++
Papermerge es un joven sistema de gestión de documentos (DMS) que puede asignar y procesar automáticamente los documentos. En este tutorial muestro cómo he instalado Papermerge en mi estación de disco Synology y cómo funciona el DMS.
## Opción para profesionales
Como usuario experimentado de Synology, puede, por supuesto, iniciar sesión con SSH e instalar toda la configuración a través del archivo Docker Compose.
```
version: "2.1"
services:
  papermerge:
    image: ghcr.io/linuxserver/papermerge
    container_name: papermerge
    environment:
      - PUID=1024
      - PGID=100
      - TZ=Europe/Berlin
    volumes:
      - ./config>:/config
      - ./appdata/data>:/data
    ports:
      - 8090:8000
    restart: unless-stopped

```

## Paso 1: Crear carpeta
Primero creo una carpeta para la fusión de papeles. Voy a "Control del sistema" -> "Carpeta compartida" y creo una nueva carpeta llamada "Archivo de documentos".
{{< gallery match="images/1/*.png" >}}
Paso 2: Buscar la imagen DockerHago clic en la pestaña "Registro" de la ventana de Synology Docker y busco "Papermerge". Selecciono la imagen Docker "linuxserver/papermerge" y luego hago clic en la etiqueta "latest".
{{< gallery match="images/2/*.png" >}}
Después de la descarga de la imagen, ésta está disponible como imagen. Docker distingue entre 2 estados, contenedor "estado dinámico" e imagen/imagen (estado fijo). Antes de que podamos crear un contenedor a partir de la imagen, hay que realizar algunos ajustes.
## Paso 3: Poner la imagen en funcionamiento:
Hago doble clic en mi imagen de fusión de papel.
{{< gallery match="images/3/*.png" >}}
Luego hago clic en "Configuración avanzada" y activo el "Reinicio automático". Selecciono la pestaña "Volumen" y hago clic en "Añadir carpeta". Allí creo una nueva carpeta de base de datos con esta ruta de montaje "/data".
{{< gallery match="images/4/*.png" >}}
También almaceno aquí una segunda carpeta que incluyo con la ruta de montaje "/config". Realmente no importa dónde esté esta carpeta. Sin embargo, es importante que pertenezca al usuario administrador de Synology.
{{< gallery match="images/5/*.png" >}}
Asigno puertos fijos para el contenedor "Papermerge". Sin puertos fijos, podría ser que el "servidor Papermerge" se ejecute en un puerto diferente después de un reinicio.
{{< gallery match="images/6/*.png" >}}
Por último, introduzco tres variables de entorno. La variable "PUID" es el ID del usuario y "PGID" es el ID del grupo de mi usuario administrador. Puedes averiguar el PGID/PUID vía SSH con el comando "cat /etc/passwd | grep admin".
{{< gallery match="images/7/*.png" >}}
Después de estos ajustes, el servidor de Papermerge puede iniciarse. A continuación, se puede llamar a Papermerge a través de la dirección IP de la estación Synology y el puerto asignado, por ejemplo http://192.168.21.23:8095.
{{< gallery match="images/8/*.png" >}}
El inicio de sesión por defecto es admin con la contraseña admin.
## ¿Cómo funciona Papermerge?
Papermerge analiza el texto de documentos e imágenes. Papermerge utiliza una biblioteca de OCR/"reconocimiento óptico de caracteres" llamada tesseract, publicada por Goolge.
{{< gallery match="images/9/*.png" >}}
He creado una carpeta llamada "Todo con Lorem" para probar la asignación automática de documentos. A continuación, hice clic en un nuevo patrón de reconocimiento en la opción de menú "Automatizaciones".
{{< gallery match="images/10/*.png" >}}
Todos los documentos nuevos que contienen la palabra "Lorem" se colocan en la carpeta "Todo con Lorem" y se etiquetan como "has-lorem". Es importante utilizar una coma en las etiquetas, de lo contrario la etiqueta no se establecerá. Si subes un documento correspondiente, se etiquetará y clasificará.
{{< gallery match="images/11/*.png" >}}