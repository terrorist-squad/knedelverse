+++
date = "2021-04-18"
title = "Grandes coisas com recipientes: WallaBag próprio na estação de disco Synology"
difficulty = "level-1"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "archiv", "wallabag"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210418-docker-WallaBag/index.pt.md"
+++
Wallabag é um programa de arquivamento de sites ou artigos interessantes. Hoje eu mostro como instalar um serviço Wallabag na estação de disco Synology.
## Opção para profissionais
Como um usuário experiente de Synology, é claro que você pode fazer login com SSH e instalar toda a configuração via arquivo Docker Compose.
```
version: '3'
services:
  wallabag:
    image: wallabag/wallabag
    environment:
      - MYSQL_ROOT_PASSWORD=wallaroot
      - SYMFONY__ENV__DATABASE_DRIVER=pdo_mysql
      - SYMFONY__ENV__DATABASE_HOST=db
      - SYMFONY__ENV__DATABASE_PORT=3306
      - SYMFONY__ENV__DATABASE_NAME=wallabag
      - SYMFONY__ENV__DATABASE_USER=wallabag
      - SYMFONY__ENV__DATABASE_PASSWORD=wallapass
      - SYMFONY__ENV__DATABASE_CHARSET=utf8mb4
      - SYMFONY__ENV__DOMAIN_NAME=http://192.168.178.50:8089
      - SYMFONY__ENV__SERVER_NAME="Your wallabag instance"
      - SYMFONY__ENV__FOSUSER_CONFIRMATION=false
      - SYMFONY__ENV__TWOFACTOR_AUTH=false
    ports:
      - "8089:80"
    volumes:
      - ./wallabag/images:/var/www/wallabag/web/assets/images

  db:
    image: mariadb
    environment:
      - MYSQL_ROOT_PASSWORD=wallaroot
    volumes:
      - ./mariadb:/var/lib/mysql

```
Imagens mais úteis do Docker para uso doméstico podem ser encontradas no [Dockerverse]({{< ref "dockerverse" >}} "Dockerverse").
## Passo 1: Prepare a pasta do saco de parede
Eu crio um novo diretório chamado "wallabag" no diretório Docker.
{{< gallery match="images/1/*.png" >}}

## Passo 2: Instalar base de dados
Depois disso, um banco de dados deve ser criado. Clico na guia "Registration" na janela do Synology Docker e procuro por "mariadb". Selecciono a imagem do Docker "mariadb" e depois clico na etiqueta "latest".
{{< gallery match="images/2/*.png" >}}
Após o download da imagem, a imagem está disponível como imagem. Docker distingue entre 2 estados, recipiente "estado dinâmico" e imagem (estado fixo). Antes de criarmos um recipiente a partir da imagem, algumas configurações têm de ser feitas. Eu faço duplo clique na minha imagem mariadb.
{{< gallery match="images/3/*.png" >}}
Depois clico em "Definições avançadas" e activo o "Reinício automático". Eu seleciono o separador "Volume" e clico em "Adicionar pasta". Lá eu crio uma nova pasta de banco de dados com este caminho de montagem "/var/lib/mysql".
{{< gallery match="images/4/*.png" >}}
Em "Port settings", todas as portas são apagadas. Isto significa que seleciono a porta "3306" e a apago com o botão "-".
{{< gallery match="images/5/*.png" >}}
{{<table "table table-striped table-bordered">}}
|Nome da variável|Valor|O que é isso?|
|--- | --- |---|
|TZ| Europe/Berlin	|Fuso horário|
|MYSQL_ROOT_PASSWORD	 | wallaroot |Senha principal da base de dados.|
{{</table>}}
Finalmente, eu entro nestas variáveis de ambiente:Veja:
{{< gallery match="images/6/*.png" >}}
Após estas configurações, o servidor Mariadb pode ser iniciado! Eu carrego em "Aplicar" em todo o lado.
{{< gallery match="images/7/*.png" >}}

## Passo 3: Instalar o Wallabag
Clico na guia "Registration" na janela do Synology Docker e procuro por "wallabag". Selecciono a imagem do Docker "wallabag/wallabag" e depois clico na etiqueta "latest".
{{< gallery match="images/8/*.png" >}}
Faço duplo clique na imagem do meu saco de parede. Depois clique em "Configurações avançadas" e ative o "Reinício automático" aqui também.
{{< gallery match="images/9/*.png" >}}
Selecciono o separador "Volume" e clico em "Adicionar Pasta". Lá eu crio uma nova pasta com este caminho de montagem "/var/wwww/wallabag/web/assets/images".
{{< gallery match="images/10/*.png" >}}
Eu atribuo portos fixos para o contentor "wallabag". Sem portas fixas, poderia ser que o "servidor wallabag" funcione em uma porta diferente após um reinício. O primeiro porto de contentores pode ser apagado. O outro porto deve ser lembrado.
{{< gallery match="images/11/*.png" >}}
Além disso, ainda é necessário criar uma "ligação" com o contentor "mariadb". Clico no separador "Links" e selecciono o contentor da base de dados. O nome falso deve ser lembrado para a instalação do saco de parede.
{{< gallery match="images/12/*.png" >}}
{{<table "table table-striped table-bordered">}}
|Umgebungsvariable	|Valor|
|--- |---|
|MYSQL_ROOT_PASSWORD	|wallaroot|
|SYMFONY__ENV__DATABASE_DRIVER	|pdo_mysql|
|SYMFONY__ENV__DATABASE_HOST	|db|
|SYMFONY__ENV__DATABASE_PORT	|3306|
|SYMFONY__ENV__DATABASE_NAME	|saco de parede|
|SYMFONY__ENV__DATABASE_USER	|saco de parede|
|SYMFONY__ENV__DATABASE_PASSWORD	|passe de parede|
|SYMFONY__ENV__DATABASE_CHARSET |utf8mb4|
|SYMFONY__ENV__DOMAIN_NAME	|"http://synology-ip:container-port" <- Por favor mude|
|SYMFONY__ENV__SERVER_NAME	|"Wallabag - Servidor"|
|SYMFONY__ENV__FOSUSER_CONFIRMATION	|falso|
|SYMFONY__ENV__TWOFACTOR_AUTH	|falso|
{{</table>}}
Finalmente, eu entro nestas variáveis de ambiente:Veja:
{{< gallery match="images/13/*.png" >}}
O contentor pode agora ser iniciado. Pode demorar algum tempo a criar a base de dados. O comportamento pode ser observado através dos detalhes do recipiente.
{{< gallery match="images/14/*.png" >}}
Eu chamo o servidor wallabag com o endereço IP da Synology e minha porta de contêineres.
{{< gallery match="images/15/*.png" >}}
Devo dizer, no entanto, que pessoalmente prefiro shiori como um arquivo da internet.
