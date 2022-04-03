+++
date = "2020-02-27"
title = "Great things with containers: Automatically tagging PDFs with Calibre and Docker"
difficulty = "level-1"
tags = ["calibre", "calibre-web", "ebook", "epub", "linux", "pdf", "Synology"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2020/february/20200227-calibre-heise-ix-script/index.en.md"
+++
It can often be tedious to tag PDFs with the right meta info. I myself sort the downloaded PDFs from my Heise-IX subscription account, into my private Calibre library.
{{< gallery match="images/1/*.png" >}}
Because this process repeats itself every month, I came up with the following setup. I just drag and drop my new PDFs into my library.
{{< gallery match="images/2/*.png" >}}
I have created a container for myself that gets my Calibre library as a volume (-v ...:/books). In this container I installed the following packages:
{{< terminal >}}
apt-get update && apt-get install -y xpdf calibre

{{</ terminal >}}
Now my script searches for new PDFs that match the pattern "IX*.pdf". From each PDF the first 5 pages are exported as text. Then all words are removed that appear on this word list: https://raw.githubusercontent.com/ChristianKnedel/heise-ix-reader-for-calibre/master/blacklist.txt
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
With the command "calibredb set_metadata" I set everything else as tags. The result looks like this:
{{< gallery match="images/3/*.png" >}}
The script is also available on Github: https://github.com/ChristianKnedel/heise-ix-reader-for-calibre .
