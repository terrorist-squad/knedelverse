+++
date = "2021-04-11"
title = "Historia corta: Conectar volúmenes de Synology a ESXi."
difficulty = "level-1"
tags = ["dos", "esxi", "khk-kaufmann-v1", "nuc", "pc-kaufmann", "Synology", "vmware"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210411-esxi-mount/index.es.md"
+++

## Paso 1: Activar el servicio "NFS
En primer lugar, hay que activar el servicio "NFS" en el Diskstation. Para ello, voy al "Panel de control" > "Servicios de archivos" y hago clic en "Habilitar NFS".
{{< gallery match="images/1/*.png" >}}
Luego hago clic en "Carpeta compartida" y selecciono un directorio.
{{< gallery match="images/2/*.png" >}}

## Paso 2: Montar directorios en ESXi
En ESXi, hago clic en "Almacenamiento" > "Nuevo almacén de datos" e introduzco mis datos allí.
{{< gallery match="images/3/*.png" >}}

## Listo
Ahora se puede utilizar la memoria.
{{< gallery match="images/4/*.png" >}}
Para hacer pruebas, instalé una instalación de DOS y un antiguo software de contabilidad a través de este punto de montaje.
{{< gallery match="images/5/*.png" >}}
