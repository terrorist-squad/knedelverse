+++
date = "2021-04-16"
title = "Grandes coisas com recipientes: Instalação do Wiki.js no Synology Diskstation"
difficulty = "level-1"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "wikijs", "wiki"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210416-docker-Wikijs/index.pt.md"
+++
Wiki.js é um poderoso software wiki de código aberto que torna a documentação um prazer com sua interface simples. Hoje eu mostro como instalar um serviço Wiki.js no Synology DiskStation.
## Opção para profissionais
Como um usuário experiente de Synology, é claro que você pode fazer login com SSH e instalar toda a configuração via arquivo Docker Compose.
```
version: '3'
services:
  wikijs:
    image: requarks/wiki:latest
    restart: always
    ports:
      - 8082:3000
    links:
      - database
    environment:
      DB_TYPE: mysql
      DB_HOST: database
      DB_PORT: 3306
      DB_NAME: my_wiki
      DB_USER: wikiuser
      DB_PASS: my_wiki_pass
      TZ: 'Europe/Berlin'

  database:
    image: mysql
    restart: always
    expose:
      - 3306
    volumes:
       - ./mysql:/var/lib/mysql
    environment:
      MYSQL_ROOT_PASSWORD: my_wiki_pass
      MYSQL_DATABASE: my_wiki
      MYSQL_USER: wikiuser
      MYSQL_PASSWORD: my_wiki_pass

```
Você pode encontrar mais imagens Docker úteis para uso doméstico no Dockerverse.
## Passo 1: Prepare a pasta wiki
Eu crio um novo diretório chamado "wiki" no diretório Docker.
{{< gallery match="images/1/*.png" >}}

## Passo 2: Instalar base de dados
Depois disso, um banco de dados deve ser criado. Clico na guia "Registration" na janela do Synology Docker e procuro por "mysql". Selecciono a imagem do Docker "mysql" e depois clico na etiqueta "latest".
{{< gallery match="images/2/*.png" >}}
Após o download da imagem, a imagem está disponível como imagem. Docker distingue entre 2 estados, "estado dinâmico" do contentor e imagem (estado fixo). Antes de criarmos um recipiente a partir da imagem, algumas configurações têm de ser feitas. Eu faço duplo clique na minha imagem mysql.
{{< gallery match="images/3/*.png" >}}
Depois clico em "Definições avançadas" e activo o "Reinício automático". Selecciono o separador "Volume" e clico em "Adicionar pasta". Lá eu crio uma nova pasta de banco de dados com este caminho de montagem "/var/lib/mysql".
{{< gallery match="images/4/*.png" >}}
Em "Port settings", todas as portas são apagadas. Isto significa que seleciono a porta "3306" e a apago com o botão "-".
{{< gallery match="images/5/*.png" >}}
{{<table "table table-striped table-bordered">}}
|Nome da variável|Valor|O que é isso?|
|--- | --- |---|
|TZ	| Europe/Berlin |Fuso horário|
|MYSQL_ROOT_PASSWORD	| my_wiki_pass |Senha principal da base de dados.|
|MYSQL_DATABASE |	my_wiki |Este é o nome da base de dados.|
|MYSQL_USER	| wikiuser |Nome do usuário da base de dados wiki.|
|MYSQL_PASSWORD |	my_wiki_pass	|Senha do usuário da base de dados wiki.|
{{</table>}}
Finalmente, introduzo estas quatro variáveis de ambiente:Veja:
{{< gallery match="images/6/*.png" >}}
Após estas configurações, o servidor Mariadb pode ser iniciado! Eu carrego em "Aplicar" em todo o lado.
## Passo 3: Instalar o Wiki.js
Clico na guia "Registration" na janela do Synology Docker e procuro por "wiki". Selecciono a imagem do Docker "requarks/wiki" e depois clico na etiqueta "latest".
{{< gallery match="images/7/*.png" >}}
Eu faço duplo clique na minha imagem do WikiJS. Depois clique em "Configurações avançadas" e ative o "Reinício automático" aqui também.
{{< gallery match="images/8/*.png" >}}
Eu atribuo portos fixos para o contentor "WikiJS". Sem portas fixas, poderia ser que o "booktack server" funcione em uma porta diferente após um reinício.
{{< gallery match="images/9/*.png" >}}
Além disso, um "link" para o recipiente "mysql" ainda precisa ser criado. Clico no separador "Links" e selecciono o contentor da base de dados. O nome falso deve ser lembrado para a instalação do wiki.
{{< gallery match="images/10/*.png" >}}
{{<table "table table-striped table-bordered">}}
|Nome da variável|Valor|O que é isso?|
|--- | --- |---|
|TZ	| Europe/Berlin	|Fuso horário|
|DB_HOST	| wiki-db	|Nomes de pseudônimos / link do container|
|DB_TYPE	| mysql	||
|DB_PORT	| 3306	 ||
|DB_PASSWORD	| my_wiki	|Dados da etapa 2|
|DB_USER	| wikiuser |Dados da etapa 2|
|DB_PASS	| my_wiki_pass	|Dados da etapa 2|
{{</table>}}
Finalmente, eu entro nestas variáveis de ambiente:Veja:
{{< gallery match="images/11/*.png" >}}
O contentor pode agora ser iniciado. Eu chamo o servidor Wiki.js com o endereço IP Synology e minha porta de contêiner/3000.
{{< gallery match="images/12/*.png" >}}
