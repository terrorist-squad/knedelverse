+++
date = "2021-03-18"
title = "Krátky príbeh: Prispôsobenie zahraničných knižníc Java"
difficulty = "level-2"
tags = ["dekompilieren", "manipulieren", "Recaf", "rekompilieren", "reverse", "reverse-engineering"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/march/20210318-recaf/index.sk.md"
+++
Minule som chcel upraviť metódy v cudzej knižnici Javy, a preto som hľadal vhodný nástroj. Veľa som sa zaoberal editormi bajtkódu a bajtkódom. Nakoniec som však skončila s Recafom a som úplne nadšená: https://github.com/Col-E/Recaf
{{< gallery match="images/1/*.png" >}}
Nástroj nájdete na tejto adrese: https://github.com/Col-E/Recaf/releases. Dekompilácia, rekompilácia a manipulácia s knižnicami je s programom Recaf hračka! Najlepšie je vyskúšať to hneď.
{{< terminal >}}
java -jar recaf-2.18.2-J8-jar-with-dependencies.jar

{{</ terminal >}}
