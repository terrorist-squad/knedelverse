+++
date = "2020-02-14"
title = "Generarea unei imagini de ansamblu a paginilor PDF"
difficulty = "level-3"
tags = ["bash", "linux", "pdf", "postscript", "imagemagick"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2020/february/20200214-imagemagick-pdf-overview/index.ro.md"
+++
Dacă doriți să creați o imagine de ansamblu a paginii dintr-un fișier PDF, atunci ați ajuns la locul potrivit!
{{< gallery match="images/1/*.jpg" >}}

## Pasul 1: Creați dosarul de lucru
Utilizați această comandă pentru a crea un dosar de lucru temporar:
{{< terminal >}}
mkdir /tmp/bilder

{{</ terminal >}}

## Pasul 2: Pagina separată
Următoarea comandă creează o imagine a fiecărei pagini PDF:
{{< terminal >}}
convert 716023b632a9cbe6cad3ab368c202288.pdf /tmp/bilder/page.png

{{</ terminal >}}

## Pasul 3: Montarea imaginilor
Acum colajul trebuie doar să fie asamblat:
{{< terminal >}}
montage /tmp/bilder/* -shadow -geometry '400x400+2+2>' -background '#f1f1f1' uebersich.jpg

{{</ terminal >}}
