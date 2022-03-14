+++
date = "2021-03-07"
title = "ESXi auf einem NUC installieren. USB-Stick via MacBook präparieren."
difficulty = "level-4"
tags = ["esxi", "homelab", "hypervisor", "linux", "nuc", "vmware"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/march/20210307-esxi-nuc/index.de.md"
+++

Mit ESXi lässt sich der „intel NUC“ in beliebige viele Computer unterteilen. In diesem Tutorial zeige ich, wie ich VMware ESXi auf meinen NUC installiert habe.

Kleines Vorwort: Ich empfehle ein BIOS-Update vor der ESXi-Installation. Außerdem wird ein 32GB USB-Stick benötigt. Ich habe ein ganzen Bundle für weniger als 5 Euro pro Stück bei Amazon gekauft.
{{< gallery match="images/1/*.jpg" >}}

In meinem NUC-8I7BEH ist 2x 16 GB HyperX Impact Ram, 1x 256GB Samsung 970 EVO M2-Modul und eine 1TB 2,5 Zoll WD-RED Festplatte verbaut.
{{< gallery match="images/2/*.jpg" >}}

## Schritt 1: USB – Stick finden
Der folgende Befehl zeigt mir alle Laufwerke an:
{{< terminal >}}
diskutil list
{{</ terminal >}}

Hier ist zu sehen, dass meinen USB-Stick den Identifier „disk2“ trägt:
{{< gallery match="images/3/*.png" >}}

## Schritt 2: Dateisystem vorbereiten
Nun kann ich den folgenden Befehl nutzen, um das Dateisystem vorzubereiten:
{{< terminal >}}
$ diskutil eraseDisk MS-DOS "ESXI" MBR disk2
{{</ terminal >}}

Danach sehe ich auch im Finder den Bezeichner:
{{< gallery match="images/4/*.png" >}}

## Schritt 3: USB-Stick auswerfen
Ich nutze den „unmountDisk“-Befehl um das Volume auszuwerfen:
{{< terminal >}}
$ diskutil unmountDisk /dev/disk2
{{</ terminal >}}

Siehe:
{{< gallery match="images/5/*.png" >}}

## Schritt 4: Stick bootbar machen
Nun geben wir den Befehl „sudo fdisk -e /dev/disk2“ ein und geben anschließend „f 1„, „write“ und „quit“ ein, siehe:
{{< gallery match="images/6/*.png" >}}

## Schritt 5: Daten kopieren
Jetzt muss ich die ESXi-ISO heruntergeladen: https://www.vmware.com/de/try-vmware.html. Danach kann ich das ESXi-ISO mounten und den Inhalt auf meinen USB-Stick kopieren.
{{< gallery match="images/7/*.png" >}}

Wenn alles kopiert ist, dann suche ich die Datei „ISOLINUX.CFG“ und benenne diese in „SYSLINUX.CFG“ um. Außerdem füge ich "-p 1“ in der Zeile „APPEND -c boot.cfg“ hinzu.
{{< gallery match="images/8/*.png" >}}

ertig! Nun ist der Stick nutzbar. Viel Spaß!
{{< gallery match="images/9/*.png" >}}