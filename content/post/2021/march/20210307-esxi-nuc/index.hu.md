+++
date = "2021-03-07"
title = "Az ESXi telepítése egy NUC-ra. Készítse elő az USB-pendrive-ot a MacBookon keresztül."
difficulty = "level-4"
tags = ["esxi", "homelab", "hypervisor", "linux", "nuc", "vmware"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/march/20210307-esxi-nuc/index.hu.md"
+++
Az ESXi segítségével az "intel NUC" tetszőleges számú számítógépre osztható. Ebben a bemutatóban megmutatom, hogyan telepítettem a VMware ESXi-t a NUC-omra.Kis előszó: az ESXi telepítése előtt ajánlom a BIOS frissítését. Szüksége lesz egy 32 GB-os USB-pendrive-ra is. Egy egész csomagot vettem az Amazonon kevesebb mint 5 euróért darabonként.
{{< gallery match="images/1/*.jpg" >}}
Az én NUC-8I7BEH-mben 2x 16GB HyperX Impact Ram, 1x 256GB Samsung 970 EVO M2 modul és egy 1TB 2,5 hüvelykes WD-RED merevlemez található.
{{< gallery match="images/2/*.jpg" >}}

## 1. lépés: Keresse meg az USB - Stick-et
A következő parancs megmutatja az összes meghajtót:
{{< terminal >}}
diskutil list

{{</ terminal >}}
Itt látható, hogy az USB-pendrive-om azonosítója "disk2":
{{< gallery match="images/3/*.png" >}}

## 2. lépés: A fájlrendszer előkészítése
Most már a következő paranccsal tudom előkészíteni a fájlrendszert:
{{< terminal >}}
$ diskutil eraseDisk MS-DOS "ESXI" MBR disk2

{{</ terminal >}}
Ezután a Finderben is látom az azonosítót:
{{< gallery match="images/4/*.png" >}}

## 3. lépés: USB-pendrive kivetítése
Az "unmountDisk" parancsot használom a kötet eltávolítására:
{{< terminal >}}
$ diskutil unmountDisk /dev/disk2

{{</ terminal >}}
Lásd:
{{< gallery match="images/5/*.png" >}}

## 4. lépés: A pendrive bootolhatóvá tétele
Most beírjuk a "sudo fdisk -e /dev/disk2" parancsot, majd beírjuk az "f 1", "write" és "quit" parancsokat, lásd:
{{< gallery match="images/6/*.png" >}}

## 5. lépés: Adatok másolása
Most le kell töltenem az ESXi-ISO-t: https://www.vmware.com/de/try-vmware.html. Ezután csatlakoztathatom az ESXi-ISO-t, és másolhatom a tartalmát az USB-pendrive-ra.
{{< gallery match="images/7/*.png" >}}
Amikor minden másolva van, megkeresem az "ISOLINUX.CFG" fájlt, és átnevezem "SYSLINUX.CFG"-re. A "APPEND -c boot.cfg" sorhoz hozzáadom a "-p 1" szót is.
{{< gallery match="images/8/*.png" >}}
ertig! Most már használható a bot. Jó szórakozást!
{{< gallery match="images/9/*.png" >}}