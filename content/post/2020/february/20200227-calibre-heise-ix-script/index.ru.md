+++
date = "2020-02-27"
title = "Великие вещи с контейнерами: автоматическое маркирование PDF-файлов с помощью Calibre и Docker"
difficulty = "level-1"
tags = ["calibre", "calibre-web", "ebook", "epub", "linux", "pdf", "Synology"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2020/february/20200227-calibre-heise-ix-script/index.ru.md"
+++
Добавление нужной метаинформации в PDF-файлы часто бывает утомительным. Я сам сортирую загруженные PDF-файлы с моего аккаунта подписки Heise IX в моей личной библиотеке Calibre.
{{< gallery match="images/1/*.png" >}}
Поскольку этот процесс повторяется каждый месяц, я придумал следующую схему. Я перетаскиваю в библиотеку только новые PDF-файлы.
{{< gallery match="images/2/*.png" >}}
Я создал контейнер, который получает мою библиотеку Calibre в виде тома (-v ...:/books). В этом контейнере я установил следующие пакеты:
{{< terminal >}}
apt-get update && apt-get install -y xpdf calibre

{{</ terminal >}}
Теперь мой сценарий ищет новые PDF-файлы, соответствующие шаблону "IX*.pdf". Из каждого PDF-файла первые 5 страниц экспортируются в виде текста. Затем удаляются все слова, которые встречаются в этом списке слов: https://raw.githubusercontent.com/ChristianKnedel/heise-ix-reader-for-calibre/master/blacklist.txt.
```
#!/bin/bash
export LANG=C.UTF-8
mkdir /tmp/worker1/

find /books/ -type f -iname '*.pdf' -newermt 20201201 -print0 | 
while IFS= read -r -d '' line; do 
        calibreID=$(echo  "$line" | sed -r 's/.*\(([0-9]+)\).*/\1/g')
        
        echo "bearbeite $clearName"
        echo "id $calibreID";

        cp "$line" /tmp/worker1/test.pdf

        echo "ocr "
        pdftotext -f 0 -l 5 /tmp/worker1/test.pdf /tmp/worker1/tmp.txt

        echo "text aufbereitung"
        cat /tmp/worker1/tmp.txt  | grep  -i -F -w -v -f  /books/blacklist.txt | sed -r s/[^a-zA-ZäöüÄÖÜ]+//g | grep -iE '[A-Za-z]{2,212}' |  sed ':begin;$!N;s/\n/,/;tbegin' > /tmp/worker1/final.txt

        calibredb set_metadata  --with-library /books/ --field cover:"cover.jpg" --field tags:"$(cat /tmp/worker1/final.txt) " --field series:"Heise IX" --field languages:"Deutsch" --field authors:"Heise Verkag" $calibreID
        
        rm /tmp/worker1/*
done


```
С помощью команды "calibredb set_metadata" я установил все остальное как теги. Результат выглядит следующим образом:
{{< gallery match="images/3/*.png" >}}
Сценарий также доступен на Github: https://github.com/ChristianKnedel/heise-ix-reader-for-calibre .
