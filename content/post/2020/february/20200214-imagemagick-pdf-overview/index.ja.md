+++
date = "2020-02-14"
title = "PDFページ生成の概要"
difficulty = "level-3"
tags = ["bash", "linux", "pdf", "postscript", "imagemagick"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2020/february/20200214-imagemagick-pdf-overview/index.ja.md"
+++
PDFファイルからページ全体のイメージを作成したい方には最適な場所です。
{{< gallery match="images/1/*.jpg" >}}

## ステップ1：作業フォルダの作成
このコマンドを使用して、一時的な作業フォルダを作成します。
{{< terminal >}}
mkdir /tmp/bilder

{{</ terminal >}}

## ステップ2：セパレートページ
次のコマンドは、各PDFページのイメージを作成します。
{{< terminal >}}
convert 716023b632a9cbe6cad3ab368c202288.pdf /tmp/bilder/page.png

{{</ terminal >}}

## ステップ3：イメージのマウント
あとは、コラージュを組み立てるだけです。
{{< terminal >}}
montage /tmp/bilder/* -shadow -geometry '400x400+2+2>' -background '#f1f1f1' uebersich.jpg

{{</ terminal >}}
