+++
date = "2021-03-07"
title = "Installeer ESXi op een NUC. Maak de USB-stick klaar via de MacBook."
difficulty = "level-4"
tags = ["esxi", "homelab", "hypervisor", "linux", "nuc", "vmware"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/march/20210307-esxi-nuc/index.nl.md"
+++
Met ESXi kan de "intel NUC" worden verdeeld in een willekeurig aantal computers. In deze tutorial laat ik zien hoe ik VMware ESXi op mijn NUC installeerde.Klein voorwoord: ik raad een BIOS update aan vóór de ESXi installatie. U hebt ook een USB-stick van 32 GB nodig. Ik kocht een hele bundel voor minder dan 5 euro per stuk van Amazon.
{{< gallery match="images/1/*.jpg" >}}
Mijn NUC-8I7BEH heeft 2x 16GB HyperX Impact Ram, 1x 256GB Samsung 970 EVO M2 module en een 1TB 2.5-inch WD-RED harde schijf.
{{< gallery match="images/2/*.jpg" >}}

## Stap 1: USB-stick vinden
Het volgende commando toont me alle schijven:
{{< terminal >}}
diskutil list

{{</ terminal >}}
Hier kunt u zien dat mijn USB-stick de identificatie "disk2" heeft:
{{< gallery match="images/3/*.png" >}}

## Stap 2: Bestandssysteem voorbereiden
Nu kan ik het volgende commando gebruiken om het bestandssysteem voor te bereiden:
{{< terminal >}}
$ diskutil eraseDisk MS-DOS "ESXI" MBR disk2

{{</ terminal >}}
Daarna zie ik de identificatie ook in de Finder:
{{< gallery match="images/4/*.png" >}}

## Stap 3: USB-stick uitwerpen
Ik gebruik de opdracht "unmountDisk" om het volume uit te werpen:
{{< terminal >}}
$ diskutil unmountDisk /dev/disk2

{{</ terminal >}}
Zie:
{{< gallery match="images/5/*.png" >}}

## Stap 4: Maak de stick bootable
Nu voeren we het commando "sudo fdisk -e /dev/disk2" in en daarna "f 1", "write" en "quit", zie:
{{< gallery match="images/6/*.png" >}}

## Stap 5: Gegevens kopiëren
Nu moet ik de ESXi-ISO downloaden: https://www.vmware.com/de/try-vmware.html. Daarna kan ik de ESXi-ISO mounten en de inhoud naar mijn USB stick kopiëren.
{{< gallery match="images/7/*.png" >}}
Wanneer alles gekopieerd is, zoek ik naar het bestand "ISOLINUX.CFG" en hernoem het naar "SYSLINUX.CFG". Ik voeg ook "-p 1" toe aan de regel "APPEND -c boot.cfg".
{{< gallery match="images/8/*.png" >}}
ertig! Nu is de stok bruikbaar. Veel plezier!
{{< gallery match="images/9/*.png" >}}