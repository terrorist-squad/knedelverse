+++
date = "2021-04-16"
title = "Salir de la crisis con creatividad: reservar un servicio con easyappoint"
difficulty = "level-3"
tags = ["buchung", "buchungstool", "click-and-meet", "corona", "Docker", "docker-compose", "easyappointments", "krise", "einzelhandel", "geschaefte"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210414-docker-easyappointments/index.es.md"
+++
La crisis de Corona está afectando duramente a los proveedores de servicios en Alemania. Las herramientas y soluciones digitales pueden ayudar a superar la pandemia de Corona con la mayor seguridad posible. En esta serie de tutoriales "Creativos para salir de la crisis" muestro tecnologías o herramientas que pueden ser útiles para los pequeños negocios.Hoy muestro "Easyappointments", una herramienta de reserva "click and meet" para servicios, por ejemplo peluquerías o tiendas. Easyappoint consta de dos áreas:
## Área 1: Backend
Un "backend" para gestionar los servicios y las citas.
{{< gallery match="images/1/*.png" >}}

## Área 2: Frontend
Una herramienta de usuario final para reservar citas. Todas las citas ya reservadas se bloquean y no pueden reservarse dos veces.
{{< gallery match="images/2/*.png" >}}

## Instalación
Ya he instalado Easyappointments varias veces con Docker-Compose y puedo recomendar encarecidamente este método de instalación. Creo un nuevo directorio llamado "easyappointments" en mi servidor:
{{< terminal >}}
mkdir easyappointments
cd easyappointments

{{</ terminal >}}
Luego voy al directorio easyappointments y creo un nuevo archivo llamado "easyappointments.yml" con el siguiente contenido:
```
version: '2'
services:
  db:
    image: mysql
    environment:
      - MYSQL_ROOT_PASSWORD=root
      - MYSQL_DATABASE=easyappointments
      - MYSQL_USER=easyappointments
      - MYSQL_PASSWORD=easyappointments
    command: mysqld --default-authentication-plugin=mysql_native_password
    volumes:
      - ./easy-appointments-data:/var/lib/mysql
    expose:
      - 3306
    networks:
      - easyappointments-network
    restart: always

  application:
    image: jamrizzi/easyappointments
    volumes:
      - ./easy-appointments:/app/www
    depends_on:
      - db
    ports:
      - 8089:8888
    environment:
      - DB_HOST=db
      - DB_USERNAME=easyappointments
      - DB_NAME=easyappointments
      - DB_PASSWORD=easyappointments
      - TZ=Europe/Berlin
      - BASE_URL=http://192.168.178.50:8089 
    networks:
      - easyappointments-network
    restart: always

networks:
  easyappointments-network:

```
Este archivo se inicia a través de Docker Compose. Después, la instalación es accesible bajo el dominio/puerto previsto.
{{< terminal >}}
docker-compose -f easyappointments.yml up

{{</ terminal >}}

## Crear un servicio
Los servicios se pueden crear en "Servicios". Cada nuevo servicio debe ser asignado a un proveedor/usuario de servicios. Esto significa que puedo reservar empleados o proveedores de servicios especializados.
{{< gallery match="images/3/*.png" >}}
El consumidor final también puede elegir el servicio y el proveedor de servicios preferido.
{{< gallery match="images/4/*.png" >}}

## Horas de trabajo y descansos
El horario de servicio general se puede configurar en "Ajustes" > "Lógica empresarial". Sin embargo, el horario de trabajo de los proveedores de servicios/usuarios también puede modificarse en el "Plan de trabajo" del usuario.
{{< gallery match="images/5/*.png" >}}

## Resumen de reservas y agenda
El calendario de citas hace visibles todas las reservas. Por supuesto, las reservas también se pueden crear o editar allí.
{{< gallery match="images/6/*.png" >}}

## Ajustes de color o lógicos
Si copias el directorio "/app/www" y lo incluyes como "volumen", puedes adaptar las hojas de estilo y la lógica como quieras.
{{< gallery match="images/7/*.png" >}}
