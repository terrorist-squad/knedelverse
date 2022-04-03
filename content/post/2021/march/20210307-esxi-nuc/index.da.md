+++
date = "2021-03-07"
title = "Installer ESXi på en NUC. Forbered USB-stick via MacBook."
difficulty = "level-4"
tags = ["esxi", "homelab", "hypervisor", "linux", "nuc", "vmware"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/march/20210307-esxi-nuc/index.da.md"
+++
Med ESXi kan "intel NUC" opdeles i et vilkårligt antal computere. I denne vejledning viser jeg, hvordan jeg installerede VMware ESXi på min NUC.Lille indledende bemærkning: Jeg anbefaler en BIOS-opdatering før ESXi-installationen. Du skal også bruge et USB-stik på 32 GB. Jeg købte et helt bundt for under 5 euro stykket på Amazon.
{{< gallery match="images/1/*.jpg" >}}
Min NUC-8I7BEH har 2x 16 GB HyperX Impact Ram, 1x 256 GB Samsung 970 EVO M2-modul på 256 GB og en 1 TB 2,5-tommers WD-RED-harddisk på 2,5 tommer.
{{< gallery match="images/2/*.jpg" >}}

## Trin 1: Find USB - Stick
Følgende kommando viser mig alle drev:
{{< terminal >}}
diskutil list

{{</ terminal >}}
Her kan du se, at mit USB-stik har identifikatoren "disk2":
{{< gallery match="images/3/*.png" >}}

## Trin 2: Forbered filsystemet
Nu kan jeg bruge følgende kommando til at forberede filsystemet:
{{< terminal >}}
$ diskutil eraseDisk MS-DOS "ESXI" MBR disk2

{{</ terminal >}}
Derefter kan jeg også se identifikatoren i Finder:
{{< gallery match="images/4/*.png" >}}

## Trin 3: Skub USB-stikket ud
Jeg bruger kommandoen "unmountDisk" til at skubbe disken ud:
{{< terminal >}}
$ diskutil unmountDisk /dev/disk2

{{</ terminal >}}
Se:
{{< gallery match="images/5/*.png" >}}

## Trin 4: Gør sticken opstartbar
Nu indtaster vi kommandoen "sudo fdisk -e /dev/disk2" og indtaster derefter "f 1", "write" og "quit", se:
{{< gallery match="images/6/*.png" >}}

## Trin 5: Kopier data
Nu skal jeg downloade ESXi-ISO: https://www.vmware.com/de/try-vmware.html. Derefter kan jeg montere ESXi-ISO'en og kopiere indholdet til mit USB-stik.
{{< gallery match="images/7/*.png" >}}
Når alt er kopieret, leder jeg efter filen "ISOLINUX.CFG" og omdøber den til "SYSLINUX.CFG". Jeg tilføjer også "-p 1" til linjen "APPEND -c boot.cfg".
{{< gallery match="images/8/*.png" >}}
ertig! Nu er pinden brugbar. Hyg dig!
{{< gallery match="images/9/*.png" >}}
