+++
date = "2021-04-11"
title = "Krótka historia: Podłączanie wolumenów Synology do ESXi."
difficulty = "level-1"
tags = ["dos", "esxi", "khk-kaufmann-v1", "nuc", "pc-kaufmann", "Synology", "vmware"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/april/20210411-esxi-mount/index.pl.md"
+++

## Krok 1: Aktywacja usługi "NFS
Najpierw należy aktywować usługę "NFS" w stacji Diskstation. Aby to zrobić, idę do ustawień "Panel sterowania" > "Usługi plików" i klikam na "Włącz NFS".
{{< gallery match="images/1/*.png" >}}
Następnie klikam na "Shared folder" i wybieram katalog.
{{< gallery match="images/2/*.png" >}}

## Krok 2: Montowanie katalogów w ESXi
W ESXi klikam na "Storage" > "New datastore" i wprowadzam tam moje dane.
{{< gallery match="images/3/*.png" >}}

## Gotowe
Teraz pamięć może być używana.
{{< gallery match="images/4/*.png" >}}
Dla testów, zainstalowałem instalację DOS i stary program księgowy poprzez ten punkt montowania.
{{< gallery match="images/5/*.png" >}}
