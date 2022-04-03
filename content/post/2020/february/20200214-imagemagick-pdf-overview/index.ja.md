+++
date = "2020-02-14"
title = "PDFページ概要の生成"
difficulty = "level-3"
tags = ["bash", "linux", "pdf", "postscript", "imagemagick"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2020/february/20200214-imagemagick-pdf-overview/index.ja.md"
+++
PDFファイルからページ概要画像を作成するなら、この方法が最適です!
{{< gallery match="images/1/*.jpg" >}}

## ステップ1：作業用フォルダの作成
このコマンドは、一時的な作業フォルダを作成するために使用します。
{{< terminal >}}
mkdir /tmp/bilder

{{</ terminal >}}

## ステップ2：別ページ
次のコマンドは、PDFの各ページの画像を作成します。
{{< terminal >}}
convert 716023b632a9cbe6cad3ab368c202288.pdf /tmp/bilder/page.png

{{</ terminal >}}

## ステップ3：イメージのマウント
あとは、コラージュを組み立てるだけです。
{{< terminal >}}
montage /tmp/bilder/* -shadow -geometry '400x400+2+2>' -background '#f1f1f1' uebersich.jpg

{{</ terminal >}}

