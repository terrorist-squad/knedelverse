+++
date = "2020-02-14"
title = "PDF-pagina-overzicht genereren"
difficulty = "level-3"
tags = ["bash", "linux", "pdf", "postscript", "imagemagick"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2020/february/20200214-imagemagick-pdf-overview/index.nl.md"
+++
Als u een pagina-overzichtsafbeelding wilt maken van een PDF-bestand, dan bent u hier aan het juiste adres!
{{< gallery match="images/1/*.jpg" >}}

## Stap 1: Maak een werkmap
Gebruik dit commando om een tijdelijke werkmap te maken:
{{< terminal >}}
mkdir /tmp/bilder

{{</ terminal >}}

## Stap 2: Afzonderlijke pagina
Het volgende commando maakt een afbeelding van elke PDF pagina:
{{< terminal >}}
convert 716023b632a9cbe6cad3ab368c202288.pdf /tmp/bilder/page.png

{{</ terminal >}}

## Stap 3: Monteren van de beelden
Nu moet de collage alleen nog in elkaar gezet worden:
{{< terminal >}}
montage /tmp/bilder/* -shadow -geometry '400x400+2+2>' -background '#f1f1f1' uebersich.jpg

{{</ terminal >}}
