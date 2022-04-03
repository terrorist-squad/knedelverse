+++
date = "2021-03-07"
title = "Instalați ESXi pe un NUC. Pregătiți stick-ul USB prin intermediul MacBook."
difficulty = "level-4"
tags = ["esxi", "homelab", "hypervisor", "linux", "nuc", "vmware"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/march/20210307-esxi-nuc/index.ro.md"
+++
Cu ESXi, "intel NUC" poate fi împărțit în orice număr de calculatoare. În acest tutorial, vă arăt cum am instalat VMware ESXi pe NUC-ul meu.O mică prefață: vă recomand o actualizare a BIOS-ului înainte de instalarea ESXi. De asemenea, veți avea nevoie de un stick USB de 32 GB. Am cumpărat un pachet întreg la mai puțin de 5 euro fiecare de pe Amazon.
{{< gallery match="images/1/*.jpg" >}}
NUC-8I7BEH are 2x 16GB HyperX Impact Ram, 1x 256GB Samsung 970 EVO M2 și un hard disk WD-RED de 1TB de 2,5 inch.
{{< gallery match="images/2/*.jpg" >}}

## Pasul 1: Găsiți USB - Stick
Următoarea comandă îmi arată toate unitățile:
{{< terminal >}}
diskutil list

{{</ terminal >}}
Aici puteți vedea că stick-ul meu USB are identificatorul "disk2":
{{< gallery match="images/3/*.png" >}}

## Pasul 2: Pregătiți sistemul de fișiere
Acum pot utiliza următoarea comandă pentru a pregăti sistemul de fișiere:
{{< terminal >}}
$ diskutil eraseDisk MS-DOS "ESXI" MBR disk2

{{</ terminal >}}
După aceea, văd identificatorul și în Finder:
{{< gallery match="images/4/*.png" >}}

## Pasul 3: Ejectați stick-ul USB
Folosesc comanda "unmountDisk" pentru a ejecta volumul:
{{< terminal >}}
$ diskutil unmountDisk /dev/disk2

{{</ terminal >}}
A se vedea:
{{< gallery match="images/5/*.png" >}}

## Pasul 4: Faceți stick-ul bootabil
Acum introducem comanda "sudo fdisk -e /dev/disk2" și apoi introducem "f 1", "write" și "quit", vezi:
{{< gallery match="images/6/*.png" >}}

## Pasul 5: Copierea datelor
Acum trebuie să descarc ESXi-ISO: https://www.vmware.com/de/try-vmware.html. După aceea, pot monta ESXi-ISO și pot copia conținutul pe stick-ul USB.
{{< gallery match="images/7/*.png" >}}
Când totul este copiat, caut fișierul "ISOLINUX.CFG" și îl redenumesc în "SYSLINUX.CFG". De asemenea, am adăugat "-p 1" la linia "APPEND -c boot.cfg".
{{< gallery match="images/8/*.png" >}}
ertig! Acum bățul este utilizabil. Distracție plăcută!
{{< gallery match="images/9/*.png" >}}
