+++
date = "2020-02-14"
title = "Создание обзора страниц PDF"
difficulty = "level-3"
tags = ["bash", "linux", "pdf", "postscript", "imagemagick"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2020/february/20200214-imagemagick-pdf-overview/index.ru.md"
+++
Если вы хотите создать обзорное изображение страницы из PDF-файла, то вы пришли по адресу!
{{< gallery match="images/1/*.jpg" >}}

## Шаг 1: Создайте рабочую папку
Используйте эту команду для создания временной рабочей папки:
{{< terminal >}}
mkdir /tmp/bilder

{{</ terminal >}}

## Шаг 2: Отдельная страница
Следующая команда создает изображение каждой страницы PDF:
{{< terminal >}}
convert 716023b632a9cbe6cad3ab368c202288.pdf /tmp/bilder/page.png

{{</ terminal >}}

## Шаг 3: Монтирование изображений
Теперь осталось собрать коллаж воедино:
{{< terminal >}}
montage /tmp/bilder/* -shadow -geometry '400x400+2+2>' -background '#f1f1f1' uebersich.jpg

{{</ terminal >}}

