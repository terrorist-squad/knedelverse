+++
date = "2020-02-14"
title = "Gerar PDF de visão geral da página"
difficulty = "level-3"
tags = ["bash", "linux", "pdf", "postscript", "imagemagick"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2020/february/20200214-imagemagick-pdf-overview/index.pt.md"
+++
Se você quer criar uma imagem panorâmica da página a partir de um arquivo PDF, então você veio ao lugar certo!
{{< gallery match="images/1/*.jpg" >}}

## Passo 1: Criar pasta de trabalho
Use este comando para criar uma pasta de trabalho temporária:
{{< terminal >}}
mkdir /tmp/bilder

{{</ terminal >}}

## Passo 2: Página separada
O seguinte comando cria uma imagem de cada página PDF:
{{< terminal >}}
convert 716023b632a9cbe6cad3ab368c202288.pdf /tmp/bilder/page.png

{{</ terminal >}}

## Passo 3: Montagem das imagens
Agora a colagem só precisa de ser montada:
{{< terminal >}}
montage /tmp/bilder/* -shadow -geometry '400x400+2+2>' -background '#f1f1f1' uebersich.jpg

{{</ terminal >}}
