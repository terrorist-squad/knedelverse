+++
date = "2021-07-25"
title = "Grandes cosas con los contenedores: Registro Docker con interfaz de usuario"
difficulty = "level-3"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "registry", "images", "ui", "interface"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/july/20210725-docker-registry/index.es.md"
+++
Aprenda a hacer que sus imágenes Docker estén disponibles en toda la red a través de su propio registro.
## Instalación
Creo un nuevo directorio llamado "docker-registry" en mi servidor:
{{< terminal >}}
mkdir docker-registry

{{</ terminal >}}
Luego voy al directorio docker-registry ("cd docker-registry") y creo un nuevo archivo llamado "registry.yml" con el siguiente contenido:
```
version: '3'

services:
  registry:
    restart: always
    image: registry:2
    ports:
    - "5000:5000"
    environment:
      REGISTRY_STORAGE_FILESYSTEM_ROOTDIRECTORY: /data
    volumes:
      - ./data:/data
    networks:
      - registry-ui-net

  ui:
    restart: always
    image: joxit/docker-registry-ui:static
    ports:
      - 8080:80
    environment:
      - REGISTRY_TITLE=My Private Docker Registry
      - REGISTRY_URL=http://registry:5000
    depends_on:
      - registry
    networks:
      - registry-ui-net

networks:
  registry-ui-net:

```
Se pueden encontrar más imágenes Docker útiles para uso doméstico en la página web [Dockerverse]({{< ref "dockerverse" >}} "Dockerverse").
## El comando de inicio
Este archivo se inicia a través de Docker Compose. Después, la instalación es accesible bajo el dominio/puerto previsto.
{{< terminal >}}
docker-compose -f registry.yml up -d

{{</ terminal >}}
Después, se puede utilizar el registro propio con la IP de destino y el puerto del contenedor de la UI.
{{< gallery match="images/1/*.png" >}}
Ahora puedo construir, empujar y poblar imágenes desde mi registro:
{{< terminal >}}
docker build -t 192.168.178.61:5000/mein-image:version .
docker push 192.168.178.61:5000/mein-image:version
docker pull 192.168.178.61:5000/mein-image:version

{{</ terminal >}}
