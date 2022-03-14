+++
date = "2020-02-14"
title = "Generere PDF-sideoversigt"
difficulty = "level-3"
tags = ["bash", "linux", "pdf", "postscript", "imagemagick"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2020/february/20200214-imagemagick-pdf-overview/index.da.md"
+++
Hvis du ønsker at oprette et sideoversigtsbillede fra en PDF-fil, er du kommet til det rette sted!
{{< gallery match="images/1/*.jpg" >}}

## Trin 1: Opret en arbejdsmappe
Brug denne kommando til at oprette en midlertidig arbejdsmappe:
{{< terminal >}}
mkdir /tmp/bilder

{{</ terminal >}}

## Trin 2: Separat side
Følgende kommando opretter et billede af hver PDF-side:
{{< terminal >}}
convert 716023b632a9cbe6cad3ab368c202288.pdf /tmp/bilder/page.png

{{</ terminal >}}

## Trin 3: Montering af billederne
Nu skal collagen bare sættes sammen:
{{< terminal >}}
montage /tmp/bilder/* -shadow -geometry '400x400+2+2>' -background '#f1f1f1' uebersich.jpg

{{</ terminal >}}
