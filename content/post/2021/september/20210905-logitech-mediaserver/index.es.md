+++
date = "2021-09-05"
title = "Grandes cosas con contenedores: servidores multimedia de Logitech en la estación de discos de Synology"
difficulty = "level-1"
tags = ["logitech", "synology", "diskstation", "nas", "sound-system", "multiroom"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/september/20210905-logitech-mediaserver/index.es.md"
+++
En este tutorial, aprenderá a instalar un Logitech Media Server en Synology DiskStation.
{{< gallery match="images/1/*.jpg" >}}

## Paso 1: Preparar la carpeta Logitech Media Server
Creo un nuevo directorio llamado "logitechmediaserver" en el directorio Docker.
{{< gallery match="images/2/*.png" >}}

## Paso 2: Instalar la imagen de Logitech Mediaserver
Hago clic en la pestaña "Registro" de la ventana de Synology Docker y busco "logitechmediaserver". Selecciono la imagen Docker "lmscommunity/logitechmediaserver" y luego hago clic en la etiqueta "latest".
{{< gallery match="images/3/*.png" >}}
Hago doble clic en mi imagen de Logitech Media Server. Luego hago clic en "Configuración avanzada" y activo aquí también el "Reinicio automático".
{{< gallery match="images/4/*.png" >}}
{{<table "table table-striped table-bordered">}}
|Ordner |Mountpath|
|--- |---|
|/volume1/docker/logitechmediaserver/config |/config|
|/volume1/docker/logitechmediaserver/music |/música|
|/volume1/docker/logitechmediaserver/playlist |/lista de reproducción|
{{</table>}}
Selecciono la pestaña "Volumen" y hago clic en "Añadir carpeta". Allí creo tres carpetas:Ver:
{{< gallery match="images/5/*.png" >}}
Asigno puertos fijos para el contenedor "Logitechmediaserver". Sin puertos fijos, podría ser que el "servidor Logitechmediaserver" se ejecute en un puerto diferente después de un reinicio.
{{< gallery match="images/6/*.png" >}}
Por último, introduzco una variable de entorno. La variable "TZ" es la zona horaria "Europa/Berlín".
{{< gallery match="images/7/*.png" >}}
Después de estos ajustes, Logitechmediaserver-Server puede iniciarse. Después puede llamar al Logitechmediaserver a través de la dirección Ip de la estación Synology y el puerto asignado, por ejemplo http://192.168.21.23:9000 .
{{< gallery match="images/8/*.png" >}}
