+++
date = "2021-09-05"
title = "Coisas ótimas com containers: Servidores de mídia Logitech na estação de disco Synology"
difficulty = "level-1"
tags = ["logitech", "synology", "diskstation", "nas", "sound-system", "multiroom"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/september/20210905-logitech-mediaserver/index.pt.md"
+++
Neste tutorial, você aprenderá como instalar um Servidor de mídia Logitech no Synology DiskStation.
{{< gallery match="images/1/*.jpg" >}}

## Passo 1: Prepare a pasta do Logitech Media Server
Eu crio um novo diretório chamado "logitechmediaserver" no diretório Docker.
{{< gallery match="images/2/*.png" >}}

## Passo 2: Instalar a imagem do Logitech Mediaserver
Clico na guia "Registration" na janela do Synology Docker e procuro por "logitechmediaserver". Selecciono a imagem do Docker "lmscommunity/logitechmediaserver" e depois clico na etiqueta "latest".
{{< gallery match="images/3/*.png" >}}
Faço duplo clique na minha imagem do Logitech Media Server. Depois clique em "Configurações avançadas" e ative o "Reinício automático" aqui também.
{{< gallery match="images/4/*.png" >}}
{{<table "table table-striped table-bordered">}}
|Ordner |Caminho do Monte|
|--- |---|
|/volume1/docker/logitechmediaserver/config |/configurar|
|/volume1/docker/logitechmediaserver/music |/music|
|/volume1/docker/logitechmediaserver/playlist |/playlist|
{{</table>}}
Selecciono o separador "Volume" e clico em "Adicionar pasta". Lá eu crio três pastas: Veja:
{{< gallery match="images/5/*.png" >}}
Atribuo portos fixos para o contentor "Logitechmediaserver". Sem portas fixas, poderia ser que o "Logitechmediaserver server" funcione em uma porta diferente após um reinício.
{{< gallery match="images/6/*.png" >}}
Finalmente, eu entro uma variável de ambiente. A variável "TZ" é o fuso horário "Europa/Berlim".
{{< gallery match="images/7/*.png" >}}
Após estas configurações, o Logitechmediaserver-Server pode ser iniciado! Em seguida, você pode chamar o Logitechmediaserver através do endereço Ip do disco Synology e da porta atribuída, por exemplo http://192.168.21.23:9000 .
{{< gallery match="images/8/*.png" >}}
