+++
date = "2020-02-27"
title = "Coisas óptimas com recipientes: etiquetagem automática de PDFs com Calibre e Docker"
difficulty = "level-1"
tags = ["calibre", "calibre-web", "ebook", "epub", "linux", "pdf", "Synology"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2020/february/20200227-calibre-heise-ix-script/index.pt.md"
+++
Muitas vezes pode ser enfadonho adicionar a meta-info correta aos PDFs. Eu mesmo separo os PDFs baixados da minha conta de assinatura Heise IX na minha biblioteca privada Calibre.
{{< gallery match="images/1/*.png" >}}
Como este processo se repete a cada mês, eu inventei a seguinte configuração. Eu só arrasto os meus novos PDFs para a minha biblioteca.
{{< gallery match="images/2/*.png" >}}
Eu criei um recipiente que recebe minha biblioteca Calibre como um volume (-v ...:/books). Neste contentor instalei os seguintes pacotes:
{{< terminal >}}
apt-get update && apt-get install -y xpdf calibre

{{</ terminal >}}
Agora meu script procura por novos PDFs que correspondam ao padrão "IX*.pdf". A partir de cada PDF, as primeiras 5 páginas são exportadas como texto. Então todas as palavras que aparecem nesta lista de palavras são removidas: https://raw.githubusercontent.com/ChristianKnedel/heise-ix-reader-for-calibre/master/blacklist.txt
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
Com o comando "calibredb set_metadata", defino tudo o resto como tags. O resultado é o seguinte:
{{< gallery match="images/3/*.png" >}}
