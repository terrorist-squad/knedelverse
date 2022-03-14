+++
date = "2021-03-18"
title = "Кратка история: Адаптиране на чужди библиотеки на Java"
difficulty = "level-2"
tags = ["dekompilieren", "manipulieren", "Recaf", "rekompilieren", "reverse", "reverse-engineering"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/march/20210318-recaf/index.bg.md"
+++
Онзи ден исках да адаптирам методи в чужда библиотека на Java и затова търсех подходящ инструмент. Разгледах много редактори на байткод и байткод. Но накрая се оказах с Recaf и съм абсолютно развълнувана: https://github.com/Col-E/Recaf
{{< gallery match="images/1/*.png" >}}
Инструментът може да бъде намерен на следния адрес: https://github.com/Col-E/Recaf/releases. Декомпилирането, прекомпилирането и манипулирането на библиотеки е детска игра с Recaf! Най-добре е да го изпробвате веднага.
{{< terminal >}}
java -jar recaf-2.18.2-J8-jar-with-dependencies.jar

{{</ terminal >}}
