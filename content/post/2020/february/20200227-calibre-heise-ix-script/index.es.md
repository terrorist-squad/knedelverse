+++
date = "2020-02-27"
title = "Grandes cosas con contenedores: Etiquetado automático de PDFs con Calibre y Docker"
difficulty = "level-1"
tags = ["calibre", "calibre-web", "ebook", "epub", "linux", "pdf", "Synology"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2020/february/20200227-calibre-heise-ix-script/index.es.md"
+++
A menudo puede resultar tedioso añadir la metainformación adecuada a los PDF. Yo mismo clasifico los PDF descargados desde mi cuenta de suscripción a Heise IX en mi biblioteca privada de Calibre.
{{< gallery match="images/1/*.png" >}}
Como este proceso se repite todos los meses, he ideado la siguiente configuración. Sólo arrastro mis nuevos PDF a mi biblioteca.
{{< gallery match="images/2/*.png" >}}
He creado un contenedor que recibe mi biblioteca Calibre como un volumen (-v ...:/libros). En este contenedor he instalado los siguientes paquetes:
{{< terminal >}}
apt-get update && apt-get install -y xpdf calibre

{{</ terminal >}}
Ahora mi script busca nuevos PDFs que coincidan con el patrón "IX*.pdf". De cada PDF, las primeras 5 páginas se exportan como texto. A continuación, se eliminan todas las palabras que aparecen en esta lista de palabras: https://raw.githubusercontent.com/ChristianKnedel/heise-ix-reader-for-calibre/master/blacklist.txt
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
Con el comando "calibredb set_metadata" establezco todo lo demás como etiquetas. El resultado es el siguiente:
{{< gallery match="images/3/*.png" >}}
