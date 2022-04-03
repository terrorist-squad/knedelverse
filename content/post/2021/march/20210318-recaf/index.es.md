+++
date = "2021-03-18"
title = "Historia corta: Adaptación de bibliotecas Java extranjeras"
difficulty = "level-2"
tags = ["dekompilieren", "manipulieren", "Recaf", "rekompilieren", "reverse", "reverse-engineering"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/march/20210318-recaf/index.es.md"
+++
El otro día quise adaptar métodos de una biblioteca Java ajena y, por lo tanto, estaba buscando una herramienta adecuada. Busqué mucho en los editores de bytecode y en el bytecode. Pero finalmente acabé con Recaf y estoy absolutamente encantada: https://github.com/Col-E/Recaf
{{< gallery match="images/1/*.png" >}}
La herramienta se encuentra en la siguiente dirección: https://github.com/Col-E/Recaf/releases. ¡Descompilar, recompilar y manipular bibliotecas es un juego de niños con Recaf! Lo mejor es probarlo de inmediato.
{{< terminal >}}
java -jar recaf-2.18.2-J8-jar-with-dependencies.jar

{{</ terminal >}}

