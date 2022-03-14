+++
date = "2020-02-14"
title = "Ustvarjanje pregleda strani PDF"
difficulty = "level-3"
tags = ["bash", "linux", "pdf", "postscript", "imagemagick"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2020/february/20200214-imagemagick-pdf-overview/index.sl.md"
+++
Če želite ustvariti sliko pregleda strani iz datoteke PDF, ste prišli na pravo mesto!
{{< gallery match="images/1/*.jpg" >}}

## Korak 1: Ustvarite delovno mapo
S tem ukazom ustvarite začasno delovno mapo:
{{< terminal >}}
mkdir /tmp/bilder

{{</ terminal >}}

## Korak 2: Ločena stran
Naslednji ukaz ustvari sliko vsake strani PDF:
{{< terminal >}}
convert 716023b632a9cbe6cad3ab368c202288.pdf /tmp/bilder/page.png

{{</ terminal >}}

## Korak 3: Namestitev slik
Zdaj je treba kolaž samo še sestaviti:
{{< terminal >}}
montage /tmp/bilder/* -shadow -geometry '400x400+2+2>' -background '#f1f1f1' uebersich.jpg

{{</ terminal >}}
