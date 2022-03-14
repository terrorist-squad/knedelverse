+++
date = "2020-02-27"
title = "Nagyszerű dolgok konténerekkel: PDF-ek automatikus címkézése Calibre és Docker segítségével"
difficulty = "level-1"
tags = ["calibre", "calibre-web", "ebook", "epub", "linux", "pdf", "Synology"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2020/february/20200227-calibre-heise-ix-script/index.hu.md"
+++
A PDF-ek megfelelő metainformációkkal való ellátása gyakran fárasztó lehet. Én magam a Heise IX előfizetési fiókomból letöltött PDF-eket a privát Calibre könyvtáramba válogatom.
{{< gallery match="images/1/*.png" >}}
Mivel ez a folyamat minden hónapban megismétlődik, a következő beállítással álltam elő. Én csak az új PDF-eket húzom a könyvtáramba.
{{< gallery match="images/2/*.png" >}}
Létrehoztam egy konténert, amely kötetként megkapja a Calibre könyvtáramat (-v ...:/books). Ebbe a konténerbe a következő csomagokat telepítettem:
{{< terminal >}}
apt-get update && apt-get install -y xpdf calibre

{{</ terminal >}}
Most a szkriptem olyan új PDF-eket keres, amelyek megfelelnek az "IX*.pdf" mintának. Minden PDF-ből az első 5 oldal szövegként kerül exportálásra. Ezután minden olyan szót, amely ezen a szólistán szerepel, eltávolítunk: https://raw.githubusercontent.com/ChristianKnedel/heise-ix-reader-for-calibre/master/blacklist.txt
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
A "calibredb set_metadata" paranccsal minden mást beállítottam címkéknek. Az eredmény így néz ki:
{{< gallery match="images/3/*.png" >}}
