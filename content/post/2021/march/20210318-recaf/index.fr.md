+++
date = "2021-03-18"
title = "Brève histoire : Adapter des bibliothèques Java étrangères"
difficulty = "level-2"
tags = ["dekompilieren", "manipulieren", "Recaf", "rekompilieren", "reverse", "reverse-engineering"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/march/20210318-recaf/index.fr.md"
+++
L'autre jour, je voulais adapter des méthodes dans une bibliothèque Java étrangère et je cherchais donc un outil approprié. J'ai beaucoup étudié les éditeurs de bytecode et le bytecode. Mais finalement, je suis tombé sur Recaf et je suis absolument ravi : https://github.com/Col-E/Recaf
{{< gallery match="images/1/*.png" >}}
L'outil est disponible à l'adresse suivante : https://github.com/Col-E/Recaf/releases. Décompiler, recompiler et manipuler des bibliothèques est un jeu d'enfant avec Recaf ! Le mieux est de l'essayer tout de suite.
{{< terminal >}}
java -jar recaf-2.18.2-J8-jar-with-dependencies.jar

{{</ terminal >}}
