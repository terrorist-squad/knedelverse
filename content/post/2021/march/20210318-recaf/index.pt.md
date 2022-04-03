+++
date = "2021-03-18"
title = "História curta: Adaptação de bibliotecas Java estrangeiras"
difficulty = "level-2"
tags = ["dekompilieren", "manipulieren", "Recaf", "rekompilieren", "reverse", "reverse-engineering"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/march/20210318-recaf/index.pt.md"
+++
No outro dia eu queria adaptar métodos numa biblioteca Java estrangeira e por isso estava à procura de uma ferramenta adequada. Procurei muito em editores de bytecode e bytecode. Mas finalmente acabei com o Recaf e estou absolutamente entusiasmado: https://github.com/Col-E/Recaf
{{< gallery match="images/1/*.png" >}}
A ferramenta pode ser encontrada no seguinte endereço: https://github.com/Col-E/Recaf/releases. Descompilar, recompilar e manipular bibliotecas é uma brincadeira de criança com o Recaf! É melhor experimentá-lo imediatamente.
{{< terminal >}}
java -jar recaf-2.18.2-J8-jar-with-dependencies.jar

{{</ terminal >}}

