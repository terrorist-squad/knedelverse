+++
date = "2021-04-11"
title = "Brève histoire : Connecter des volumes Synology à ESXi."
difficulty = "level-1"
tags = ["dos", "esxi", "khk-kaufmann-v1", "nuc", "pc-kaufmann", "Synology", "vmware"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/april/20210411-esxi-mount/index.fr.md"
+++

## Étape 1 : Activer le service "NFS".
La première chose à faire est d'activer le service "NFS" sur le Diskstation. Pour cela, je vais dans le paramètre "Panneau de configuration" > "Services de fichiers" et je clique sur "Activer NFS".
{{< gallery match="images/1/*.png" >}}
Ensuite, je clique sur "Dossier partagé" et je sélectionne un répertoire.
{{< gallery match="images/2/*.png" >}}

## Étape 2 : Monter des répertoires dans ESXi
Dans ESXi, je clique sur "Stockage" > "Nouveau magasin de données" et j'y entre mes données.
{{< gallery match="images/3/*.png" >}}

## Prêt
La mémoire peut maintenant être utilisée.
{{< gallery match="images/4/*.png" >}}
Pour tester, j'ai installé une installation DOS et un ancien logiciel de comptabilité via ce point de montage.
{{< gallery match="images/5/*.png" >}}
