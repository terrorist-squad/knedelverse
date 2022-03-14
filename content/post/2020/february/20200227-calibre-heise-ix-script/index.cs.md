+++
date = "2020-02-27"
title = "Skvělé věci s kontejnery: Automatické označování PDF pomocí Calibre a Dockeru"
difficulty = "level-1"
tags = ["calibre", "calibre-web", "ebook", "epub", "linux", "pdf", "Synology"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2020/february/20200227-calibre-heise-ix-script/index.cs.md"
+++
Často může být zdlouhavé přidávat do souborů PDF správné metainformace. Já sám si stahované PDF soubory z mého předplaceného účtu Heise IX třídím do své soukromé knihovny Calibre.
{{< gallery match="images/1/*.png" >}}
Protože se tento proces opakuje každý měsíc, vymyslel jsem následující nastavení. Do knihovny přetahuji pouze nové soubory PDF.
{{< gallery match="images/2/*.png" >}}
Vytvořil jsem kontejner, který získává mou knihovnu Calibre jako svazek (-v ...:/books). Do tohoto kontejneru jsem nainstaloval následující balíčky:
{{< terminal >}}
apt-get update && apt-get install -y xpdf calibre

{{</ terminal >}}
Nyní můj skript vyhledává nové soubory PDF, které odpovídají vzoru "IX*.pdf". Z každého souboru PDF je prvních 5 stránek exportováno jako text. Pak jsou odstraněna všechna slova, která se objevují v tomto seznamu slov: https://raw.githubusercontent.com/ChristianKnedel/heise-ix-reader-for-calibre/master/blacklist.txt
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
Příkazem "calibredb set_metadata" nastavím vše ostatní jako značky. Výsledek vypadá takto:
{{< gallery match="images/3/*.png" >}}
