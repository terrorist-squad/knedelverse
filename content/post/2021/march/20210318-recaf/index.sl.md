+++
date = "2021-03-18"
title = "Kratka zgodba: Prilagajanje tujih knjižnic Java"
difficulty = "level-2"
tags = ["dekompilieren", "manipulieren", "Recaf", "rekompilieren", "reverse", "reverse-engineering"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/march/20210318-recaf/index.sl.md"
+++
Nekega dne sem želel prilagoditi metode v tuji knjižnici Jave in zato sem iskal ustrezno orodje. Veliko sem se ukvarjal z urejevalniki bajtkode in bajtkodo. Toda na koncu sem končala z Recafom in sem popolnoma navdušena: https://github.com/Col-E/Recaf
{{< gallery match="images/1/*.png" >}}
Orodje je na voljo na naslednjem naslovu: https://github.com/Col-E/Recaf/releases. Dekompiliranje, ponovno kompiliranje in upravljanje knjižnic je z Recafom otročje enostavno! Najbolje je, da ga takoj preizkusite.
{{< terminal >}}
java -jar recaf-2.18.2-J8-jar-with-dependencies.jar

{{</ terminal >}}
