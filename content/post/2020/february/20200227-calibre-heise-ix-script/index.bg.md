+++
date = "2020-02-27"
title = "Страхотни неща с контейнери: Автоматично маркиране на PDF файлове с Calibre и Docker"
difficulty = "level-1"
tags = ["calibre", "calibre-web", "ebook", "epub", "linux", "pdf", "Synology"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2020/february/20200227-calibre-heise-ix-script/index.bg.md"
+++
Често добавянето на правилната метаинформация към PDF файловете може да бъде досадно. Аз самият сортирам изтеглените PDF файлове от абонаментния си акаунт в Heise IX в личната си библиотека в Calibre.
{{< gallery match="images/1/*.png" >}}
Тъй като този процес се повтаря всеки месец, измислих следната конфигурация. Влача само новите PDF файлове в библиотеката си.
{{< gallery match="images/2/*.png" >}}
Създадох контейнер, който получава моята библиотека на Calibre като том (-v ...:/books). В този контейнер съм инсталирал следните пакети:
{{< terminal >}}
apt-get update && apt-get install -y xpdf calibre

{{</ terminal >}}
Сега моят скрипт търси нови PDF файлове, които отговарят на модела "IX*.pdf". От всеки PDF файл първите 5 страници се експортират като текст. След това се премахват всички думи, които се появяват в този списък с думи: https://raw.githubusercontent.com/ChristianKnedel/heise-ix-reader-for-calibre/master/blacklist.txt
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
С командата "calibredb set_metadata" задавам всичко останало като тагове. Резултатът изглежда така:
{{< gallery match="images/3/*.png" >}}
