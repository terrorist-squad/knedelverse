+++
date = "2020-02-14"
title = "PDF-Seitenübersicht generieren"
difficulty = "level-3"
tags = ["bash", "linux", "pdf", "postscript", "imagemagick"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2020/february/20200214-imagemagick-pdf-overview/index.de.md"
+++

Wenn Sie ein Seiten-Übersichts-Bild von einer PDF-Datei erstellen wollen, dann sind Sie hier richtig!
{{< gallery match="images/1/*.jpg" >}}

## Schritt 1: Arbeitsordner erstellen
Mit diesem Befehl erstellen Sie einen temporären Arbeitsordner:
{{< terminal >}}
mkdir /tmp/bilder
{{</ terminal >}}


## Schritt 2: Seite separieren
Mit dem folgenden Befehl wird ein Bild von jeder PDF-Seite erstellt:
{{< terminal >}}
convert 716023b632a9cbe6cad3ab368c202288.pdf /tmp/bilder/page.png
{{</ terminal >}}

## Schritt 3: Montage der Bilder
Nun muss die Collage nur noch zusammengefügt werden:
{{< terminal >}}
montage /tmp/bilder/* -shadow -geometry '400x400+2+2>' -background '#f1f1f1' uebersich.jpg
{{</ terminal >}}

