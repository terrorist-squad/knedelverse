+++
date = "2021-03-18"
title = "ショートストーリー：海外のJavaライブラリを導入する"
difficulty = "level-2"
tags = ["dekompilieren", "manipulieren", "Recaf", "rekompilieren", "reverse", "reverse-engineering"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/march/20210318-recaf/index.ja.md"
+++
先日、私は外国のJavaライブラリのメソッドを適応させたいと思い、適切なツールを探していました。バイトコードエディターやバイトコードのことをいろいろ調べました。でも、最終的にRecafにたどり着き、とても感激しています。https://github.com/Col-E/Recaf
{{< gallery match="images/1/*.png" >}}
このツールは、次のアドレスで見ることができます： https://github.com/Col-E/Recaf/releases。Recafを使えば、ライブラリのデコンパイル、リコンパイル、操作が簡単にできます。すぐに試してみるのが一番です。
{{< terminal >}}
java -jar recaf-2.18.2-J8-jar-with-dependencies.jar

{{</ terminal >}}
