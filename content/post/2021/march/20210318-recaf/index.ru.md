+++
date = "2021-03-18"
title = "Краткая история: Адаптация иностранных библиотек Java"
difficulty = "level-2"
tags = ["dekompilieren", "manipulieren", "Recaf", "rekompilieren", "reverse", "reverse-engineering"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/march/20210318-recaf/index.ru.md"
+++
На днях я хотел адаптировать методы в иностранной библиотеке Java и поэтому искал подходящий инструмент. Я много изучал редакторы байткода и байткод. Но в итоге я остановился на Recaf, и я в полном восторге: https://github.com/Col-E/Recaf.
{{< gallery match="images/1/*.png" >}}
Инструмент можно найти по следующему адресу: https://github.com/Col-E/Recaf/releases. Декомпиляция, перекомпиляция и работа с библиотеками - это детская забава с Recaf! Лучше всего попробовать сразу.
{{< terminal >}}
java -jar recaf-2.18.2-J8-jar-with-dependencies.jar

{{</ terminal >}}
