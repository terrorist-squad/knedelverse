+++
date = "2021-03-18"
title = "Kort fortælling: Tilpasning af udenlandske Java-biblioteker"
difficulty = "level-2"
tags = ["dekompilieren", "manipulieren", "Recaf", "rekompilieren", "reverse", "reverse-engineering"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/march/20210318-recaf/index.da.md"
+++
Forleden ville jeg tilpasse metoder i et fremmed Java-bibliotek og ledte derfor efter et passende værktøj. Jeg har kigget meget på bytecode-editorer og bytecode. Men endelig endte jeg med Recaf, og jeg er helt vild med det: https://github.com/Col-E/Recaf
{{< gallery match="images/1/*.png" >}}
Værktøjet kan findes på følgende adresse: https://github.com/Col-E/Recaf/releases. Dekompilering, omkompilering og manipulation af biblioteker er en leg for børn med Recaf! Det er bedst at afprøve det med det samme.
{{< terminal >}}
java -jar recaf-2.18.2-J8-jar-with-dependencies.jar

{{</ terminal >}}
