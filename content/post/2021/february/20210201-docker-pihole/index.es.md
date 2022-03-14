+++
date = "2021-02-01"
title = "Grandes cosas con contenedores: Pihole en el Synology DiskStation"
difficulty = "level-3"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "dns", "adblocker", "fritzbox"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/february/20210201-docker-pihole/index.es.md"
+++
Hoy muestro cómo instalar un servicio Pihole en la estación de disco Synology y conectarla a la Fritzbox.
## Paso 1: Preparar el Synology
En primer lugar, se debe activar el inicio de sesión SSH en el DiskStation. Para ello, vaya al "Panel de control" > "Terminal
{{< gallery match="images/1/*.png" >}}
A continuación, puede iniciar la sesión a través de "SSH", el puerto especificado y la contraseña de administrador (los usuarios de Windows utilizan Putty o WinSCP).
{{< gallery match="images/2/*.png" >}}
Me conecto a través de Terminal, winSCP o Putty y dejo esta consola abierta para más tarde.
## Paso 2: Crear la carpeta Pihole
Creo un nuevo directorio llamado "pihole" en el directorio de Docker.
{{< gallery match="images/3/*.png" >}}
Luego cambio al nuevo directorio y creo dos carpetas "etc-pihole" y "etc-dnsmasq.d":
{{< terminal >}}
cd /volume1/docker/
mkdir -p {etc-pihole,etc-dnsmasq.d}

{{</ terminal >}}
Ahora el siguiente archivo Docker Compose llamado "pihole.yml" debe ser colocado en el directorio de Pihole:
```
version: "3"

services:
  pihole:
    container_name: pihole
    image: pihole/pihole:latest
    ports:
      - "53:53/tcp"
      - "53:53/udp"
      - "67:67/udp"
      - "8080:80/tcp"
    environment:
      TZ: 'Europe/Berlin'
      WEBPASSWORD: 'password'
    volumes:
      - './etc-pihole/:/etc/pihole/'
      - './etc-dnsmasq.d/:/etc/dnsmasq.d/'
    cap_add:
      - NET_ADMIN
    restart: unless-stopped

```
El contenedor ya puede iniciarse:
{{< terminal >}}
sudo docker-compose up -d

{{</ terminal >}}
Llamo al servidor Pihole con la dirección IP del Synology y el puerto de mi contenedor y me conecto con la contraseña WEBPASSWORD.
{{< gallery match="images/4/*.png" >}}
Ahora se puede cambiar la dirección DNS en el Fritzbox en "Red doméstica" > "Red" > "Configuración de red".
{{< gallery match="images/5/*.png" >}}