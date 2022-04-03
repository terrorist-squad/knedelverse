+++
date = "2020-02-21"
title = "Grandes cosas con contenedores: ejecutar Calibre con Docker Compose (configuración de Synology pro)"
difficulty = "level-3"
tags = ["calibre", "calibre-web", "Docker", "docker-compose", "Synology", "linux"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2020/february/20200221-docker-Calibre-pro/index.es.md"
+++
Ya hay un tutorial más sencillo en este blog: [Synology-Nas: Instalar Calibre Web como biblioteca de libros electrónicos]({{< ref "post/2020/february/20200213-synology-calibreweb" >}} "Synology-Nas: Instalar Calibre Web como biblioteca de libros electrónicos"). Este tutorial es para todos los profesionales de Synology DS.
## Paso 1: Preparar el Synology
En primer lugar, se debe activar el inicio de sesión SSH en el DiskStation. Para ello, vaya al "Panel de control" > "Terminal
{{< gallery match="images/1/*.png" >}}
A continuación, puede iniciar la sesión a través de "SSH", el puerto especificado y la contraseña de administrador (los usuarios de Windows utilizan Putty o WinSCP).
{{< gallery match="images/2/*.png" >}}
Me conecto a través de Terminal, winSCP o Putty y dejo esta consola abierta para más tarde.
## Paso 2: Crear una carpeta de libros
Creo una nueva carpeta para la biblioteca de Calibre. Para ello, llamo a "Control del sistema" -> "Carpeta compartida" y creo una nueva carpeta llamada "Libros". Si todavía no hay una carpeta "Docker", también hay que crearla.
{{< gallery match="images/3/*.png" >}}

## Paso 3: Preparar la carpeta del libro
Ahora hay que descargar y descomprimir el siguiente archivo: https://drive.google.com/file/d/1zfeU7Jh3FO_jFlWSuZcZQfQOGD0NvXBm/view. El contenido ("metadata.db") debe colocarse en el nuevo directorio del libro, véase:
{{< gallery match="images/4/*.png" >}}

## Paso 4: Preparar la carpeta Docker
Creo un nuevo directorio llamado "calibre" en el directorio de Docker:
{{< gallery match="images/5/*.png" >}}
Luego cambio al nuevo directorio y creo un nuevo archivo llamado "calibre.yml" con el siguiente contenido:
```
version: '2'
services:
  calibre-web:
    image: linuxserver/calibre-web
    container_name: calibre-web-server
    environment:
      - PUID=1026
      - PGID=100
      - TZ=Europe/Berlin
    volumes:
      - /volume1/Buecher:/books
      - /volume1/docker/calibre:/briefkaste
    ports:
      - 8055:8083
    restart: unless-stopped

```
En este nuevo archivo, hay que ajustar varios lugares como sigue:* PUID/PGID: En PUID/PGID hay que introducir el ID de usuario y de grupo del usuario DS. Aquí uso la consola del "Paso 1" y los comandos "id -u" para ver el ID de usuario. Con el comando "id -g" obtengo el ID del grupo.* puertos: Para el puerto, la parte delantera "8055:" debe ser ajustada.directoriosTodos los directorios en este archivo deben ser corregidos. Las direcciones correctas se pueden ver en la ventana de propiedades del DS. (La siguiente captura de pantalla)
{{< gallery match="images/6/*.png" >}}

## Paso 5: Prueba de arranque
En este paso también puedo hacer un buen uso de la consola. Cambio al directorio de Calibre e inicio el servidor de Calibre allí a través de Docker Compose.
{{< terminal >}}
cd /volume1/docker/calibre
sudo docker-compose -f calibre.yml up -d

{{</ terminal >}}

{{< gallery match="images/7/*.png" >}}

## Paso 6: Configuración
Entonces puedo llamar a mi servidor Calibre con la IP de la estación de disco y el puerto asignado desde el "Paso 4". En la configuración, uso mi punto de montaje "/libros". Después de eso, el servidor ya es utilizable.
{{< gallery match="images/8/*.png" >}}

## Paso 7: Finalizar la configuración
La consola también es necesaria en este paso. Utilizo el comando "exec" para guardar la base de datos de la aplicación interna del contenedor.
{{< terminal >}}
sudo docker exec -it calibre-web-server cp /app/calibre-web/app.db /briefkaste/app.db

{{</ terminal >}}
Después veo un nuevo archivo "app.db" en el directorio de Calibre:
{{< gallery match="images/9/*.png" >}}
A continuación, detengo el servidor Calibre:
{{< terminal >}}
sudo docker-compose -f calibre.yml down

{{</ terminal >}}
Ahora cambio la ruta del buzón y persisto la base de datos de la aplicación sobre ella.
```
version: '2'
services:
  calibre-web:
    image: linuxserver/calibre-web
    container_name: calibre-web-server
    environment:
      - PUID=1026
      - PGID=100
      - TZ=Europe/Berlin
    volumes:
      - /volume1/Buecher:/books
      - /volume1/docker/calibre/app.db:/app/calibre-web/app.db
    ports:
      - 8055:8083
    restart: unless-stopped

```
Después, el servidor puede reiniciarse:
{{< terminal >}}
sudo docker-compose -f calibre.yml up -d

{{</ terminal >}}
