+++
date = "2020-02-14"
title = "Generar un resumen de páginas en PDF"
difficulty = "level-3"
tags = ["bash", "linux", "pdf", "postscript", "imagemagick"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2020/february/20200214-imagemagick-pdf-overview/index.es.md"
+++
Si desea crear una imagen de resumen de página a partir de un archivo PDF, ha llegado al lugar adecuado.
{{< gallery match="images/1/*.jpg" >}}

## Paso 1: Crear la carpeta de trabajo
Utilice este comando para crear una carpeta de trabajo temporal:
{{< terminal >}}
mkdir /tmp/bilder

{{</ terminal >}}

## Paso 2: Página separada
El siguiente comando crea una imagen de cada página del PDF:
{{< terminal >}}
convert 716023b632a9cbe6cad3ab368c202288.pdf /tmp/bilder/page.png

{{</ terminal >}}

## Paso 3: Montaje de las imágenes
Ahora sólo falta montar el collage:
{{< terminal >}}
montage /tmp/bilder/* -shadow -geometry '400x400+2+2>' -background '#f1f1f1' uebersich.jpg

{{</ terminal >}}

