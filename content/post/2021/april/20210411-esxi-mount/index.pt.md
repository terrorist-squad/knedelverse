+++
date = "2021-04-11"
title = "História curta: Conectando volumes de Synology ao ESXi."
difficulty = "level-1"
tags = ["dos", "esxi", "khk-kaufmann-v1", "nuc", "pc-kaufmann", "Synology", "vmware"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210411-esxi-mount/index.pt.md"
+++

## Passo 1: Ativar o serviço "NFS
Primeiro, o serviço "NFS" deve ser ativado no Diskstation. Para fazer isso, vou para o "Painel de Controle" > "Serviços de Arquivo" e clique em "Habilitar NFS".
{{< gallery match="images/1/*.png" >}}
Depois clico em "Shared folder" e selecciono um directório.
{{< gallery match="images/2/*.png" >}}

## Passo 2: Montar diretórios no ESXi
No ESXi, clico em "Storage" > "New datastore" e introduzo lá os meus dados.
{{< gallery match="images/3/*.png" >}}

## Pronto
Agora a memória pode ser usada.
{{< gallery match="images/4/*.png" >}}
Para testes, instalei uma instalação DOS e um software de contabilidade antigo através deste ponto de montagem.
{{< gallery match="images/5/*.png" >}}
