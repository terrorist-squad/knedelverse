+++
date = "2021-03-18"
title = "Krótka historia: Adaptacja obcych bibliotek Java"
difficulty = "level-2"
tags = ["dekompilieren", "manipulieren", "Recaf", "rekompilieren", "reverse", "reverse-engineering"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/march/20210318-recaf/index.pl.md"
+++
Niedawno chciałem zaadaptować metody w zagranicznej bibliotece Javy i w związku z tym szukałem odpowiedniego narzędzia. Przyjrzałem się edytorom kodu bajtowego i kodowi bajtowemu. Ale w końcu trafiłam na Recaf i jestem absolutnie zachwycona: https://github.com/Col-E/Recaf
{{< gallery match="images/1/*.png" >}}
Narzędzie to można znaleźć pod następującym adresem: https://github.com/Col-E/Recaf/releases. Dekompilacja, rekompilacja i manipulacja bibliotekami jest dziecinnie prosta z Recaf! Najlepiej wypróbować go od razu.
{{< terminal >}}
java -jar recaf-2.18.2-J8-jar-with-dependencies.jar

{{</ terminal >}}
