+++
date = "2020-02-27"
title = "Grandi cose con i container: taggare automaticamente i PDF con Calibre e Docker"
difficulty = "level-1"
tags = ["calibre", "calibre-web", "ebook", "epub", "linux", "pdf", "Synology"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2020/february/20200227-calibre-heise-ix-script/index.it.md"
+++
Spesso può essere noioso aggiungere le giuste meta-informazioni ai PDF. Io stesso ordino i PDF scaricati dal mio account di abbonamento Heise IX nella mia biblioteca privata Calibre.
{{< gallery match="images/1/*.png" >}}
Poiché questo processo si ripete ogni mese, ho trovato la seguente configurazione. Io trascino solo i miei nuovi PDF nella mia libreria.
{{< gallery match="images/2/*.png" >}}
Ho creato un contenitore che ottiene la mia libreria Calibre come volume (-v ...:/books). In questo contenitore ho installato i seguenti pacchetti:
{{< terminal >}}
apt-get update && apt-get install -y xpdf calibre

{{</ terminal >}}
Ora il mio script cerca nuovi PDF che corrispondono al modello "IX*.pdf". Da ogni PDF, le prime 5 pagine vengono esportate come testo. Poi tutte le parole che appaiono in questo elenco di parole vengono rimosse: https://raw.githubusercontent.com/ChristianKnedel/heise-ix-reader-for-calibre/master/blacklist.txt
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
Con il comando "calibredb set_metadata" ho impostato tutto il resto come tag. Il risultato appare così:
{{< gallery match="images/3/*.png" >}}
