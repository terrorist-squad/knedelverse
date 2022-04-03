+++
date = "2021-03-18"
title = "Breve storia: adattamento di librerie Java straniere"
difficulty = "level-2"
tags = ["dekompilieren", "manipulieren", "Recaf", "rekompilieren", "reverse", "reverse-engineering"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/march/20210318-recaf/index.it.md"
+++
L'altro giorno volevo adattare dei metodi in una libreria Java straniera e stavo quindi cercando uno strumento adatto. Ho cercato molto negli editor di bytecode e nel bytecode. Ma alla fine ho finito con Recaf e sono assolutamente entusiasta: https://github.com/Col-E/Recaf
{{< gallery match="images/1/*.png" >}}
Lo strumento può essere trovato al seguente indirizzo: https://github.com/Col-E/Recaf/releases. Decompilare, ricompilare e manipolare le librerie è un gioco da ragazzi con Recaf! È meglio provarlo subito.
{{< terminal >}}
java -jar recaf-2.18.2-J8-jar-with-dependencies.jar

{{</ terminal >}}

