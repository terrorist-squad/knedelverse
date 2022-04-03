+++
date = "2020-02-14"
title = "PDF oldal áttekintés generálása"
difficulty = "level-3"
tags = ["bash", "linux", "pdf", "postscript", "imagemagick"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2020/february/20200214-imagemagick-pdf-overview/index.hu.md"
+++
Ha PDF fájlból szeretne oldalátnézeti képet készíteni, akkor a legjobb helyen jár!
{{< gallery match="images/1/*.jpg" >}}

## 1. lépés: Munkamappa létrehozása
Ezzel a paranccsal létrehozhat egy ideiglenes munkamappát:
{{< terminal >}}
mkdir /tmp/bilder

{{</ terminal >}}

## 2. lépés: Külön oldal
A következő parancs minden egyes PDF-oldalról képet készít:
{{< terminal >}}
convert 716023b632a9cbe6cad3ab368c202288.pdf /tmp/bilder/page.png

{{</ terminal >}}

## 3. lépés: A képek rögzítése
Most már csak össze kell rakni a kollázst:
{{< terminal >}}
montage /tmp/bilder/* -shadow -geometry '400x400+2+2>' -background '#f1f1f1' uebersich.jpg

{{</ terminal >}}

