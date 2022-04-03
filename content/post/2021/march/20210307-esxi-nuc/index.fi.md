+++
date = "2021-03-07"
title = "Asenna ESXi NUC:lle. Valmistele USB-tikku MacBookin kautta."
difficulty = "level-4"
tags = ["esxi", "homelab", "hypervisor", "linux", "nuc", "vmware"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/march/20210307-esxi-nuc/index.fi.md"
+++
ESXi:n avulla "intel NUC" voidaan jakaa mihin tahansa määrään tietokoneita. Tässä opetusohjelmassa näytän, miten asensin VMware ESXi:n NUC-tietokoneeseeni.Pieni esipuhe: suosittelen BIOS-päivitystä ennen ESXi-asennusta. Tarvitset myös 32 Gt:n USB-tikun. Ostin koko nipun alle 5 eurolla kappale Amazonista.
{{< gallery match="images/1/*.jpg" >}}
NUC-8I7BEH-mallissani on 2x 16GB HyperX Impact Ram, 1x 256GB Samsung 970 EVO M2 -moduuli ja 1TB 2,5-tuumainen WD-RED-kiintolevy.
{{< gallery match="images/2/*.jpg" >}}

## Vaihe 1: Etsi USB-tikku
Seuraava komento näyttää kaikki asemat:
{{< terminal >}}
diskutil list

{{</ terminal >}}
Tässä näet, että USB-tikkuni tunniste on "disk2":
{{< gallery match="images/3/*.png" >}}

## Vaihe 2: Valmistele tiedostojärjestelmä
Nyt voin valmistella tiedostojärjestelmän seuraavalla komennolla:
{{< terminal >}}
$ diskutil eraseDisk MS-DOS "ESXI" MBR disk2

{{</ terminal >}}
Sen jälkeen näen tunnisteen myös Finderissa:
{{< gallery match="images/4/*.png" >}}

## Vaihe 3: Poista USB-tikku
Käytän komentoa "unmountDisk" poistamaan levyn:
{{< terminal >}}
$ diskutil unmountDisk /dev/disk2

{{</ terminal >}}
Katso:
{{< gallery match="images/5/*.png" >}}

## Vaihe 4: Tee tikusta käynnistettävä
Nyt annamme komennon "sudo fdisk -e /dev/disk2" ja sitten "f 1", "write" ja "quit", katso:
{{< gallery match="images/6/*.png" >}}

## Vaihe 5: Kopioi tiedot
Nyt minun on ladattava ESXi-ISO: https://www.vmware.com/de/try-vmware.html. Sen jälkeen voin asentaa ESXi-ISO-levyn ja kopioida sen sisällön USB-tikulle.
{{< gallery match="images/7/*.png" >}}
Kun kaikki on kopioitu, etsin tiedoston "ISOLINUX.CFG" ja nimeän sen uudelleen muotoon "SYSLINUX.CFG". Lisään myös "-p 1" riville "APPEND -c boot.cfg".
{{< gallery match="images/8/*.png" >}}
ertig! Nyt tikku on käyttökelpoinen. Pidä hauskaa!
{{< gallery match="images/9/*.png" >}}
