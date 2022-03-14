+++
date = "2021-03-18"
title = "Kurzgeschichte: Fremde Java-Bibliotheken anpassen"
difficulty = "level-2"
tags = ["dekompilieren", "manipulieren", "Recaf", "rekompilieren", "reverse", "reverse-engineering"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/march/20210318-recaf/index.de.md"
+++

Neulich wollte ich Methoden in einer fremden Java-Bibliothek anpassen und suchte daher nach einem passenden Tool. Ich habe mich viel mit Bytecode-Editoren und Bytecode beschäftigt. Doch letztendlich bin ich bei Recaf gelandet und bin absolut begeistert: https://github.com/Col-E/Recaf
{{< gallery match="images/1/*.png" >}}

Das Tool ist unter der folgenden Adresse zu finden: https://github.com/Col-E/Recaf/releases. Das dekompilieren, rekompilieren und manipulieren von Bibliotheken ist mit Recaf ein Kinderspiel! Am besten gleich einmal ausprobieren.
{{< terminal >}}
java -jar recaf-2.18.2-J8-jar-with-dependencies.jar
{{</ terminal >}}
