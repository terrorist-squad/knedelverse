+++
date = "2021-04-25T09:28:11+01:00"
title = "BitwardenRS no Synology DiskStation"
difficulty = "level-2"
tags = ["bitwardenrs", "Docker", "docker-compose", "password-manager", "passwort", "Synology"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210425-docker-BitwardenRS/index.pt.md"
+++
Bitwarden é um serviço gratuito de gerenciamento de senhas de código aberto que armazena informações confidenciais, como credenciais de sites em um cofre criptografado. Hoje eu mostro como instalar um BitwardenRS no Synology DiskStation.
## Passo 1: Prepare a pasta BitwardenRS
Eu crio um novo diretório chamado "bitwarden" no diretório Docker.
{{< gallery match="images/1/*.png" >}}

## Passo 2: Instalar BitwardenRS
Clico na guia "Registration" na janela do Synology Docker e procuro por "bitwarden". Selecciono a imagem do Docker "bitwardenrs/server" e depois clico na etiqueta "latest".
{{< gallery match="images/2/*.png" >}}
Faço duplo clique na minha imagem de bitwardenrs. Depois clique em "Configurações avançadas" e ative o "Reinício automático" aqui também.
{{< gallery match="images/3/*.png" >}}
Selecciono o separador "Volume" e clico em "Adicionar Pasta". Lá eu crio uma nova pasta com este caminho de montagem "/dados".
{{< gallery match="images/4/*.png" >}}
Eu atribuo portos fixos para o contentor "bitwardenrs". Sem portas fixas, poderia ser que o "bitwardenrs server" funcione em uma porta diferente após um reinício. O primeiro porto de contentores pode ser apagado. O outro porto deve ser lembrado.
{{< gallery match="images/5/*.png" >}}
O contentor pode agora ser iniciado. Eu chamo o servidor bitwardenrs com o endereço IP Synology e minha porta de contêiner 8084.
{{< gallery match="images/6/*.png" >}}

## Passo 3: Configurar HTTPS
Clico em "Painel de Controlo" > "Reverter Proxy" e "Criar".
{{< gallery match="images/7/*.png" >}}
Depois disso, posso chamar o servidor bitwardenrs com o endereço IP Synology e minha porta proxy 8085, criptografada.
{{< gallery match="images/8/*.png" >}}
