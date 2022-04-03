+++
date = "2021-04-25T09:28:11+01:00"
title = "BitwardenRS en el Synology DiskStation"
difficulty = "level-2"
tags = ["bitwardenrs", "Docker", "docker-compose", "password-manager", "passwort", "Synology"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210425-docker-BitwardenRS/index.es.md"
+++
Bitwarden es un servicio gratuito de gestión de contraseñas de código abierto que almacena la información confidencial, como las credenciales de los sitios web, en una bóveda cifrada. Hoy muestro cómo instalar un BitwardenRS en el Synology DiskStation.
## Paso 1: Preparar la carpeta BitwardenRS
Creo un nuevo directorio llamado "bitwarden" en el directorio de Docker.
{{< gallery match="images/1/*.png" >}}

## Paso 2: Instalar BitwardenRS
Hago clic en la pestaña "Registro" de la ventana de Synology Docker y busco "bitwarden". Selecciono la imagen Docker "bitwardenrs/server" y luego hago clic en la etiqueta "latest".
{{< gallery match="images/2/*.png" >}}
Hago doble clic en la imagen de mi bitwardenrs. Luego hago clic en "Configuración avanzada" y activo aquí también el "Reinicio automático".
{{< gallery match="images/3/*.png" >}}
Selecciono la pestaña "Volumen" y hago clic en "Añadir carpeta". Allí creo una nueva carpeta con esta ruta de montaje "/data".
{{< gallery match="images/4/*.png" >}}
Asigno puertos fijos para el contenedor "bitwardenrs". Sin puertos fijos, podría ser que el "servidor bitwardenrs" se ejecute en un puerto diferente después de un reinicio. El primer puerto de contenedores puede ser eliminado. Hay que recordar el otro puerto.
{{< gallery match="images/5/*.png" >}}
El contenedor ya puede iniciarse. Llamo al servidor bitwardenrs con la dirección IP del Synology y el puerto 8084 de mi contenedor.
{{< gallery match="images/6/*.png" >}}

## Paso 3: Configurar HTTPS
Hago clic en "Panel de control" > "Proxy inverso" y "Crear".
{{< gallery match="images/7/*.png" >}}
Después de eso, puedo llamar al servidor bitwardenrs con la dirección IP del Synology y mi puerto proxy 8085, encriptado.
{{< gallery match="images/8/*.png" >}}
