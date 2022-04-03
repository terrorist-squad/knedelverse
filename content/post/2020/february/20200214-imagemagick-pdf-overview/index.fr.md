+++
date = "2020-02-14"
title = "Générer un aperçu des pages PDF"
difficulty = "level-3"
tags = ["bash", "linux", "pdf", "postscript", "imagemagick"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2020/february/20200214-imagemagick-pdf-overview/index.fr.md"
+++
Si vous souhaitez créer une image d'aperçu de la page à partir d'un fichier PDF, vous êtes au bon endroit !
{{< gallery match="images/1/*.jpg" >}}

## Étape 1 : Créer un dossier de travail
Cette commande permet de créer un dossier de travail temporaire :
{{< terminal >}}
mkdir /tmp/bilder

{{</ terminal >}}

## Étape 2 : Séparer la page
La commande suivante permet de créer une image de chaque page PDF :
{{< terminal >}}
convert 716023b632a9cbe6cad3ab368c202288.pdf /tmp/bilder/page.png

{{</ terminal >}}

## Étape 3 : Montage des images
Il ne reste plus qu'à assembler le collage :
{{< terminal >}}
montage /tmp/bilder/* -shadow -geometry '400x400+2+2>' -background '#f1f1f1' uebersich.jpg

{{</ terminal >}}

