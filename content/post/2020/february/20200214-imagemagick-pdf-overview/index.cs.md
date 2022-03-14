+++
date = "2020-02-14"
title = "Generování přehledu stránek PDF"
difficulty = "level-3"
tags = ["bash", "linux", "pdf", "postscript", "imagemagick"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2020/february/20200214-imagemagick-pdf-overview/index.cs.md"
+++
Pokud chcete vytvořit obrázek s přehledem stránek ze souboru PDF, jste na správném místě!
{{< gallery match="images/1/*.jpg" >}}

## Krok 1: Vytvoření pracovní složky
Tento příkaz slouží k vytvoření dočasné pracovní složky:
{{< terminal >}}
mkdir /tmp/bilder

{{</ terminal >}}

## Krok 2: Samostatná stránka
Následující příkaz vytvoří obrázek každé stránky PDF:
{{< terminal >}}
convert 716023b632a9cbe6cad3ab368c202288.pdf /tmp/bilder/page.png

{{</ terminal >}}

## Krok 3: Montáž obrázků
Teď už jen zbývá koláž sestavit:
{{< terminal >}}
montage /tmp/bilder/* -shadow -geometry '400x400+2+2>' -background '#f1f1f1' uebersich.jpg

{{</ terminal >}}
