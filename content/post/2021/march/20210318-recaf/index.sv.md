+++
date = "2021-03-18"
title = "Kort berättelse: Anpassning av utländska Java-bibliotek"
difficulty = "level-2"
tags = ["dekompilieren", "manipulieren", "Recaf", "rekompilieren", "reverse", "reverse-engineering"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/march/20210318-recaf/index.sv.md"
+++
Häromdagen ville jag anpassa metoder i ett främmande Java-bibliotek och letade därför efter ett lämpligt verktyg. Jag har tittat mycket på bytecode-redigerare och bytecode. Men till slut fick jag Recaf och jag är helt förtjust: https://github.com/Col-E/Recaf
{{< gallery match="images/1/*.png" >}}
Verktyget finns på följande adress: https://github.com/Col-E/Recaf/releases. Dekompilering, omkompilering och manipulering av bibliotek är en barnlek med Recaf! Det är bäst att prova det direkt.
{{< terminal >}}
java -jar recaf-2.18.2-J8-jar-with-dependencies.jar

{{</ terminal >}}
