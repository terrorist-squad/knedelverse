+++
date = "2021-04-11"
title = "Kort berättelse: Anslutning av Synology-volymer till ESXi."
difficulty = "level-1"
tags = ["dos", "esxi", "khk-kaufmann-v1", "nuc", "pc-kaufmann", "Synology", "vmware"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210411-esxi-mount/index.sv.md"
+++

## Steg 1: Aktivera tjänsten "NFS".
Först måste NFS-tjänsten aktiveras på Diskstation. För att göra detta går jag till inställningen "Control Panel" > "File Services" och klickar på "Enable NFS" (aktivera NFS).
{{< gallery match="images/1/*.png" >}}
Jag klickar sedan på "Delad mapp" och väljer en katalog.
{{< gallery match="images/2/*.png" >}}

## Steg 2: Montera kataloger i ESXi
I ESXi klickar jag på "Storage" (lagring) > "New datastore" (nytt datalager) och skriver in mina data där.
{{< gallery match="images/3/*.png" >}}

## Redo
Nu kan minnet användas.
{{< gallery match="images/4/*.png" >}}
För att testa installerade jag en DOS-installation och ett gammalt bokföringsprogram via denna monteringspunkt.
{{< gallery match="images/5/*.png" >}}

