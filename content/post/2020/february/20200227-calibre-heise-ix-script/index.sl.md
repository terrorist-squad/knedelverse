+++
date = "2020-02-27"
title = "Velike stvari s posodami: Samodejno označevanje PDF-jev s Calibre in Dockerjem"
difficulty = "level-1"
tags = ["calibre", "calibre-web", "ebook", "epub", "linux", "pdf", "Synology"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2020/february/20200227-calibre-heise-ix-script/index.sl.md"
+++
Dodajanje ustreznih metainformacij v datoteke PDF je pogosto zamudno. Sam razvrščam prenesene datoteke PDF iz svojega naročniškega računa Heise IX v svojo zasebno knjižnico Calibre.
{{< gallery match="images/1/*.png" >}}
Ker se ta postopek ponavlja vsak mesec, sem se odločil za naslednjo nastavitev. V knjižnico povlečem samo nove datoteke PDF.
{{< gallery match="images/2/*.png" >}}
Ustvaril sem vsebnik, ki dobi mojo knjižnico Calibre kot zvezek (-v ...:/books). V to posodo sem namestil naslednje pakete:
{{< terminal >}}
apt-get update && apt-get install -y xpdf calibre

{{</ terminal >}}
Zdaj moja skripta išče nove datoteke PDF, ki ustrezajo vzorcu "IX*.pdf". Prvih 5 strani iz vsakega dokumenta PDF se izvozi kot besedilo. Nato odstranimo vse besede, ki se pojavljajo na tem seznamu besed: https://raw.githubusercontent.com/ChristianKnedel/heise-ix-reader-for-calibre/master/blacklist.txt
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
Z ukazom "calibredb set_metadata" nastavim vse drugo kot oznake. Rezultat je videti takole:
{{< gallery match="images/3/*.png" >}}
