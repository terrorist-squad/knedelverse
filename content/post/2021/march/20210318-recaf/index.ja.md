+++
date = "2021-03-18"
title = "短編：海外のJavaライブラリの採用について"
difficulty = "level-2"
tags = ["dekompilieren", "manipulieren", "Recaf", "rekompilieren", "reverse", "reverse-engineering"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/march/20210318-recaf/index.ja.md"
+++
先日、海外のJavaライブラリのメソッドを適応させたいと思い、適切なツールを探していました。バイトコードエディターやバイトコードについていろいろ調べました。でも、最終的にRecafにたどり着いたので、とても感激しています。https://github.com/Col-E/Recaf。
{{< gallery match="images/1/*.png" >}}
このツールは、次のアドレスにあります：https://github.com/Col-E/Recaf/releases。デコンパイル、リコンパイル、ライブラリの操作は、Recafで簡単にできます。すぐにでも試してみるのが一番です。
{{< terminal >}}
java -jar recaf-2.18.2-J8-jar-with-dependencies.jar

{{</ terminal >}}

