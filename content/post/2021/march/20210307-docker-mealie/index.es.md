+++
date = "2021-03-07"
title = "Grandes cosas con contenedores: gestionar y archivar recetas en Synology DiskStation"
difficulty = "level-1"
tags = ["diskstation", "Docker", "docker-compose", "docker-for-desktop", "rezepte", "speisen", "Synology"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/march/20210307-docker-mealie/index.es.md"
+++
Reúne todas tus recetas favoritas en el contenedor Docker y organízalas como quieras. Escriba sus propias recetas o importe recetas de sitios web, por ejemplo "Chefkoch", "Essen
{{< gallery match="images/1/*.png" >}}

## Opción para profesionales
Como usuario experimentado de Synology, puede, por supuesto, iniciar sesión con SSH e instalar toda la configuración a través del archivo Docker Compose.
```
version: "2.0"
services:
  mealie:
    container_name: mealie
    image: hkotel/mealie:latest
    restart: always
    ports:
      - 9000:80
    environment:
      db_type: sqlite
      TZ: Europa/Berlin
    volumes:
      - ./mealie/data/:/app/data

```

## Paso 1: Buscar la imagen Docker
Hago clic en la pestaña "Registro" de la ventana de Synology Docker y busco "mealie". Selecciono la imagen Docker "hkotel/mealie:latest" y luego hago clic en la etiqueta "latest".
{{< gallery match="images/2/*.png" >}}
Después de la descarga de la imagen, ésta está disponible como imagen. Docker distingue entre 2 estados, contenedor "estado dinámico" e imagen/imagen (estado fijo). Antes de que podamos crear un contenedor a partir de la imagen, hay que realizar algunos ajustes.
## Paso 2: Poner la imagen en funcionamiento:
Hago doble clic en mi imagen "mealie".
{{< gallery match="images/3/*.png" >}}
Luego hago clic en "Configuración avanzada" y activo el "Reinicio automático". Selecciono la pestaña "Volumen" y hago clic en "Añadir carpeta". Allí creo una nueva carpeta con esta ruta de montaje "/app/data".
{{< gallery match="images/4/*.png" >}}
Asigno puertos fijos para el contenedor "Mealie". Sin puertos fijos, podría ser que el "servidor Mealie" se ejecute en un puerto diferente después de un reinicio.
{{< gallery match="images/5/*.png" >}}
Por último, introduzco dos variables de entorno. La variable "db_type" es el tipo de base de datos y "TZ" es la zona horaria "Europa/Berlín".
{{< gallery match="images/6/*.png" >}}
Después de estos ajustes, el Servidor Mealie puede iniciarse. Después, puede llamar a Mealie a través de la dirección Ip de la estación Synology y el puerto asignado, por ejemplo http://192.168.21.23:8096 .
{{< gallery match="images/7/*.png" >}}

## ¿Cómo funciona Mealie?
Si muevo el ratón sobre el botón "Más" de la derecha/abajo y luego hago clic en el símbolo "Cadena", puedo introducir una url. A continuación, la aplicación Mealie busca automáticamente la información meta y de esquema necesaria.
{{< gallery match="images/8/*.png" >}}
La importación funciona muy bien (he utilizado estas funciones con urls de Chef, Food
{{< gallery match="images/9/*.png" >}}
En el modo de edición, también puedo añadir una categoría. Es importante que pulse la tecla "Enter" una vez después de cada categoría. En caso contrario, este ajuste no se aplica.
{{< gallery match="images/10/*.png" >}}

## Características especiales
Me he dado cuenta de que las categorías del menú no se actualizan automáticamente. Tienes que ayudar aquí con una recarga del navegador.
{{< gallery match="images/11/*.png" >}}

## Otras características
Por supuesto, puedes buscar recetas y también crear menús. Además, puedes personalizar "Mealie" de forma muy amplia.
{{< gallery match="images/12/*.png" >}}
Mealie también se ve muy bien en el móvil:
{{< gallery match="images/13/*.*" >}}

## Rest-Api
La documentación de la API se encuentra en "http://gewaehlte-ip:und-port ... /docs". Aquí encontrará muchos métodos que se pueden utilizar para la automatización.
{{< gallery match="images/14/*.png" >}}

## Ejemplo de Api
Imagine la siguiente ficción: "Gruner und Jahr lanza el portal de Internet Essen
{{< terminal >}}
wget --spider --force-html -r -l12  "https://www.essen-und-trinken.de/rezepte/archiv/"  2>&1 | grep '/rezepte/' | grep '^--' | awk '{ print $3 }' > liste.txt

{{</ terminal >}}
A continuación, limpiar esta lista y disparar contra el resto api, ejemplo:
```
#!/bin/bash
sort -u liste.txt > clear.txt

while read p; do
  echo "import url: $p"
  curl -d "{\"url\":\"$p\"}" -H "Content-Type: application/json" http://synology-ip:8096/api/recipes/create-url
  sleep 1
done < clear.txt

```
Ahora también puedes acceder a las recetas sin conexión:
{{< gallery match="images/15/*.png" >}}
