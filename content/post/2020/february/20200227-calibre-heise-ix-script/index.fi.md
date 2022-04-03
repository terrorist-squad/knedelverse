+++
date = "2020-02-27"
title = "Suuria asioita konttien avulla: PDF-tiedostojen automaattinen merkitseminen Calibren ja Dockerin avulla"
difficulty = "level-1"
tags = ["calibre", "calibre-web", "ebook", "epub", "linux", "pdf", "Synology"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2020/february/20200227-calibre-heise-ix-script/index.fi.md"
+++
Oikeiden metatietojen lisääminen PDF-tiedostoihin voi usein olla työlästä. Itse lajittelen Heise IX -tililtä ladatut PDF-tiedostot yksityiseen Calibre-kirjastooni.
{{< gallery match="images/1/*.png" >}}
Koska tämä prosessi toistuu joka kuukausi, olen päätynyt seuraavaan asetukseen. Vedän vain uudet PDF-tiedostot kirjastooni.
{{< gallery match="images/2/*.png" >}}
Olen luonut säiliön, joka saa Calibre-kirjastoni tilavuutena (-v ...:/books). Tähän säiliöön olen asentanut seuraavat paketit:
{{< terminal >}}
apt-get update && apt-get install -y xpdf calibre

{{</ terminal >}}
Nyt skriptini etsii uusia PDF-tiedostoja, jotka vastaavat mallia "IX*.pdf". Jokaisesta PDF-tiedostosta viedään 5 ensimmäistä sivua tekstinä. Sitten poistetaan kaikki sanat, jotka esiintyvät tässä sanaluettelossa: https://raw.githubusercontent.com/ChristianKnedel/heise-ix-reader-for-calibre/master/blacklist.txt.
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
Komennolla "calibredb set_metadata" asetan kaiken muun tunnisteiksi. Tulos näyttää tältä:
{{< gallery match="images/3/*.png" >}}
Skripti on saatavilla myös Githubissa: https://github.com/ChristianKnedel/heise-ix-reader-for-calibre .
