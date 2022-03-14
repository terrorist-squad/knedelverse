+++
date = "2021-03-07"
title = "Instalar ESXi en un NUC. Prepara la memoria USB a través del MacBook."
difficulty = "level-4"
tags = ["esxi", "homelab", "hypervisor", "linux", "nuc", "vmware"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/march/20210307-esxi-nuc/index.es.md"
+++
Con ESXi, el "intel NUC" puede dividirse en cualquier número de ordenadores. En este tutorial, muestro cómo he instalado VMware ESXi en mi NUC.Pequeño prefacio: recomiendo una actualización de la BIOS antes de la instalación de ESXi. También necesitarás una memoria USB de 32 GB. Compré un paquete completo por menos de 5 euros cada uno en Amazon.
{{< gallery match="images/1/*.jpg" >}}
Mi NUC-8I7BEH tiene 2x 16GB HyperX Impact Ram, 1x 256GB Samsung 970 EVO M2 module y un disco duro de 1TB 2.5-inch WD-RED.
{{< gallery match="images/2/*.jpg" >}}

## Paso 1: Buscar la memoria USB
El siguiente comando me muestra todas las unidades:
{{< terminal >}}
diskutil list

{{</ terminal >}}
Aquí puedes ver que mi memoria USB tiene el identificador "disk2":
{{< gallery match="images/3/*.png" >}}

## Paso 2: Preparar el sistema de archivos
Ahora puedo utilizar el siguiente comando para preparar el sistema de archivos:
{{< terminal >}}
$ diskutil eraseDisk MS-DOS "ESXI" MBR disk2

{{</ terminal >}}
Después, también veo el identificador en el Finder:
{{< gallery match="images/4/*.png" >}}

## Paso 3: Expulsar la memoria USB
Utilizo el comando "unmountDisk" para expulsar el volumen:
{{< terminal >}}
$ diskutil unmountDisk /dev/disk2

{{</ terminal >}}
Ver:
{{< gallery match="images/5/*.png" >}}

## Paso 4: Hacer que el stick sea booteable
Ahora introducimos el comando "sudo fdisk -e /dev/disk2" y luego introducimos "f 1", "write" y "quit", ver:
{{< gallery match="images/6/*.png" >}}

## Paso 5: Copiar datos
Ahora tengo que descargar el ESXi-ISO: https://www.vmware.com/de/try-vmware.html. Después de eso puedo montar el ESXi-ISO y copiar el contenido a mi memoria USB.
{{< gallery match="images/7/*.png" >}}
Cuando todo está copiado, busco el archivo "ISOLINUX.CFG" y lo renombro a "SYSLINUX.CFG". También añado "-p 1" a la línea "APPEND -c boot.cfg".
{{< gallery match="images/8/*.png" >}}
¡ertig! Ahora el palo es utilizable. Diviértete.
{{< gallery match="images/9/*.png" >}}