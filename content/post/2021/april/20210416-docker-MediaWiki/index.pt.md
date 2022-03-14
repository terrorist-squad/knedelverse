+++
date = "2021-04-16"
title = "Coisas ótimas com recipientes: Instalando seu próprio MediaWiki na estação de disco Synology"
difficulty = "level-1"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "mediawiki", "wiki"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210416-docker-MediaWiki/index.pt.md"
+++
MediaWiki é um sistema wiki baseado em PHP que está disponível gratuitamente como um produto de código aberto. Hoje eu mostro como instalar um serviço MediaWiki na estação de disco Synology.
## Opção para profissionais
Como um usuário experiente de Synology, é claro que você pode fazer login com SSH e instalar toda a configuração via arquivo Docker Compose.
```
version: '3'
services:
  mediawiki:
    image: mediawiki
    restart: always
    ports:
      - 8081:80
    links:
      - database
    volumes:
      - ./images:/var/www/html/images
      # After initial setup, download LocalSettings.php to the same directory as
      # this yaml and uncomment the following line and use compose to restart
      # the mediawiki service
      # - ./LocalSettings.php:/var/www/html/LocalSettings.php

  database:
    image: mariadb
    restart: always
    volumes:
       - ./mysql:/var/lib/mysql
    environment:
      # @see https://phabricator.wikimedia.org/source/mediawiki/browse/master/includes/DefaultSettings.php
      MYSQL_ROOT_PASSWORD: my_wiki_pass1
      MYSQL_DATABASE: my_wiki
      MYSQL_USER: wikiuser
      MYSQL_PASSWORD: my_wiki_pass

```
Imagens mais úteis do Docker para uso doméstico podem ser encontradas no [Dockerverse]({{< ref "dockerverse" >}} "Dockerverse").
## Passo 1: Prepare a pasta MediaWiki
Eu crio um novo diretório chamado "wiki" no diretório Docker.
{{< gallery match="images/1/*.png" >}}

## Passo 2: Instalar base de dados
Depois disso, um banco de dados deve ser criado. Clico na guia "Registration" na janela do Synology Docker e procuro por "mariadb". Selecciono a imagem do Docker "mariadb" e depois clico na etiqueta "latest".
{{< gallery match="images/2/*.png" >}}
Após o download da imagem, a imagem está disponível como imagem. Docker distingue entre 2 estados, "estado dinâmico" do contentor e imagem (estado fixo). Antes de criarmos um recipiente a partir da imagem, algumas configurações têm de ser feitas. Eu faço duplo clique na minha imagem mariadb.
{{< gallery match="images/3/*.png" >}}
Depois clico em "Definições avançadas" e activo o "Reinício automático". Eu seleciono o separador "Volume" e clico em "Adicionar pasta". Lá eu crio uma nova pasta de banco de dados com este caminho de montagem "/var/lib/mysql".
{{< gallery match="images/4/*.png" >}}
Em "Port settings", todas as portas são apagadas. Isto significa que seleciono a porta "3306" e a apago com o botão "-".
{{< gallery match="images/5/*.png" >}}
{{<table "table table-striped table-bordered">}}
|Nome da variável|Valor|O que é isso?|
|--- | --- |---|
|TZ	| Europe/Berlin	|Fuso horário|
|MYSQL_ROOT_PASSWORD	| my_wiki_pass	|Senha principal da base de dados.|
|MYSQL_DATABASE |	my_wiki	|Este é o nome da base de dados.|
|MYSQL_USER	| wikiuser |Nome do usuário da base de dados wiki.|
|MYSQL_PASSWORD	| my_wiki_pass |Senha do usuário da base de dados wiki.|
{{</table>}}
Finalmente, eu entro nestas variáveis de ambiente:Veja:
{{< gallery match="images/6/*.png" >}}
Após estas configurações, o servidor Mariadb pode ser iniciado! Eu carrego em "Aplicar" em todo o lado.
## Passo 3: Instalar o MediaWiki
Clico na guia "Registration" na janela do Synology Docker e procuro por "mediawiki". Selecciono a imagem do Docker "mediawiki" e depois clico na etiqueta "latest".
{{< gallery match="images/7/*.png" >}}
Eu faço duplo clique na minha imagem Mediawiki.
{{< gallery match="images/8/*.png" >}}
Depois clique em "Configurações avançadas" e ative o "Reinício automático" aqui também. Eu seleciono o separador "Volume" e clico em "Adicionar pasta". Lá eu crio uma nova pasta com este caminho de montagem "/var/wwww/html/images".
{{< gallery match="images/9/*.png" >}}
Eu atribuo portos fixos para o contentor "MediaWiki". Sem portas fixas, pode ser que o "servidor MediaWiki" seja executado em uma porta diferente após um reinício.
{{< gallery match="images/10/*.png" >}}
Além disso, ainda é necessário criar uma "ligação" com o contentor "mariadb". Clico no separador "Links" e selecciono o contentor da base de dados. O nome falso deve ser lembrado para a instalação do wiki.
{{< gallery match="images/11/*.png" >}}
Finalmente, introduzo uma variável de ambiente "TZ" com o valor "Europa/Berlim".
{{< gallery match="images/12/*.png" >}}
O contentor pode agora ser iniciado. Eu chamo o servidor Mediawiki com o endereço IP Synology e minha porta de contêiner. Em Database server introduzo o nome alternativo do contentor da base de dados. Eu também introduzo o nome da base de dados, nome de utilizador e palavra-passe do "Passo 2".
{{< gallery match="images/13/*.png" >}}