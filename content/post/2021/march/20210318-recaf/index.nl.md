+++
date = "2021-03-18"
title = "Kort verhaal: Aanpassen van buitenlandse Java bibliotheken"
difficulty = "level-2"
tags = ["dekompilieren", "manipulieren", "Recaf", "rekompilieren", "reverse", "reverse-engineering"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/march/20210318-recaf/index.nl.md"
+++
Laatst wilde ik methodes in een vreemde Java-bibliotheek aanpassen en was daarom op zoek naar een geschikt hulpmiddel. Ik heb veel gekeken naar bytecode-editors en bytecode. Maar uiteindelijk ben ik uitgekomen bij Recaf en ik ben er helemaal blij mee: https://github.com/Col-E/Recaf
{{< gallery match="images/1/*.png" >}}
Het instrument is te vinden op het volgende adres: https://github.com/Col-E/Recaf/releases. Decompileren, hercompileren en manipuleren van bibliotheken is kinderspel met Recaf! Het is het beste om het meteen uit te proberen.
{{< terminal >}}
java -jar recaf-2.18.2-J8-jar-with-dependencies.jar

{{</ terminal >}}
