+++
date = "2021-04-11"
title = "Stručný popis: Připojení svazků Synology k ESXi."
difficulty = "level-1"
tags = ["dos", "esxi", "khk-kaufmann-v1", "nuc", "pc-kaufmann", "Synology", "vmware"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/april/20210411-esxi-mount/index.cs.md"
+++

## Krok 1: Aktivace služby "NFS"
Nejprve je třeba na stanici Diskstation aktivovat službu "NFS". To provedu tak, že přejdu do nastavení "Ovládací panely" > "Souborové služby" a kliknu na možnost "Povolit NFS".
{{< gallery match="images/1/*.png" >}}
Pak kliknu na "Sdílená složka" a vyberu adresář.
{{< gallery match="images/2/*.png" >}}

## Krok 2: Připojení adresářů v systému ESXi
V ESXi kliknu na "Úložiště" > "Nové datové úložiště" a zadám tam svá data.
{{< gallery match="images/3/*.png" >}}

## Připraveno
Nyní lze paměť používat.
{{< gallery match="images/4/*.png" >}}
V rámci testování jsem přes tento přípojný bod nainstaloval instalaci systému DOS a starý účetní software.
{{< gallery match="images/5/*.png" >}}
