+++
date = "2021-05-30"
title = "Udemy Downloader en el Synology DiskStation"
difficulty = "level-2"
tags = ["udemy", "download", "synology", "diskstation", "udemydl"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/may/20210530-udemydl/index.es.md"
+++
En este tutorial aprenderás a descargar los cursos de "udemy" para utilizarlos sin conexión.
## Paso 1: Preparar la carpeta Udemy
Creo un nuevo directorio llamado "udemy" en el directorio Docker.
{{< gallery match="images/1/*.png" >}}

## Paso 2: Instalar la imagen de Ubuntu
Hago clic en la pestaña "Registro" de la ventana de Synology Docker y busco "ubunutu". Selecciono la imagen Docker "ubunutu" y luego hago clic en la etiqueta "latest".
{{< gallery match="images/2/*.png" >}}
Hago doble clic en mi imagen de Ubuntu. Luego hago clic en "Configuración avanzada" y activo aquí también el "Reinicio automático".
{{< gallery match="images/3/*.png" >}}
Selecciono la pestaña "Volumen" y hago clic en "Añadir carpeta". Allí creo una nueva carpeta con esta ruta de montaje "/download".
{{< gallery match="images/4/*.png" >}}
Ahora se puede iniciar el contenedor
{{< gallery match="images/5/*.png" >}}

## Paso 4: Instalar Udemy Downloader
Hago clic en "Contenedor" en la ventana de Synology Docker y hago doble clic en mi "contenedor Udemy". Luego hago clic en la pestaña "Terminal" e introduzco los siguientes comandos.
{{< gallery match="images/6/*.png" >}}

##  Comandos:

{{< terminal >}}
apt-get update
apt-get install python3 python3-pip wget unzip
cd /download
wget https://github.com/r0oth3x49/udemy-dl/archive/refs/heads/master.zip
unzip master.zip
cd udemy-dl-master
pip3 pip install -r requirements.txt

{{</ terminal >}}
Capturas de pantalla:
{{< gallery match="images/7/*.png" >}}

## Paso 4: Poner en funcionamiento el descargador de Udemy
Ahora necesito un "token de acceso". Visito Udemy con mi navegador Firefox y abro Firebug. Hago clic en la pestaña "Almacenamiento web" y copio el "Token de acceso".
{{< gallery match="images/8/*.png" >}}
Creo un nuevo archivo en mi contenedor:
{{< terminal >}}
echo "access_token=859wjuhV7PMLsZu15GOWias9A0iFnRjkL9pJXOv2" > /download/cookie.txt

{{</ terminal >}}
Después puedo descargar los cursos que ya he comprado:
{{< terminal >}}
cd /download
python3 udemy-dl-master/udemy-dl.py -k /download/cookie.txt https://www.udemy.com/course/ansible-grundlagen/learn/

{{</ terminal >}}
Ver:
{{< gallery match="images/9/*.png" >}}

