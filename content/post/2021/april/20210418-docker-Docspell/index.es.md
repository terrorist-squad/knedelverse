+++
date = "2021-04-18"
title = "Grandes cosas con contenedores: ejecución de Docspell DMS en Synology DiskStation"
difficulty = "level-2"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "Document-Managment-System"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210418-docker-Docspell/index.es.md"
+++
Docspell es un sistema de gestión de documentos para Synology DiskStation. A través de Docspell, los documentos se pueden indexar, buscar y encontrar mucho más rápido. Hoy muestro cómo instalar un servicio Docspell en la estación de disco Synology.
## Paso 1: Preparar el Synology
En primer lugar, se debe activar el inicio de sesión SSH en el DiskStation. Para ello, vaya al "Panel de control" > "Terminal
{{< gallery match="images/1/*.png" >}}
A continuación, puede iniciar la sesión a través de "SSH", el puerto especificado y la contraseña de administrador (los usuarios de Windows utilizan Putty o WinSCP).
{{< gallery match="images/2/*.png" >}}
Me conecto a través de Terminal, winSCP o Putty y dejo esta consola abierta para más tarde.
## Paso 2: Crear la carpeta Docspel
Creo un nuevo directorio llamado "docspell" en el directorio Docker.
{{< gallery match="images/3/*.png" >}}
Ahora hay que descargar el siguiente archivo y descomprimirlo en el directorio: https://github.com/eikek/docspell/archive/refs/heads/master.zip . Para ello utilizo la consola:
{{< terminal >}}
cd /volume1/docker/docspell/
mkdir docs
mkdir postgres_data
wget https://github.com/eikek/docspell/archive/refs/heads/master.zip 
/bin/7z x master.zip

{{</ terminal >}}
A continuación, edito el archivo "docker/docker-compose.yml" e introduzco mis direcciones de Synology en "consumedir" y "db":
{{< gallery match="images/4/*.png" >}}
Después de eso puedo iniciar el archivo de composición:
{{< terminal >}}
cd docspell-master/docker/
docker-compose up -d

{{</ terminal >}}
Después de unos minutos, puedo llamar a mi servidor Docspell con la IP de la estación de disco y el puerto asignado/7878.
{{< gallery match="images/5/*.png" >}}
