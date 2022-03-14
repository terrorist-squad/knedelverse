+++
date = "2021-03-07"
title = "Inštalácia ESXi na NUC. Pripravte si kľúč USB prostredníctvom MacBooku."
difficulty = "level-4"
tags = ["esxi", "homelab", "hypervisor", "linux", "nuc", "vmware"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/march/20210307-esxi-nuc/index.sk.md"
+++
Pomocou systému ESXi možno počítač intel NUC rozdeliť na ľubovoľný počet počítačov. V tomto návode ukážem, ako som nainštaloval VMware ESXi na svoj NUC.Malý úvod: Pred inštaláciou ESXi odporúčam aktualizovať BIOS. Budete tiež potrebovať 32GB kľúč USB. Kúpil som si celý balík za menej ako 5 eur za kus z Amazonu.
{{< gallery match="images/1/*.jpg" >}}
Môj NUC-8I7BEH má 2x 16 GB RAM HyperX Impact, 1x 256 GB modul Samsung 970 EVO M2 a 1 TB 2,5-palcový pevný disk WD-RED.
{{< gallery match="images/2/*.jpg" >}}

## Krok 1: Nájdite USB - Stick
Nasledujúci príkaz mi zobrazí všetky jednotky:
{{< terminal >}}
diskutil list

{{</ terminal >}}
Tu môžete vidieť, že môj kľúč USB má identifikátor "disk2":
{{< gallery match="images/3/*.png" >}}

## Krok 2: Príprava súborového systému
Teraz môžem použiť nasledujúci príkaz na prípravu súborového systému:
{{< terminal >}}
$ diskutil eraseDisk MS-DOS "ESXI" MBR disk2

{{</ terminal >}}
Potom sa identifikátor zobrazí aj v aplikácii Finder:
{{< gallery match="images/4/*.png" >}}

## Krok 3: Vysunutie kľúča USB
Na vysunutie zväzku používam príkaz "unmountDisk":
{{< terminal >}}
$ diskutil unmountDisk /dev/disk2

{{</ terminal >}}
Pozri:
{{< gallery match="images/5/*.png" >}}

## Krok 4: Spustite disk
Teraz zadáme príkaz "sudo fdisk -e /dev/disk2" a potom zadajte "f 1", "write" a "quit", pozri:
{{< gallery match="images/6/*.png" >}}

## Krok 5: Kopírovanie údajov
Teraz musím stiahnuť ESXi-ISO: https://www.vmware.com/de/try-vmware.html. Potom môžem pripojiť ESXi-ISO a skopírovať obsah na kľúč USB.
{{< gallery match="images/7/*.png" >}}
Keď je všetko skopírované, vyhľadám súbor "ISOLINUX.CFG" a premenujem ho na "SYSLINUX.CFG". Do riadku "APPEND -c boot.cfg" pridám aj "-p 1".
{{< gallery match="images/8/*.png" >}}
ertig! Teraz je palica použiteľná. Bavte sa!
{{< gallery match="images/9/*.png" >}}