+++
date = "2021-07-25"
title = "Grandes coisas com contentores: gestão de frigoríficos com Grocy"
difficulty = "level-1"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "kühlschrank", "erp", "mhd", "Speispläne", "cms", "Cafe", "Bistro"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/july/20210725-docker-grocy/index.pt.md"
+++
Com Grocy você pode administrar uma casa inteira, restaurante, café, bistrô ou mercado de comida. Você pode gerir frigoríficos, menus, tarefas, listas de compras e a melhor data antes da comida.
{{< gallery match="images/1/*.png" >}}
Hoje eu mostro como instalar um serviço Grocy na estação de disco Synology.
## Opção para profissionais
Como um usuário experiente de Synology, é claro que você pode fazer login com SSH e instalar toda a configuração via arquivo Docker Compose.
```
version: "2.1"
services:
  grocy:
    image: ghcr.io/linuxserver/grocy
    container_name: grocy
    environment:
      - PUID=1024
      - PGID=100
      - TZ=Europe/Berlin
    volumes:
      - ./data:/config
    ports:
      - 9283:80
    restart: unless-stopped

```
Imagens mais úteis do Docker para uso doméstico podem ser encontradas no [Dockerverse]({{< ref "dockerverse" >}} "Dockerverse").
## Passo 1: Prepare a pasta Grocy
Eu crio um novo diretório chamado "grocy" no diretório Docker.
{{< gallery match="images/2/*.png" >}}

## Passo 2: Instale o Grocy
Clico na guia "Registration" na janela do Synology Docker e procuro por "Grocy". Eu seleciono a imagem Docker "linuxserver/grocy:latest" e depois clico na tag "latest".
{{< gallery match="images/3/*.png" >}}
Faço duplo clique na minha imagem Grocy.
{{< gallery match="images/4/*.png" >}}
Depois clique em "Configurações avançadas" e ative o "Reinício automático" aqui também. Eu seleciono o separador "Volume" e clico em "Adicionar pasta". Lá eu crio uma nova pasta com este caminho de montagem "/config".
{{< gallery match="images/5/*.png" >}}
Eu atribuo portos fixos para o contentor "Grocy". Sem portas fixas, poderia ser que o "Grocy server" funcione em uma porta diferente após um reinício.
{{< gallery match="images/6/*.png" >}}
{{<table "table table-striped table-bordered">}}
|Nome da variável|Valor|O que é isso?|
|--- | --- |---|
|TZ | Europe/Berlin |Fuso horário|
|PUID | 1024 |ID do usuário do Synology Admin Usuário|
|PGID |	100 |ID de grupo do usuário do Synology Admin|
{{</table>}}
Finalmente, eu entro nestas variáveis de ambiente:Veja:
{{< gallery match="images/7/*.png" >}}
O contentor pode agora ser iniciado. Chamo o servidor Grocy com o endereço IP de Synology e minha porta de contêiner e faço login com o nome de usuário "admin" e a senha "admin".
{{< gallery match="images/8/*.png" >}}
