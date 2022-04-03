+++
date = "2020-02-27"
title = "Υπέροχα πράγματα με κοντέινερ: Αυτόματη επισήμανση PDF με το Calibre και το Docker"
difficulty = "level-1"
tags = ["calibre", "calibre-web", "ebook", "epub", "linux", "pdf", "Synology"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2020/february/20200227-calibre-heise-ix-script/index.el.md"
+++
Συχνά μπορεί να είναι κουραστικό να προσθέσετε τις σωστές μετα-πληροφορίες στα PDF. Εγώ ο ίδιος ταξινομώ τα PDF που έχω κατεβάσει από τον λογαριασμό συνδρομής Heise IX στην ιδιωτική μου βιβλιοθήκη Calibre.
{{< gallery match="images/1/*.png" >}}
Επειδή αυτή η διαδικασία επαναλαμβάνεται κάθε μήνα, έχω καταλήξει στην ακόλουθη ρύθμιση. Σύρω μόνο τα νέα μου PDF στη βιβλιοθήκη μου.
{{< gallery match="images/2/*.png" >}}
Έχω δημιουργήσει ένα δοχείο που λαμβάνει τη βιβλιοθήκη Calibre ως τόμο (-v ...:/books). Σε αυτό το δοχείο έχω εγκαταστήσει τα ακόλουθα πακέτα:
{{< terminal >}}
apt-get update && apt-get install -y xpdf calibre

{{</ terminal >}}
Τώρα το σενάριό μου αναζητά νέα PDF που ταιριάζουν με το μοτίβο "IX*.pdf". Από κάθε PDF, οι 5 πρώτες σελίδες εξάγονται ως κείμενο. Στη συνέχεια αφαιρούνται όλες οι λέξεις που εμφανίζονται σε αυτόν τον κατάλογο λέξεων: https://raw.githubusercontent.com/ChristianKnedel/heise-ix-reader-for-calibre/master/blacklist.txt
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
Με την εντολή "calibredb set_metadata" ορίζω όλα τα υπόλοιπα ως ετικέτες. Το αποτέλεσμα είναι το εξής:
{{< gallery match="images/3/*.png" >}}
Το σενάριο είναι επίσης διαθέσιμο στο Github: https://github.com/ChristianKnedel/heise-ix-reader-for-calibre .
