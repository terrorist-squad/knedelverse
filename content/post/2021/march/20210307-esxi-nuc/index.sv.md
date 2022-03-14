+++
date = "2021-03-07"
title = "Installera ESXi på en NUC. Förbered ett USB-minne via MacBook."
difficulty = "level-4"
tags = ["esxi", "homelab", "hypervisor", "linux", "nuc", "vmware"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/march/20210307-esxi-nuc/index.sv.md"
+++
Med ESXi kan intel NUC delas upp i ett obegränsat antal datorer. I den här handledningen visar jag hur jag installerade VMware ESXi på min NUC.Litet förord: Jag rekommenderar en BIOS-uppdatering före ESXi-installationen. Du behöver också ett USB-minne på 32 GB. Jag köpte en hel bunt för mindre än 5 euro styck från Amazon.
{{< gallery match="images/1/*.jpg" >}}
Min NUC-8I7BEH har 2x 16 GB HyperX Impact Ram, 1x 256 GB Samsung 970 EVO M2-modul och en 1 TB 2,5-tums WD-RED-hårddisk.
{{< gallery match="images/2/*.jpg" >}}

## Steg 1: Hitta ett USB-minne
Följande kommando visar alla enheter:
{{< terminal >}}
diskutil list

{{</ terminal >}}
Här kan du se att mitt USB-minne har identifieringen "disk2":
{{< gallery match="images/3/*.png" >}}

## Steg 2: Förbered filsystemet
Nu kan jag använda följande kommando för att förbereda filsystemet:
{{< terminal >}}
$ diskutil eraseDisk MS-DOS "ESXI" MBR disk2

{{</ terminal >}}
Efter det ser jag också identifieraren i Finder:
{{< gallery match="images/4/*.png" >}}

## Steg 3: Skjut ut USB-minnen
Jag använder kommandot "unmountDisk" för att kasta ut volymen:
{{< terminal >}}
$ diskutil unmountDisk /dev/disk2

{{</ terminal >}}
Se:
{{< gallery match="images/5/*.png" >}}

## Steg 4: Gör en startbar pinne
Nu anger vi kommandot "sudo fdisk -e /dev/disk2" och anger sedan "f 1", "write" och "quit", se:
{{< gallery match="images/6/*.png" >}}

## Steg 5: Kopiera data
Nu måste jag ladda ner ESXi-ISO: https://www.vmware.com/de/try-vmware.html. Därefter kan jag montera ESXi-ISO och kopiera innehållet till mitt USB-minne.
{{< gallery match="images/7/*.png" >}}
När allt är kopierat letar jag efter filen "ISOLINUX.CFG" och döper om den till "SYSLINUX.CFG". Jag lägger också till "-p 1" på raden "APPEND -c boot.cfg".
{{< gallery match="images/8/*.png" >}}
ertig! Nu är pinnen användbar. Ha kul!
{{< gallery match="images/9/*.png" >}}