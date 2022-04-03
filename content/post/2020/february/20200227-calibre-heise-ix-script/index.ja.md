+++
date = "2020-02-27"
title = "コンテナですごいこと：CalibreとDockerでPDFに自動タグ付け"
difficulty = "level-1"
tags = ["calibre", "calibre-web", "ebook", "epub", "linux", "pdf", "Synology"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2020/february/20200227-calibre-heise-ix-script/index.ja.md"
+++
PDFに適切なメタ情報を付加することは、しばしば面倒な作業となります。私自身は、Heise IXの購読アカウントからダウンロードしたPDFを、私的なCalibreライブラリに分類しています。
{{< gallery match="images/1/*.png" >}}
この作業が毎月繰り返されるため、次のような設定を考えています。私は新しいPDFをライブラリにドラッグするだけです。
{{< gallery match="images/2/*.png" >}}
Calibre ライブラリをボリュームとして取得するコンテナを作成しました (-v ...:/books)。このコンテナには、以下のパッケージをインストールしました。
{{< terminal >}}
apt-get update && apt-get install -y xpdf calibre

{{</ terminal >}}
これで、私のスクリプトは、"IX*.pdf "というパターンに一致する新しいPDFを検索するようになりました。各PDFから、最初の5ページをテキストとして書き出します。そして、この単語リストに登場する単語はすべて削除されます。https://raw.githubusercontent.com/ChristianKnedel/heise-ix-reader-for-calibre/master/blacklist.txt。
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
calibredb set_metadata "コマンドで、それ以外をタグとして設定しました。結果はこのようになります。
{{< gallery match="images/3/*.png" >}}
このスクリプトはGithubでも公開されています: https://github.com/ChristianKnedel/heise-ix-reader-for-calibre .
