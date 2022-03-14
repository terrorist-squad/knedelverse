+++
date = "2021-04-11"
title = "Kort fortalt: Tilslutning af Synology-volumener til ESXi."
difficulty = "level-1"
tags = ["dos", "esxi", "khk-kaufmann-v1", "nuc", "pc-kaufmann", "Synology", "vmware"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210411-esxi-mount/index.da.md"
+++

## Trin 1: Aktivér "NFS"-tjenesten
Først skal "NFS"-tjenesten aktiveres på Diskstation. For at gøre dette går jeg til "Kontrolpanel" > "Filtjenester" og klikker på "Aktiver NFS".
{{< gallery match="images/1/*.png" >}}
Derefter klikker jeg på "Shared folder" (delt mappe) og vælger en mappe.
{{< gallery match="images/2/*.png" >}}

## Trin 2: Monter mapper i ESXi
I ESXi klikker jeg på "Storage" > "New datastore" og indtaster mine data der.
{{< gallery match="images/3/*.png" >}}

## Klar
Nu kan hukommelsen bruges.
{{< gallery match="images/4/*.png" >}}
Til test installerede jeg en DOS-installation og et gammelt regnskabsprogram via dette monteringspunkt.
{{< gallery match="images/5/*.png" >}}
