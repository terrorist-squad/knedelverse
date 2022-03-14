+++
date = "2021-04-11"
title = "Kort verhaal: Synology volumes verbinden met ESXi."
difficulty = "level-1"
tags = ["dos", "esxi", "khk-kaufmann-v1", "nuc", "pc-kaufmann", "Synology", "vmware"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/april/20210411-esxi-mount/index.nl.md"
+++

## Stap 1: Activeer de "NFS" dienst
Eerst moet de "NFS" dienst geactiveerd worden op het Diskstation. Om dit te doen, ga ik naar het "Configuratiescherm" > "Bestandsservices" instelling en klik op "NFS inschakelen".
{{< gallery match="images/1/*.png" >}}
Dan klik ik op "Gedeelde map" en selecteer een map.
{{< gallery match="images/2/*.png" >}}

## Stap 2: Mount mappen in ESXi
In ESXi, klik ik op "Storage" > "New datastore" en voer daar mijn gegevens in.
{{< gallery match="images/3/*.png" >}}

## Klaar
Nu kan het geheugen gebruikt worden.
{{< gallery match="images/4/*.png" >}}
Om te testen, installeerde ik een DOS installatie en een oud boekhoudprogramma via dit koppelpunt.
{{< gallery match="images/5/*.png" >}}
