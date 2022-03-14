+++
date = "2020-02-14"
title = "Generovanie prehľadu stránok PDF"
difficulty = "level-3"
tags = ["bash", "linux", "pdf", "postscript", "imagemagick"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2020/february/20200214-imagemagick-pdf-overview/index.sk.md"
+++
Ak chcete vytvoriť obrázok prehľadu stránok zo súboru PDF, potom ste na správnom mieste!
{{< gallery match="images/1/*.jpg" >}}

## Krok 1: Vytvorenie pracovného priečinka
Pomocou tohto príkazu vytvorte dočasný pracovný priečinok:
{{< terminal >}}
mkdir /tmp/bilder

{{</ terminal >}}

## Krok 2: Samostatná stránka
Nasledujúci príkaz vytvorí obrázok každej stránky PDF:
{{< terminal >}}
convert 716023b632a9cbe6cad3ab368c202288.pdf /tmp/bilder/page.png

{{</ terminal >}}

## Krok 3: Montáž obrázkov
Teraz je potrebné koláž už len poskladať:
{{< terminal >}}
montage /tmp/bilder/* -shadow -geometry '400x400+2+2>' -background '#f1f1f1' uebersich.jpg

{{</ terminal >}}
