+++
date = "2020-02-14"
title = "Generare una panoramica delle pagine in PDF"
difficulty = "level-3"
tags = ["bash", "linux", "pdf", "postscript", "imagemagick"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2020/february/20200214-imagemagick-pdf-overview/index.it.md"
+++
Se volete creare un'immagine panoramica della pagina da un file PDF, allora siete nel posto giusto!
{{< gallery match="images/1/*.jpg" >}}

## Passo 1: creare la cartella di lavoro
Usa questo comando per creare una cartella di lavoro temporanea:
{{< terminal >}}
mkdir /tmp/bilder

{{</ terminal >}}

## Passo 2: pagina separata
Il seguente comando crea un'immagine di ogni pagina PDF:
{{< terminal >}}
convert 716023b632a9cbe6cad3ab368c202288.pdf /tmp/bilder/page.png

{{</ terminal >}}

## Passo 3: montare le immagini
Ora il collage deve solo essere messo insieme:
{{< terminal >}}
montage /tmp/bilder/* -shadow -geometry '400x400+2+2>' -background '#f1f1f1' uebersich.jpg

{{</ terminal >}}
