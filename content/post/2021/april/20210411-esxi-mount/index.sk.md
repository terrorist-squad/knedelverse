+++
date = "2021-04-11"
title = "Krátky príbeh: Pripojenie zväzkov Synology k ESXi."
difficulty = "level-1"
tags = ["dos", "esxi", "khk-kaufmann-v1", "nuc", "pc-kaufmann", "Synology", "vmware"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/april/20210411-esxi-mount/index.sk.md"
+++

## Krok 1: Aktivácia služby "NFS"
Najprv je potrebné aktivovať službu "NFS" na stanici Diskstation. Ak to chcete urobiť, prejdite do nastavenia "Ovládací panel" > "Súborové služby" a kliknite na položku "Povoliť NFS".
{{< gallery match="images/1/*.png" >}}
Potom kliknem na položku Zdieľaný priečinok a vyberiem adresár.
{{< gallery match="images/2/*.png" >}}

## Krok 2: Pripojenie adresárov v ESXi
V ESXi kliknem na "Storage" > "New datastore" a zadám tam svoje údaje.
{{< gallery match="images/3/*.png" >}}

## Pripravené
Teraz je možné používať pamäť.
{{< gallery match="images/4/*.png" >}}
Na testovanie som nainštaloval inštaláciu systému DOS a starý účtovný softvér prostredníctvom tohto prípojného bodu.
{{< gallery match="images/5/*.png" >}}
