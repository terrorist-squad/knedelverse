+++
date = "2021-03-07"
title = "Installare ESXi su un NUC. Preparare la chiavetta USB tramite MacBook."
difficulty = "level-4"
tags = ["esxi", "homelab", "hypervisor", "linux", "nuc", "vmware"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/march/20210307-esxi-nuc/index.it.md"
+++
Con ESXi, l'"intel NUC" può essere diviso in qualsiasi numero di computer. In questo tutorial, mostro come ho installato VMware ESXi sul mio NUC.Piccola prefazione: consiglio un aggiornamento del BIOS prima dell'installazione di ESXi. Avrai anche bisogno di una chiavetta USB da 32GB. Ho comprato un intero pacchetto per meno di 5 euro ciascuno da Amazon.
{{< gallery match="images/1/*.jpg" >}}
Il mio NUC-8I7BEH ha 2x 16GB HyperX Impact Ram, 1x 256GB Samsung 970 EVO M2 module e un disco rigido WD-RED da 1TB 2.5 pollici.
{{< gallery match="images/2/*.jpg" >}}

## Passo 1: trovare la chiavetta USB
Il seguente comando mi mostra tutte le unità:
{{< terminal >}}
diskutil list

{{</ terminal >}}
Qui potete vedere che la mia chiavetta USB ha l'identificatore "disk2":
{{< gallery match="images/3/*.png" >}}

## Passo 2: Preparare il file system
Ora posso usare il seguente comando per preparare il file system:
{{< terminal >}}
$ diskutil eraseDisk MS-DOS "ESXI" MBR disk2

{{</ terminal >}}
Dopo di che, vedo anche l'identificatore nel Finder:
{{< gallery match="images/4/*.png" >}}

## Passo 3: Espellere la chiavetta USB
Uso il comando "unmountDisk" per espellere il volume:
{{< terminal >}}
$ diskutil unmountDisk /dev/disk2

{{</ terminal >}}
Vedere:
{{< gallery match="images/5/*.png" >}}

## Passo 4: rendere la chiavetta avviabile
Ora inseriamo il comando "sudo fdisk -e /dev/disk2" e poi inseriamo "f 1", "write" e "quit", vedi:
{{< gallery match="images/6/*.png" >}}

## Passo 5: Copiare i dati
Ora devo scaricare l'ESXi-ISO: https://www.vmware.com/de/try-vmware.html. Dopo di che posso montare l'ESXi-ISO e copiare il contenuto sulla mia chiavetta USB.
{{< gallery match="images/7/*.png" >}}
Quando tutto è copiato, cerco il file "ISOLINUX.CFG" e lo rinomino in "SYSLINUX.CFG". Aggiungo anche "-p 1" alla linea "APPEND -c boot.cfg".
{{< gallery match="images/8/*.png" >}}
ertig! Ora il bastone è utilizzabile. Buon divertimento!
{{< gallery match="images/9/*.png" >}}
