+++
date = "2021-03-18"
title = "Short story: Adapt foreign Java libraries"
difficulty = "level-2"
tags = ["dekompilieren", "manipulieren", "Recaf", "rekompilieren", "reverse", "reverse-engineering"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/march/20210318-recaf/index.en.md"
+++
The other day I wanted to customize methods in a foreign Java library, so I was looking for a suitable tool. I have dealt a lot with bytecode editors and bytecode. But finally I ended up with Recaf and I am absolutely thrilled: https://github.com/Col-E/Recaf
{{< gallery match="images/1/*.png" >}}
The tool can be found at the following address: https://github.com/Col-E/Recaf/releases. Decompiling, recompiling and manipulating libraries is child's play with Recaf! It's best to try it out right away.
{{< terminal >}}
java -jar recaf-2.18.2-J8-jar-with-dependencies.jar

{{</ terminal >}}
