+++
date = "2021-04-18"
title = "Coisas ótimas com recipientes: Instalando seu próprio dokuWiki na estação de disco Synology"
difficulty = "level-2"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "dokuwiki", "wiki"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210418-docker-dokuWiki/index.pt.md"
+++
O DokuWiki é um software wiki compatível com os padrões, fácil de usar e ao mesmo tempo extremamente versátil e de código aberto. Hoje eu mostro como instalar um serviço DokuWiki na estação de disco Synology.
## Opção para profissionais
Como um usuário experiente de Synology, é claro que você pode fazer login com SSH e instalar toda a configuração via arquivo Docker Compose.
```
version: '3'
services:
  dokuwiki:
    image:  bitnami/dokuwiki:latest
    restart: always
    ports:
      - 8080:8080
      - 8443:8443
    environment:
      TZ: 'Europe/Berlin'
      DOKUWIKI_USERNAME: 'admin'
      DOKUWIKI_FULL_NAME: 'wiki'
      DOKUWIKI_PASSWORD: 'password'
    volumes:
      - ./data:/bitnami/dokuwiki

```
Imagens mais úteis do Docker para uso doméstico podem ser encontradas no [Dockerverse]({{< ref "dockerverse" >}} "Dockerverse").
## Passo 1: Prepare a pasta wiki
Eu crio um novo diretório chamado "wiki" no diretório Docker.
{{< gallery match="images/1/*.png" >}}

## Passo 2: Instalar o DokuWiki
Depois disso, tem de ser criada uma base de dados. Clico na guia "Registration" na janela do Synology Docker e procuro por "dokuwiki". Eu seleciono a imagem do Docker "bitnami/dokuwiki" e depois clico na tag "latest".
{{< gallery match="images/2/*.png" >}}
Após o download da imagem, a imagem está disponível como imagem. Docker distingue entre 2 estados, "estado dinâmico" do contentor e imagem (estado fixo). Antes de criarmos um recipiente a partir da imagem, algumas configurações têm de ser feitas. Eu faço duplo clique na minha imagem dokuwiki.
{{< gallery match="images/3/*.png" >}}
Eu atribuo portos fixos para o contentor "dokuwiki". Sem portas fixas, poderia ser que o "servidor dokuwiki" funcione em uma porta diferente após um reinício.
{{< gallery match="images/4/*.png" >}}
{{<table "table table-striped table-bordered">}}
|Nome da variável|Valor|O que é isso?|
|--- | --- |---|
|TZ	| Europe/Berlin	|Fuso horário|
|DOKUWIKI_USERNAME	| admin|Nome de usuário de administração|
|DOKUWIKI_FULL_NAME |	wiki	|nome WIki|
|DOKUWIKI_PASSWORD	| password	|Senha de administração|
{{</table>}}
Finalmente, eu entro nestas variáveis de ambiente:Veja:
{{< gallery match="images/5/*.png" >}}
O contentor pode agora ser iniciado. Eu chamo o servidor dokuWIki com o endereço IP Synology e a porta do meu contêiner.
{{< gallery match="images/6/*.png" >}}
