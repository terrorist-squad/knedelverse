+++
date = "2021-03-07"
title = "Installer ESXi sur un NUC. Préparer une clé USB via un MacBook."
difficulty = "level-4"
tags = ["esxi", "homelab", "hypervisor", "linux", "nuc", "vmware"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/march/20210307-esxi-nuc/index.fr.md"
+++
Avec ESXi, le "intel NUC" peut être divisé en autant d'ordinateurs que l'on veut. Dans ce tutoriel, je montre comment j'ai installé VMware ESXi sur mon NUC.Petit préambule : je recommande une mise à jour du BIOS avant l'installation d'ESXi. De plus, une clé USB de 32 Go est nécessaire. J'ai acheté un bundle entier pour moins de 5 euros pièce sur Amazon.
{{< gallery match="images/1/*.jpg" >}}
Mon NUC-8I7BEH est équipé de 2x 16 GB HyperX Impact Ram, 1x 256GB Samsung 970 EVO M2 module et un disque dur WD-RED de 1TB 2,5 pouces.
{{< gallery match="images/2/*.jpg" >}}

## Étape 1 : trouver une clé USB
La commande suivante m'affiche tous les lecteurs :
{{< terminal >}}
diskutil list

{{</ terminal >}}
On peut voir ici que ma clé USB porte l'identifiant "disk2" :
{{< gallery match="images/3/*.png" >}}

## Étape 2 : préparer le système de fichiers
Je peux maintenant utiliser la commande suivante pour préparer le système de fichiers :
{{< terminal >}}
$ diskutil eraseDisk MS-DOS "ESXI" MBR disk2

{{</ terminal >}}
Ensuite, je vois également l'identifiant dans le Finder :
{{< gallery match="images/4/*.png" >}}

## Etape 3 : Ejecter la clé USB
J'utilise la commande "unmountDisk" pour éjecter le volume :
{{< terminal >}}
$ diskutil unmountDisk /dev/disk2

{{</ terminal >}}
Voir
{{< gallery match="images/5/*.png" >}}

## Etape 4 : rendre la clé amorçable
Maintenant, nous tapons la commande "sudo fdisk -e /dev/disk2" et ensuite "f 1", "write" et "quit", voir :
{{< gallery match="images/6/*.png" >}}

## Étape 5 : Copier les données
Maintenant, je dois télécharger l'ISO ESXi : https://www.vmware.com/de/try-vmware.html. Ensuite, je peux monter l'ISO ESXi et copier son contenu sur ma clé USB.
{{< gallery match="images/7/*.png" >}}
Une fois que tout est copié, je recherche le fichier "ISOLINUX.CFG" et le renomme "SYSLINUX.CFG". J'ajoute également "-p 1" à la ligne "APPEND -c boot.cfg".
{{< gallery match="images/8/*.png" >}}
ertig ! La clé est maintenant utilisable. Amusez-vous bien !
{{< gallery match="images/9/*.png" >}}