+++
date = "2020-02-27"
title = "コンテナを利用した優れた点：CalibreとDockerによるPDFへの自動タグ付け"
difficulty = "level-1"
tags = ["calibre", "calibre-web", "ebook", "epub", "linux", "pdf", "Synology"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2020/february/20200227-calibre-heise-ix-script/index.ja.md"
+++
PDFに適切なメタ情報を追加するのは、しばしば面倒なことです。私自身は、Heise IXの購読アカウントからダウンロードしたPDFを、自分のプライベートなCalibreライブラリに分類しています。
{{< gallery match="images/1/*.png" >}}
これが毎月繰り返されるので、次のような設定にしています。私は新しいPDFをライブラリにドラッグするだけです。
{{< gallery match="images/2/*.png" >}}
Calibreライブラリをボリュームとして取得するコンテナを作成しました(-v ...:/books)。このコンテナには、以下のパッケージをインストールしました。
{{< terminal >}}
apt-get update && apt-get install -y xpdf calibre

{{</ terminal >}}
これで私のスクリプトは、「IX*.pdf」というパターンに一致する新しいPDFを検索します。それぞれのPDFから、最初の5ページがテキストとして書き出されます。そして、この単語リストに登場するすべての単語が削除されます。https://raw.githubusercontent.com/ChristianKnedel/heise-ix-reader-for-calibre/master/blacklist.txt
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
calibredb set_metadata "というコマンドで、他のすべてをタグとして設定しました。結果は以下のようになります。
{{< gallery match="images/3/*.png" >}}
