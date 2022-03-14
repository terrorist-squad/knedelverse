+++
date = "2021-03-18"
title = "Rövid történet: Idegen Java könyvtárak adaptálása"
difficulty = "level-2"
tags = ["dekompilieren", "manipulieren", "Recaf", "rekompilieren", "reverse", "reverse-engineering"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/march/20210318-recaf/index.hu.md"
+++
A minap egy idegen Java könyvtár metódusait akartam adaptálni, és ezért kerestem egy megfelelő eszközt. Sokat foglalkoztam a bytecode-szerkesztőkkel és a bytecode-okkal. De végül a Recafnál kötöttem ki, és teljesen el vagyok ragadtatva: https://github.com/Col-E/Recaf
{{< gallery match="images/1/*.png" >}}
Az eszköz a következő címen érhető el: https://github.com/Col-E/Recaf/releases. A könyvtárak dekompilálása, újrafordítása és manipulálása gyerekjáték a Recaf! A legjobb, ha azonnal kipróbálod.
{{< terminal >}}
java -jar recaf-2.18.2-J8-jar-with-dependencies.jar

{{</ terminal >}}
