+++
date = "2021-03-07"
title = "Instalace ESXi do počítače NUC. Připravte si USB disk prostřednictvím MacBooku."
difficulty = "level-4"
tags = ["esxi", "homelab", "hypervisor", "linux", "nuc", "vmware"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/march/20210307-esxi-nuc/index.cs.md"
+++
Pomocí ESXi lze "intel NUC" rozdělit na libovolný počet počítačů. V tomto návodu ukážu, jak jsem nainstaloval VMware ESXi na svůj počítač NUC.Malá předmluva: Před instalací ESXi doporučuji provést aktualizaci systému BIOS. Budete také potřebovat 32GB USB disk. Koupil jsem si celý balík za méně než 5 eur za kus na Amazonu.
{{< gallery match="images/1/*.jpg" >}}
Můj NUC-8I7BEH má 2x 16 GB paměti HyperX Impact Ram, 1x 256GB modul Samsung 970 EVO M2 a 1TB 2,5palcový pevný disk WD-RED.
{{< gallery match="images/2/*.jpg" >}}

## Krok 1: Najděte USB - Stick
Následující příkaz mi zobrazí všechny jednotky:
{{< terminal >}}
diskutil list

{{</ terminal >}}
Zde vidíte, že můj disk USB má identifikátor "disk2":
{{< gallery match="images/3/*.png" >}}

## Krok 2: Příprava souborového systému
Nyní mohu použít následující příkaz k přípravě souborového systému:
{{< terminal >}}
$ diskutil eraseDisk MS-DOS "ESXI" MBR disk2

{{</ terminal >}}
Poté se identifikátor zobrazí také ve Finderu:
{{< gallery match="images/4/*.png" >}}

## Krok 3: Vysunutí paměti USB
K vysunutí svazku použiji příkaz "unmountDisk":
{{< terminal >}}
$ diskutil unmountDisk /dev/disk2

{{</ terminal >}}
Viz:
{{< gallery match="images/5/*.png" >}}

## Krok 4: Vytvoření bootovací paměti
Nyní zadáme příkaz "sudo fdisk -e /dev/disk2" a poté zadáme "f 1", "write" a "quit", viz:
{{< gallery match="images/6/*.png" >}}

## Krok 5: Kopírování dat
Nyní musím stáhnout ESXi-ISO: https://www.vmware.com/de/try-vmware.html. Poté mohu připojit ESXi-ISO a zkopírovat obsah na USB disk.
{{< gallery match="images/7/*.png" >}}
Když je vše zkopírováno, vyhledám soubor "ISOLINUX.CFG" a přejmenuji jej na "SYSLINUX.CFG". Do řádku "APPEND -c boot.cfg" také přidám "-p 1".
{{< gallery match="images/8/*.png" >}}
ertig! Nyní je hůl použitelná. Bavte se!
{{< gallery match="images/9/*.png" >}}