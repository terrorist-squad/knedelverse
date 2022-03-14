+++
date = "2021-04-25T09:28:11+01:00"
title = "Grandes cosas con contenedores: Portainer como alternativa a la GUI Docker de Synology"
difficulty = "level-3"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "watchtower"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210425-docker-Portainer/index.es.md"
+++

## Paso 1: Preparar el Synology
En primer lugar, se debe activar el inicio de sesión SSH en el DiskStation. Para ello, vaya al "Panel de control" > "Terminal
{{< gallery match="images/1/*.png" >}}
A continuación, puede iniciar la sesión a través de "SSH", el puerto especificado y la contraseña de administrador (los usuarios de Windows utilizan Putty o WinSCP).
{{< gallery match="images/2/*.png" >}}
Me conecto a través de Terminal, winSCP o Putty y dejo esta consola abierta para más tarde.
## Paso 2: Crear la carpeta portainer
Creo un nuevo directorio llamado "portainer" en el directorio de Docker.
{{< gallery match="images/3/*.png" >}}
Luego voy al directorio del portainer con la consola y creo allí una carpeta y un nuevo archivo llamado "portainer.yml".
{{< terminal >}}
cd /volume1/docker/portainer
mkdir portainer_data
vim portainer.yml

{{</ terminal >}}
Este es el contenido del archivo "portainer.yml":
```
version: '3'

services:
  portainer:
    image: portainer/portainer:latest
    container_name: portainer
    restart: always
    ports:
      - 90070:9000
      - 9090:8000
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - ./portainer_data:/data

```
Se pueden encontrar más imágenes Docker útiles para uso doméstico en la página web [Dockerverse]({{< ref "dockerverse" >}} "Dockerverse").
## Paso 3: Inicio del contenedor
En este paso también puedo hacer un buen uso de la consola. Inicio el servidor portainer a través de Docker Compose.
{{< terminal >}}
sudo docker-compose -f portainer.yml up -d

{{</ terminal >}}
Entonces puedo llamar a mi servidor Portainer con la IP de la estación de disco y el puerto asignado desde el "Paso 2". Introduzco mi contraseña de administrador y selecciono la variante local.
{{< gallery match="images/4/*.png" >}}
Como puedes ver, ¡todo funciona de maravilla!
{{< gallery match="images/5/*.png" >}}