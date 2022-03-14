+++
date = "2021-04-11"
title = "Kurzgeschichte: Synology-Volumen mit ESXi verbinden."
difficulty = "level-1"
tags = ["dos", "esxi", "khk-kaufmann-v1", "nuc", "pc-kaufmann", "Synology", "vmware"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/april/20210411-esxi-mount/index.de.md"
+++

## Schritt 1: „NFS“-Dienst aktivieren
Als erstes muss der „NFS“-Dienst auf der Diskstation aktiviert werden. Dazu gehe ich in die Einstellung „Systemsteuerung“ > „Dateidienste“ und klicke auf „NFS aktivieren“.
{{< gallery match="images/1/*.png" >}}

Anschließend klicke ich auf „Gemeinsamer Ordner“ und wähle ein Verzeichnis aus.
{{< gallery match="images/2/*.png" >}}

## Schritt 2: Verzeichnisse in ESXi mounten
In ESXi klicke ich auf „Speicher“ > „Neuer Datenspeicher“ und trage dort meine Daten ein.
{{< gallery match="images/3/*.png" >}}

## Fertig
Nun kann der Speicher genutzt werden.
{{< gallery match="images/4/*.png" >}}

Zum Test habe ich eine DOS-Installation und eine alte Buchhaltungssoftware über diesen Mount-Punkt installiert. 
{{< gallery match="images/5/*.png" >}}

