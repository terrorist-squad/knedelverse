+++
date = "2021-03-18"
title = "Scurtă poveste: Adaptarea bibliotecilor Java străine"
difficulty = "level-2"
tags = ["dekompilieren", "manipulieren", "Recaf", "rekompilieren", "reverse", "reverse-engineering"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/march/20210318-recaf/index.ro.md"
+++
Zilele trecute am vrut să adaptez metode dintr-o bibliotecă Java străină și, prin urmare, am căutat un instrument adecvat. M-am interesat mult de editorii de bytecode și de bytecode. Dar în cele din urmă am ajuns la Recaf și sunt absolut încântată: https://github.com/Col-E/Recaf
{{< gallery match="images/1/*.png" >}}
Instrumentul poate fi găsit la următoarea adresă: https://github.com/Col-E/Recaf/releases. Decompilați, recompilați și manipulați bibliotecile este o joacă de copii cu Recaf! Cel mai bine este să o încercați imediat.
{{< terminal >}}
java -jar recaf-2.18.2-J8-jar-with-dependencies.jar

{{</ terminal >}}
