+++
date = "2020-02-13"
title = "Synology-Nas: Confluência como um sistema wiki"
difficulty = "level-4"
tags = ["atlassian", "confluence", "Docker", "ds918", "Synology", "wiki", "nas"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2020/february/20200213-synology-confluence/index.pt.md"
+++
Se você quiser instalar o Atlassian Confluence em um NAS Synology, então você está no lugar certo.
## Passo 1
Primeiro, abro o aplicativo Docker na interface Synology e depois vou para o subitem "Registration" (Registro). Lá eu procuro por "Confluência" e clico na primeira imagem "Atlassian Confluence".
{{< gallery match="images/1/*.png" >}}

## Passo 2
Após o download da imagem, a imagem está disponível como imagem. Docker distingue entre 2 estados, recipiente "estado dinâmico" e imagem/imagem (estado fixo). Antes de podermos criar um recipiente a partir da imagem, algumas configurações têm de ser feitas.
## Reinício automático
Faço duplo clique na minha imagem de Confluence.
{{< gallery match="images/2/*.png" >}}
Depois clico em "Definições avançadas" e activo o "Reinício automático".
{{< gallery match="images/3/*.png" >}}

## Portos
Atribuo portos fixos para o contentor Confluence. Sem portas fixas, a Confluência pode funcionar em uma porta diferente após um reinício.
{{< gallery match="images/4/*.png" >}}

## Memória
Eu crio uma pasta física e a monto no container (/var/atlassian/application-data/confluence/). Esta configuração facilita o backup e a restauração dos dados.
{{< gallery match="images/5/*.png" >}}
Depois destas configurações, a Confluência pode ser iniciada!
{{< gallery match="images/6/*.png" >}}