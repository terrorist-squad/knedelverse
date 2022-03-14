+++
date = "2021-04-25T09:28:11+01:00"
title = "Grandes cosas con contenedores: Netbox en Synology - Disco"
difficulty = "level-3"
tags = ["Computernetzwerken", "DCIM", "Docker", "docker-compose", "IPAM", "netbox", "Synology", "netwerk"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210425-docker-Netbox/index.es.md"
+++
NetBox es un software gratuito utilizado para la gestión de redes informáticas. Hoy muestro cómo instalar un servicio Netbox en el Synology DiskStation.
## Paso 1: Preparar el Synology
En primer lugar, se debe activar el inicio de sesión SSH en el DiskStation. Para ello, vaya al "Panel de control" > "Terminal
{{< gallery match="images/1/*.png" >}}
A continuación, puede iniciar la sesión a través de "SSH", el puerto especificado y la contraseña de administrador (los usuarios de Windows utilizan Putty o WinSCP).
{{< gallery match="images/2/*.png" >}}
Me conecto a través de Terminal, winSCP o Putty y dejo esta consola abierta para más tarde.
## Paso 2: Crear la carpeta NETBOX
Creo un nuevo directorio llamado "netbox" en el directorio de Docker.
{{< gallery match="images/3/*.png" >}}
Ahora hay que descargar el siguiente archivo y descomprimirlo en el directorio: https://github.com/netbox-community/netbox-docker/archive/refs/heads/release.zip. Para ello utilizo la consola:
{{< terminal >}}
cd /volume1/docker/netbox/
sudo wget https://github.com/netbox-community/netbox-docker/archive/refs/heads/release.zip
sudo /bin/7z x release.zip
cd netbox-docker-release
sudo mkdir netbox-media-files
sudo mkdir netbox-redis-data
sudo mkdir netbox-postgres-data

{{</ terminal >}}
Luego edito el archivo "docker/docker-compose.yml" e introduzco mis direcciones de Synology en "netbox-media-files", "netbox-postgres-data" y "netbox-redis-data":
```
version: '3.4'
services:
  netbox: &netbox
    image: netboxcommunity/netbox:${VERSION-latest}
    depends_on:
    - postgres
    - redis
    - redis-cache
    - netbox-worker
    env_file: env/netbox.env
    user: '101'
    volumes:
    - ./startup_scripts:/opt/netbox/startup_scripts:z,ro
    - ./initializers:/opt/netbox/initializers:z,ro
    - ./configuration:/etc/netbox/config:z,ro
    - ./reports:/etc/netbox/reports:z,ro
    - ./scripts:/etc/netbox/scripts:z,ro
    - ./netbox-media-files:/opt/netbox/netbox/media:z
    ports:
    - "8097:8080"
  netbox-worker:
    <<: *netbox
    depends_on:
    - redis
    entrypoint:
    - /opt/netbox/venv/bin/python
    - /opt/netbox/netbox/manage.py
    command:
    - rqworker
    ports: []

  # postgres
  postgres:
    image: postgres:12-alpine
    env_file: env/postgres.env
    volumes:
    - ./netbox-postgres-data:/var/lib/postgresql/data

  # redis
  redis:
    image: redis:6-alpine
    command:
    - sh
    - -c # this is to evaluate the $REDIS_PASSWORD from the env
    - redis-server --appendonly yes --requirepass $$REDIS_PASSWORD ## $$ because of docker-compose
    env_file: env/redis.env
    volumes:
    - ./netbox-redis-data:/data
  redis-cache:
    image: redis:6-alpine
    command:
    - sh
    - -c # this is to evaluate the $REDIS_PASSWORD from the env
    - redis-server --requirepass $$REDIS_PASSWORD ## $$ because of docker-compose
    env_file: env/redis-cache.env

```
Después de eso puedo iniciar el archivo de composición:
{{< terminal >}}
sudo docker-compose up

{{</ terminal >}}
La creación de la base de datos puede llevar algún tiempo. El comportamiento se puede observar a través de los detalles del contenedor.
{{< gallery match="images/4/*.png" >}}
Llamo al servidor netbox con la dirección IP del Synology y el puerto de mi contenedor.
{{< gallery match="images/5/*.png" >}}