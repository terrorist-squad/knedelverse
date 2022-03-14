+++
date = "2020-02-27"
title = "Wspaniałe rzeczy z kontenerami: Automatyczne tagowanie plików PDF za pomocą Calibre i Dockera"
difficulty = "level-1"
tags = ["calibre", "calibre-web", "ebook", "epub", "linux", "pdf", "Synology"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2020/february/20200227-calibre-heise-ix-script/index.pl.md"
+++
Dodawanie właściwych meta-info do plików PDF może być często żmudne. Ja sam sortuję pobrane pliki PDF z mojego konta subskrypcyjnego Heise IX do mojej prywatnej biblioteki Calibre.
{{< gallery match="images/1/*.png" >}}
Ponieważ proces ten powtarza się co miesiąc, wymyśliłem następującą konfigurację. Przeciągam tylko nowe pliki PDF do mojej biblioteki.
{{< gallery match="images/2/*.png" >}}
Stworzyłem kontener, który pobiera moją bibliotekę Calibre jako wolumin (-v ...:/books). W tym kontenerze mam zainstalowane następujące pakiety:
{{< terminal >}}
apt-get update && apt-get install -y xpdf calibre

{{</ terminal >}}
Teraz mój skrypt wyszukuje nowe pliki PDF, które pasują do wzorca "IX*.pdf". Z każdego pliku PDF, pierwsze 5 stron jest eksportowane jako tekst. Następnie usuwane są wszystkie słowa, które pojawiają się na tej liście słów: https://raw.githubusercontent.com/ChristianKnedel/heise-ix-reader-for-calibre/master/blacklist.txt
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
Za pomocą polecenia "calibredb set_metadata" ustawiam wszystko inne jako tagi. Wynik wygląda następująco:
{{< gallery match="images/3/*.png" >}}