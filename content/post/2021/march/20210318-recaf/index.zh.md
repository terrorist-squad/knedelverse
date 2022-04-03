+++
date = "2021-03-18"
title = "短篇小说：改编国外Java库"
difficulty = "level-2"
tags = ["dekompilieren", "manipulieren", "Recaf", "rekompilieren", "reverse", "reverse-engineering"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/march/20210318-recaf/index.zh.md"
+++
有一天，我想改编一个外国Java库中的方法，因此正在寻找一个合适的工具。我对字节码编辑器和字节码进行了大量研究。但最终我还是选择了Recaf，我感到非常兴奋: https://github.com/Col-E/Recaf
{{< gallery match="images/1/*.png" >}}
该工具可以在以下地址找到：https://github.com/Col-E/Recaf/releases。使用Recaf！反编译、重新编译和操作库是小菜一碟。最好是马上尝试一下。
{{< terminal >}}
java -jar recaf-2.18.2-J8-jar-with-dependencies.jar

{{</ terminal >}}

