+++
date = "2021-04-11"
title = "Breve storia: connessione dei volumi Synology a ESXi."
difficulty = "level-1"
tags = ["dos", "esxi", "khk-kaufmann-v1", "nuc", "pc-kaufmann", "Synology", "vmware"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/april/20210411-esxi-mount/index.it.md"
+++

## Passo 1: Attivare il servizio "NFS
Innanzitutto, il servizio "NFS" deve essere attivato sulla Diskstation. Per farlo, vado nell'impostazione "Pannello di controllo" > "File Services" e clicco su "Enable NFS".
{{< gallery match="images/1/*.png" >}}
Poi clicco su "Cartella condivisa" e seleziono una directory.
{{< gallery match="images/2/*.png" >}}

## Passo 2: montare le directory in ESXi
In ESXi, clicco su "Storage" > "New datastore" e vi inserisco i miei dati.
{{< gallery match="images/3/*.png" >}}

## Pronto
Ora la memoria può essere utilizzata.
{{< gallery match="images/4/*.png" >}}
Per testare, ho installato un'installazione DOS e un vecchio software di contabilità attraverso questo punto di montaggio.
{{< gallery match="images/5/*.png" >}}
