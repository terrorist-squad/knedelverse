+++
date = "2021-03-07"
title = "Namestitev ESXi v računalnik NUC. Prek računalnika MacBook pripravite ključek USB."
difficulty = "level-4"
tags = ["esxi", "homelab", "hypervisor", "linux", "nuc", "vmware"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/march/20210307-esxi-nuc/index.sl.md"
+++
S sistemom ESXi lahko računalnik intel NUC razdelite na poljubno število računalnikov. V tem priročniku prikazujem, kako sem na svoj računalnik NUC namestil VMware ESXi.Majhen uvod: pred namestitvijo ESXi priporočam posodobitev BIOS-a. Potrebujete tudi ključek USB s kapaciteto 32 GB. Celoten paket sem kupil na Amazonu za manj kot 5 evrov za kos.
{{< gallery match="images/1/*.jpg" >}}
Moj NUC-8I7BEH ima 2x 16GB HyperX Impact Ram, 1x 256GB Samsung 970 EVO M2 modul in 1TB 2,5-palčni trdi disk WD-RED.
{{< gallery match="images/2/*.jpg" >}}

## Korak 1: Poiščite USB - Stick
Naslednji ukaz mi prikaže vse pogone:
{{< terminal >}}
diskutil list

{{</ terminal >}}
Tukaj lahko vidite, da ima moj ključ USB identifikator "disk2":
{{< gallery match="images/3/*.png" >}}

## Korak 2: Priprava datotečnega sistema
Zdaj lahko za pripravo datotečnega sistema uporabim naslednji ukaz:
{{< terminal >}}
$ diskutil eraseDisk MS-DOS "ESXI" MBR disk2

{{</ terminal >}}
Po tem vidim identifikator tudi v iskalniku:
{{< gallery match="images/4/*.png" >}}

## Korak 3: Izvrzite ključek USB
Z ukazom "unmountDisk" izvržem zvezek:
{{< terminal >}}
$ diskutil unmountDisk /dev/disk2

{{</ terminal >}}
Oglejte si:
{{< gallery match="images/5/*.png" >}}

## Korak 4: Zagotovite, da bo stick zagonski
Zdaj vnesemo ukaz "sudo fdisk -e /dev/disk2" in nato vnesemo "f 1", "write" in "quit", glejte:
{{< gallery match="images/6/*.png" >}}

## Korak 5: Kopiranje podatkov
Zdaj moram prenesti ESXi-ISO: https://www.vmware.com/de/try-vmware.html. Nato lahko namestim ESXi-ISO in kopiram vsebino na ključek USB.
{{< gallery match="images/7/*.png" >}}
Ko je vse kopirano, poiščem datoteko "ISOLINUX.CFG" in jo preimenujem v "SYSLINUX.CFG". V vrstico "APPEND -c boot.cfg" dodam tudi "-p 1".
{{< gallery match="images/8/*.png" >}}
ertig! Zdaj je palica uporabna. Zabavajte se!
{{< gallery match="images/9/*.png" >}}