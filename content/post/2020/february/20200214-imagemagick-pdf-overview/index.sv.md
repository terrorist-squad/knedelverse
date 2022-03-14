+++
date = "2020-02-14"
title = "Generera en översikt över PDF-sidor"
difficulty = "level-3"
tags = ["bash", "linux", "pdf", "postscript", "imagemagick"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2020/february/20200214-imagemagick-pdf-overview/index.sv.md"
+++
Om du vill skapa en sidöversiktsbild från en PDF-fil har du kommit till rätt ställe!
{{< gallery match="images/1/*.jpg" >}}

## Steg 1: Skapa en arbetsmapp
Använd det här kommandot för att skapa en tillfällig arbetsmapp:
{{< terminal >}}
mkdir /tmp/bilder

{{</ terminal >}}

## Steg 2: Separat sida
Följande kommando skapar en bild av varje PDF-sida:
{{< terminal >}}
convert 716023b632a9cbe6cad3ab368c202288.pdf /tmp/bilder/page.png

{{</ terminal >}}

## Steg 3: Montering av bilderna
Nu behöver collaget bara sättas ihop:
{{< terminal >}}
montage /tmp/bilder/* -shadow -geometry '400x400+2+2>' -background '#f1f1f1' uebersich.jpg

{{</ terminal >}}
