+++
date = "2020-02-14"
title = "Generowanie przeglądu stron PDF"
difficulty = "level-3"
tags = ["bash", "linux", "pdf", "postscript", "imagemagick"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2020/february/20200214-imagemagick-pdf-overview/index.pl.md"
+++
Jeśli chcesz utworzyć obraz przeglądu strony z pliku PDF, to trafiłeś we właściwe miejsce!
{{< gallery match="images/1/*.jpg" >}}

## Krok 1: Utwórz folder roboczy
Użyj tego polecenia, aby utworzyć tymczasowy folder roboczy:
{{< terminal >}}
mkdir /tmp/bilder

{{</ terminal >}}

## Krok 2: Oddzielna strona
Poniższe polecenie tworzy obraz każdej strony PDF:
{{< terminal >}}
convert 716023b632a9cbe6cad3ab368c202288.pdf /tmp/bilder/page.png

{{</ terminal >}}

## Krok 3: Montowanie obrazów
Teraz trzeba tylko złożyć kolaż w całość:
{{< terminal >}}
montage /tmp/bilder/* -shadow -geometry '400x400+2+2>' -background '#f1f1f1' uebersich.jpg

{{</ terminal >}}
