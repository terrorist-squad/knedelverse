+++
date = "2021-04-16"
title = "Grandes coisas com recipientes: Seu próprio Bookstack Wiki sobre o Synology DiskStation"
difficulty = "level-1"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "bookstack", "wiki"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/april/20210416-docker-Bookstack/index.pt.md"
+++
O Bookstack é uma alternativa "open source" ao MediaWiki ou Confluence. Hoje eu mostro como instalar um serviço de Bookstack na estação de disco Synology.
## Opção para profissionais
Como um usuário experiente de Synology, é claro que você pode fazer login com SSH e instalar toda a configuração via arquivo Docker Compose.
```
version: '3'
services:
  bookstack:
    image: solidnerd/bookstack:0.27.4-1
    restart: always
    ports:
      - 8080:8080
    links:
      - database
    environment:
      DB_HOST: database:3306
      DB_DATABASE: my_wiki
      DB_USERNAME: wikiuser
      DB_PASSWORD: my_wiki_pass
      
  database:
    image: mariadb
    restart: always
    volumes:
       - ./mysql:/var/lib/mysql
    environment:
      MYSQL_ROOT_PASSWORD: my_wiki_pass1
      MYSQL_DATABASE: my_wiki
      MYSQL_USER: wikiuser
      MYSQL_PASSWORD: my_wiki_pass

```
Imagens mais úteis do Docker para uso doméstico podem ser encontradas no [Dockerverse]({{< ref "dockerverse" >}} "Dockerverse").
## Passo 1: Preparar a pasta da pilha de livros
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
|TZ	| Europe/Berlin |Fuso horário|
|MYSQL_ROOT_PASSWORD	|  my_wiki_pass |Senha principal da base de dados.|
|MYSQL_DATABASE | 	my_wiki	|Este é o nome da base de dados.|
|MYSQL_USER	|  wikiuser	|Nome do usuário da base de dados wiki.|
|MYSQL_PASSWORD	|  my_wiki_pass	|Senha do usuário da base de dados wiki.|
{{</table>}}
Finalmente, eu entro nestas variáveis de ambiente:Veja:
{{< gallery match="images/6/*.png" >}}
Após estas configurações, o servidor Mariadb pode ser iniciado! Eu carrego em "Aplicar" em todo o lado.
## Passo 3: Instalar o Livraria
Clico na guia "Registration" na janela do Synology Docker e procuro por "bookstack". Selecciono a imagem Docker "solidnerd/bookstack" e depois clico na etiqueta "latest".
{{< gallery match="images/7/*.png" >}}
Faço duplo clique na minha imagem do Bookstack. Depois clique em "Configurações avançadas" e ative o "Reinício automático" aqui também.
{{< gallery match="images/8/*.png" >}}
Atribuo portos fixos para o contentor "estante". Sem portas fixas, poderia ser que o "booktack server" funcione em uma porta diferente após um reinício. O primeiro porto de contentores pode ser apagado. O outro porto deve ser lembrado.
{{< gallery match="images/9/*.png" >}}
Além disso, ainda é necessário criar uma "ligação" com o contentor "mariadb". Clico no separador "Links" e selecciono o contentor da base de dados. O nome falso deve ser lembrado para a instalação do wiki.
{{< gallery match="images/10/*.png" >}}
{{<table "table table-striped table-bordered">}}
|Nome da variável|Valor|O que é isso?|
|--- | --- |---|
|TZ	| Europe/Berlin |Fuso horário|
|DB_HOST	| wiki-db:3306	|Nomes de pseudônimos / link do container|
|DB_DATABASE	| my_wiki |Dados da etapa 2|
|DB_USERNAME	| wikiuser |Dados da etapa 2|
|DB_PASSWORD	| my_wiki_pass	|Dados da etapa 2|
{{</table>}}
Finalmente, eu entro nestas variáveis de ambiente:Veja:
{{< gallery match="images/11/*.png" >}}
O contentor pode agora ser iniciado. Pode demorar algum tempo a criar a base de dados. O comportamento pode ser observado através dos detalhes do recipiente.
{{< gallery match="images/12/*.png" >}}
Eu chamo o servidor Bookstack com o endereço IP Synology e minha porta de contêineres. O nome de login é "admin@admin.com" e a senha é "password".
{{< gallery match="images/13/*.png" >}}
