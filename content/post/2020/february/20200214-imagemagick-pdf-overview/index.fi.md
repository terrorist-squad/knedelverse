+++
date = "2020-02-14"
title = "Luo PDF-sivun yleiskatsaus"
difficulty = "level-3"
tags = ["bash", "linux", "pdf", "postscript", "imagemagick"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2020/february/20200214-imagemagick-pdf-overview/index.fi.md"
+++
Jos haluat luoda sivun yleiskuvan PDF-tiedostosta, olet tullut oikeaan paikkaan!
{{< gallery match="images/1/*.jpg" >}}

## Vaihe 1: Luo työkansio
Tällä komennolla voit luoda väliaikaisen työkansion:
{{< terminal >}}
mkdir /tmp/bilder

{{</ terminal >}}

## Vaihe 2: Erillinen sivu
Seuraava komento luo kuvan jokaisesta PDF-sivusta:
{{< terminal >}}
convert 716023b632a9cbe6cad3ab368c202288.pdf /tmp/bilder/page.png

{{</ terminal >}}

## Vaihe 3: Kuvien kiinnittäminen
Nyt kollaasi on vain koottava:
{{< terminal >}}
montage /tmp/bilder/* -shadow -geometry '400x400+2+2>' -background '#f1f1f1' uebersich.jpg

{{</ terminal >}}
