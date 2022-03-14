+++
date = "2020-02-14"
title = "Генериране на преглед на PDF страници"
difficulty = "level-3"
tags = ["bash", "linux", "pdf", "postscript", "imagemagick"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2020/february/20200214-imagemagick-pdf-overview/index.bg.md"
+++
Ако искате да създадете изображение за преглед на страница от PDF файл, значи сте попаднали на правилното място!
{{< gallery match="images/1/*.jpg" >}}

## Стъпка 1: Създаване на работна папка
Използвайте тази команда, за да създадете временна работна папка:
{{< terminal >}}
mkdir /tmp/bilder

{{</ terminal >}}

## Стъпка 2: Отделна страница
Следната команда създава изображение на всяка PDF страница:
{{< terminal >}}
convert 716023b632a9cbe6cad3ab368c202288.pdf /tmp/bilder/page.png

{{</ terminal >}}

## Стъпка 3: Монтиране на изображенията
Сега остава само да сглобите колажа:
{{< terminal >}}
montage /tmp/bilder/* -shadow -geometry '400x400+2+2>' -background '#f1f1f1' uebersich.jpg

{{</ terminal >}}
