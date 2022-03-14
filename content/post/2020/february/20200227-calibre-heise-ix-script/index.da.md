+++
date = "2020-02-27"
title = "Store ting med containere: Automatisk tagging af PDF-filer med Calibre og Docker"
difficulty = "level-1"
tags = ["calibre", "calibre-web", "ebook", "epub", "linux", "pdf", "Synology"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2020/february/20200227-calibre-heise-ix-script/index.da.md"
+++
Det kan ofte være besværligt at tilføje den rigtige meta-info til PDF-filer. Jeg sorterer selv de downloadede PDF-filer fra min Heise IX-abonnementskonto i mit private Calibre-bibliotek.
{{< gallery match="images/1/*.png" >}}
Da denne proces gentager sig hver måned, har jeg fundet frem til følgende opsætning. Jeg trækker kun mine nye PDF-filer ind i mit bibliotek.
{{< gallery match="images/2/*.png" >}}
Jeg har oprettet en container, der får mit Calibre-bibliotek som et volumen (-v ...:/books). I denne container har jeg installeret følgende pakker:
{{< terminal >}}
apt-get update && apt-get install -y xpdf calibre

{{</ terminal >}}
Nu søger mit script efter nye PDF-filer, der svarer til mønsteret "IX*.pdf". Fra hver PDF-fil eksporteres de første 5 sider som tekst. Derefter fjernes alle ord, der optræder på denne ordliste: https://raw.githubusercontent.com/ChristianKnedel/heise-ix-reader-for-calibre/master/blacklist.txt
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
Med kommandoen "calibredb set_metadata" indstiller jeg alt andet som tags. Resultatet ser således ud:
{{< gallery match="images/3/*.png" >}}
