+++
date = "2020-02-27"
title = "De grandes choses avec les conteneurs : balisage automatique des PDF avec Calibre et Docker"
difficulty = "level-1"
tags = ["calibre", "calibre-web", "ebook", "epub", "linux", "pdf", "Synology"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2020/february/20200227-calibre-heise-ix-script/index.fr.md"
+++
Il peut souvent être fastidieux d'ajouter les méta-infos correctes aux PDF. Pour ma part, je classe les PDF téléchargés à partir de mon compte d'abonnement Heise-IX, dans ma bibliothèque privée Calibre.
{{< gallery match="images/1/*.png" >}}
Comme ce processus se répète chaque mois, j'ai pensé à la configuration suivante. Je ne fais plus que glisser mes nouveaux PDF dans ma bibliothèque.
{{< gallery match="images/2/*.png" >}}
J'ai créé un conteneur qui reçoit ma bibliothèque Calibre comme volume (-v ...:/books). Dans ce conteneur, j'ai installé les paquets suivants :
{{< terminal >}}
apt-get update && apt-get install -y xpdf calibre

{{</ terminal >}}
Maintenant, mon script recherche de nouveaux PDF qui correspondent au modèle "IX*.pdf". Les 5 premières pages de chaque PDF sont exportées sous forme de texte. Ensuite, tous les mots qui apparaissent sur cette liste de mots sont supprimés : https://raw.githubusercontent.com/ChristianKnedel/heise-ix-reader-for-calibre/master/blacklist.txt
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
Avec la commande "calibredb set_metadata", je définis tout le reste comme balises. Le résultat est le suivant :
{{< gallery match="images/3/*.png" >}}
