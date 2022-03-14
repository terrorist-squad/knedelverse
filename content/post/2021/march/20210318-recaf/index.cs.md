+++
date = "2021-03-18"
title = "Krátký příběh: Přizpůsobení zahraničních knihoven Javy"
difficulty = "level-2"
tags = ["dekompilieren", "manipulieren", "Recaf", "rekompilieren", "reverse", "reverse-engineering"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/march/20210318-recaf/index.cs.md"
+++
Nedávno jsem chtěl upravit metody v cizí knihovně Javy, a proto jsem hledal vhodný nástroj. Hodně jsem se zabýval editory bajtového kódu a bajtového kódu. Ale nakonec jsem skončila u Recafu a jsem naprosto nadšená: https://github.com/Col-E/Recaf
{{< gallery match="images/1/*.png" >}}
Nástroj naleznete na následující adrese: https://github.com/Col-E/Recaf/releases. Dekompilace, rekompilace a manipulace s knihovnami je s programem Recaf hračka! Nejlepší je vyzkoušet ji hned.
{{< terminal >}}
java -jar recaf-2.18.2-J8-jar-with-dependencies.jar

{{</ terminal >}}
