+++
date = "2021-04-11"
title = "Pe scurt: Conectarea volumelor Synology la ESXi."
difficulty = "level-1"
tags = ["dos", "esxi", "khk-kaufmann-v1", "nuc", "pc-kaufmann", "Synology", "vmware"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/april/20210411-esxi-mount/index.ro.md"
+++

## Pasul 1: Activați serviciul "NFS".
În primul rând, serviciul "NFS" trebuie să fie activat pe Diskstation. Pentru a face acest lucru, mă duc la "Control Panel" > "File Services" și fac clic pe "Enable NFS".
{{< gallery match="images/1/*.png" >}}
Apoi fac clic pe "Shared folder" și selectez un director.
{{< gallery match="images/2/*.png" >}}

## Pasul 2: Montați directoarele în ESXi
În ESXi, fac clic pe "Storage" > "New datastore" și introduc datele mele acolo.
{{< gallery match="images/3/*.png" >}}

## Gata
Acum memoria poate fi utilizată.
{{< gallery match="images/4/*.png" >}}
Pentru testare, am instalat o instalație DOS și un vechi software de contabilitate prin intermediul acestui punct de montare.
{{< gallery match="images/5/*.png" >}}
