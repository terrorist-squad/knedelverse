+++
date = "2020-02-27"
title = "Großartiges mit Containern: PDFs automatisch vertaggen mit Calibre und Docker"
difficulty = "level-1"
tags = ["calibre", "calibre-web", "ebook", "epub", "linux", "pdf", "Synology"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2020/february/20200227-calibre-heise-ix-script/index.de.md"
+++

Es kann oft mühselig sein, PDFs mit den richtigen Metainfos zu versehen. Ich selbst sortiere die gedownloadeten PDFs aus meinem Heise-IX-Abo-Account, in meine private Calibre-Bibliothek ein.
{{< gallery match="images/1/*.png" >}}

Weil sich dieser Vorgang jeden Monat wiederholt, habe ich mir folgendes Setup überlegt. Ich ziehe meine neuen PDFs nur noch in meine Bibliothek. 
{{< gallery match="images/2/*.png" >}}

Ich habe mir einen Container erstellt, der meine Calibre-Bibliothek als Volumen bekommt (-v …:/books). In diesem Container habe ich folgende Pakete installiert:
{{< terminal >}}
apt-get update && apt-get install -y xpdf calibre
{{</ terminal >}}

Nun sucht mein Script nach neuen PDFs, die dem Muster „IX*.pdf“ entsprechen. Aus jedem PDF werden die ersten 5 Seiten als Text exportiert. Anschließend werden alle Wörter entfernt, die auf dieser Wörterliste auftauchen: https://raw.githubusercontent.com/ChristianKnedel/heise-ix-reader-for-calibre/master/blacklist.txt
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

Mit dem Befehl „calibredb set_metadata“ setze ich alles Übrige als Tags. Das Ergebnis sieht wie folgt aus:
{{< gallery match="images/3/*.png" >}}

Das Skript gibt es auch unter Github: https://github.com/ChristianKnedel/heise-ix-reader-for-calibre . 