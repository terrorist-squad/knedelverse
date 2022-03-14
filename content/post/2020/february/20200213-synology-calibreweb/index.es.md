+++
date = "2020-02-13"
title = "Synology-Nas: Instalar Calibre Web como biblioteca de libros electrónicos"
difficulty = "level-1"
tags = ["calbre-web", "calibre", "Docker", "ds918", "ebook", "epub", "nas", "pdf", "Synology"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2020/february/20200213-synology-calibreweb/index.es.md"
+++
¿Cómo puedo instalar Calibre-Web como contenedor Docker en mi NAS de Synology? Atención: Este método de instalación está obsoleto y no es compatible con el software actual de Calibre. Por favor, eche un vistazo a este nuevo tutorial:[Grandes cosas con contenedores: ejecutar Calibre con Docker Compose]({{< ref "post/2020/february/20200221-docker-Calibre-pro" >}} "Grandes cosas con contenedores: ejecutar Calibre con Docker Compose"). Este tutorial es para todos los profesionales de Synology DS.
## Paso 1: Crear carpeta
Primero, creo una carpeta para la biblioteca de Calibre.  Llamo al "Control del sistema" -> "Carpeta compartida" y creo una nueva carpeta "Libros".
{{< gallery match="images/1/*.png" >}}

##  Paso 2: Crear la biblioteca Calibre
Ahora copio una biblioteca existente o "[esta biblioteca de muestra vacía](https://drive.google.com/file/d/1zfeU7Jh3FO_jFlWSuZcZQfQOGD0NvXBm/view)" en el nuevo directorio. Yo mismo he copiado la biblioteca existente de la aplicación de escritorio.
{{< gallery match="images/2/*.png" >}}

## Paso 3: Buscar la imagen Docker
Hago clic en la pestaña "Registro" de la ventana de Synology Docker y busco "Calibre". Selecciono la imagen Docker "janeczku/calibre-web" y luego hago clic en la etiqueta "latest".
{{< gallery match="images/3/*.png" >}}
Después de la descarga de la imagen, ésta está disponible como imagen. Docker distingue entre 2 estados, contenedor "estado dinámico" e imagen/imagen (estado fijo). Antes de que podamos crear un contenedor a partir de la imagen, hay que realizar algunos ajustes.
## Paso 4: Poner la imagen en funcionamiento:
Hago doble clic en mi imagen de Calibre.
{{< gallery match="images/4/*.png" >}}
Luego hago clic en "Configuración avanzada" y activo el "Reinicio automático". Selecciono la pestaña "Volumen" y hago clic en "Añadir carpeta". Allí creo una nueva carpeta de base de datos con esta ruta de montaje "/calibre".
{{< gallery match="images/5/*.png" >}}
Asigno puertos fijos para el contenedor Calibre. Sin puertos fijos, podría ser que Calibre se ejecute en un puerto diferente después de un reinicio.
{{< gallery match="images/6/*.png" >}}
Después de estos ajustes, Calibre puede iniciarse.
{{< gallery match="images/7/*.png" >}}
Ahora llamo a mi Synology IP con el puerto Calibre asignado y veo la siguiente imagen. Introduzco "/calibre" como "Ubicación de la base de datos de Calibre". El resto de ajustes son cuestión de gustos.
{{< gallery match="images/8/*.png" >}}
El inicio de sesión por defecto es "admin" con la contraseña "admin123".
{{< gallery match="images/9/*.png" >}}
¡Hecho! Por supuesto, ahora también puedo conectar la aplicación de escritorio a través de mi "carpeta de libros". Intercambio la biblioteca en mi aplicación y luego selecciono mi carpeta Nas.
{{< gallery match="images/10/*.png" >}}
Algo así:
{{< gallery match="images/11/*.png" >}}
Si ahora edito meta-infos en la aplicación de escritorio, también se actualizan automáticamente en la aplicación web.
{{< gallery match="images/12/*.png" >}}