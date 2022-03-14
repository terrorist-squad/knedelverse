+++
date = "2020-02-27"
title = "Skvelé veci s kontajnermi: Automatické označovanie PDF súborov pomocou Calibre a Docker"
difficulty = "level-1"
tags = ["calibre", "calibre-web", "ebook", "epub", "linux", "pdf", "Synology"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2020/february/20200227-calibre-heise-ix-script/index.sk.md"
+++
Pridávanie správnych metainformácií do súborov PDF môže byť často zdĺhavé. Ja sám triedim stiahnuté PDF súbory z môjho predplatiteľského účtu Heise IX do mojej súkromnej knižnice Calibre.
{{< gallery match="images/1/*.png" >}}
Keďže sa tento proces opakuje každý mesiac, vymyslel som nasledujúce nastavenie. Do svojej knižnice preťahujem len nové súbory PDF.
{{< gallery match="images/2/*.png" >}}
Vytvoril som kontajner, ktorý získava moju knižnicu Calibre ako zväzok (-v ...:/books). Do tohto kontajnera som nainštaloval nasledujúce balíky:
{{< terminal >}}
apt-get update && apt-get install -y xpdf calibre

{{</ terminal >}}
Teraz môj skript vyhľadáva nové súbory PDF, ktoré zodpovedajú vzoru "IX*.pdf". Z každého súboru PDF sa prvých 5 strán exportuje ako text. Potom sa odstránia všetky slová, ktoré sa vyskytujú v tomto zozname slov: https://raw.githubusercontent.com/ChristianKnedel/heise-ix-reader-for-calibre/master/blacklist.txt
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
Príkazom "calibredb set_metadata" nastavím všetko ostatné ako značky. Výsledok vyzerá takto:
{{< gallery match="images/3/*.png" >}}
