+++
date = "2021-04-11"
title = "Kratka zgodba: Povezovanje zvezkov Synology z ESXi."
difficulty = "level-1"
tags = ["dos", "esxi", "khk-kaufmann-v1", "nuc", "pc-kaufmann", "Synology", "vmware"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210411-esxi-mount/index.sl.md"
+++

## Korak 1: Aktivacija storitve "NFS"
Najprej je treba na postaji Diskstation aktivirati storitev NFS. To storim tako, da grem v nastavitev "Nadzorna plošča" > "Datotečne storitve" in kliknem na "Omogoči NFS".
{{< gallery match="images/1/*.png" >}}
Nato kliknem na "Skupna mapa" in izberem imenik.
{{< gallery match="images/2/*.png" >}}

## Korak 2: Namestitev imenikov v ESXi
V ESXiju kliknem na "Skladiščenje" > "Novo podatkovno skladišče" in vanj vnesem podatke.
{{< gallery match="images/3/*.png" >}}

## Pripravljen
Zdaj lahko pomnilnik uporabite.
{{< gallery match="images/4/*.png" >}}
Za testiranje sem prek te priključne točke namestil namestitev DOS-a in staro računovodsko programsko opremo.
{{< gallery match="images/5/*.png" >}}

