+++
date = "2021-04-11"
title = "Krótka historia: Podłączanie woluminów Synology do ESXi."
difficulty = "level-1"
tags = ["dos", "esxi", "khk-kaufmann-v1", "nuc", "pc-kaufmann", "Synology", "vmware"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210411-esxi-mount/index.pl.md"
+++

## Krok 1: Aktywacja usługi "NFS
Najpierw należy aktywować usługę "NFS" w stacji Diskstation. W tym celu przechodzę do ustawień "Panel sterowania" > "Usługi plików" i klikam na "Włącz NFS".
{{< gallery match="images/1/*.png" >}}
Następnie klikam "Folder współdzielony" i wybieram katalog.
{{< gallery match="images/2/*.png" >}}

## Krok 2: Montowanie katalogów w ESXi
W ESXi klikam na "Storage" > "New datastore" i wprowadzam tam swoje dane.
{{< gallery match="images/3/*.png" >}}

## Gotowe
Teraz można korzystać z pamięci.
{{< gallery match="images/4/*.png" >}}
Na potrzeby testów zainstalowałem za pośrednictwem tego punktu montowania instalację systemu DOS oraz stary program księgowy.
{{< gallery match="images/5/*.png" >}}

