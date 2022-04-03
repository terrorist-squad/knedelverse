+++
date = "2021-04-17"
title = "Coisas ótimas com containers: Executando seu próprio xWiki na estação de disco Synology"
difficulty = "level-1"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "xwiki", "wiki",]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210417-docker-xWiki/index.pt.md"
+++
XWiki é uma plataforma de software wiki gratuita escrita em Java e desenhada com extensibilidade em mente. Hoje eu mostro como instalar um serviço xWiki no Synology DiskStation.
## Opção para profissionais
Como um usuário experiente de Synology, é claro que você pode fazer login com SSH e instalar toda a configuração via arquivo Docker Compose.
```
version: '3'
services:
  xwiki:
    image: xwiki:10-postgres-tomcat
    restart: always
    ports:
      - 8080:8080
    links:
      - db
    environment:
      DB_HOST: db
      DB_DATABASE: xwiki
      DB_DATABASE: xwiki
      DB_PASSWORD: xwiki
      TZ: 'Europe/Berlin'

  db:
    image: postgres:latest
    restart: always
    volumes:
      - ./postgresql:/var/lib/postgresql/data
    environment:
      - POSTGRES_USER=xwiki
      - POSTGRES_PASSWORD=xwiki
      - POSTGRES_DB=xwiki
      - TZ='Europe/Berlin'

```
Imagens mais úteis do Docker para uso doméstico podem ser encontradas no [Dockerverse]({{< ref "dockerverse" >}} "Dockerverse").
## Passo 1: Prepare a pasta wiki
Eu crio um novo diretório chamado "wiki" no diretório Docker.
{{< gallery match="images/1/*.png" >}}

## Passo 2: Instalar base de dados
Depois disso, tem de ser criada uma base de dados. Clico na guia "Registration" na janela do Synology Docker e procuro por "postgres". Selecciono a imagem do Docker "postgres" e depois clico na etiqueta "latest".
{{< gallery match="images/2/*.png" >}}
Após o download da imagem, a imagem está disponível como imagem. Docker distingue entre 2 estados, recipiente "estado dinâmico" e imagem (estado fixo). Antes de criarmos um recipiente a partir da imagem, algumas configurações têm de ser feitas. Faço duplo clique na minha imagem postgres.
{{< gallery match="images/3/*.png" >}}
Depois clico em "Definições avançadas" e activo o "Reinício automático". Selecciono o separador "Volume" e clico em "Adicionar pasta". Lá eu crio uma nova pasta de base de dados com este caminho de montagem "/var/lib/postgresql/data".
{{< gallery match="images/4/*.png" >}}
Em "Port settings", todas as portas são apagadas. Isto significa que eu selecciono a porta "5432" e apago com o botão "-".
{{< gallery match="images/5/*.png" >}}
{{<table "table table-striped table-bordered">}}
|Nome da variável|Valor|O que é isso?|
|--- | --- |---|
|TZ	| Europe/Berlin	|Fuso horário|
|POSTGRES_DB	| xwiki |Este é o nome da base de dados.|
|POSTGRES_USER	| xwiki |Nome do usuário da base de dados wiki.|
|POSTGRES_PASSWORD	| xwiki |Senha do usuário da base de dados wiki.|
{{</table>}}
Finalmente, introduzo estas quatro variáveis de ambiente:Veja:
{{< gallery match="images/6/*.png" >}}
Após estas configurações, o servidor Mariadb pode ser iniciado! Eu carrego em "Aplicar" em todo o lado.
## Passo 3: Instalar o xWiki
Clico na guia "Registration" na janela do Synology Docker e procuro por "xwiki". Selecciono a imagem do Docker "xwiki" e depois clico na etiqueta "10-postgres-tomcat".
{{< gallery match="images/7/*.png" >}}
Eu faço duplo clique na minha imagem xwiki. Depois clique em "Configurações avançadas" e ative o "Reinício automático" aqui também.
{{< gallery match="images/8/*.png" >}}
Eu atribuo portos fixos para o contentor "xwiki". Sem portas fixas, poderia ser que o "xwiki server" funcione em uma porta diferente após um reinício.
{{< gallery match="images/9/*.png" >}}
Além disso, deve ser criado um "link" para o recipiente "postgres". Clico no separador "Links" e selecciono o contentor da base de dados. O nome falso deve ser lembrado para a instalação do wiki.
{{< gallery match="images/10/*.png" >}}
{{<table "table table-striped table-bordered">}}
|Nome da variável|Valor|O que é isso?|
|--- | --- |---|
|TZ |	Europe/Berlin	|Fuso horário|
|DB_HOST	| db |Nomes de pseudônimos / link do container|
|DB_DATABASE	| xwiki	|Dados da etapa 2|
|DB_USER	| xwiki	|Dados da etapa 2|
|DB_PASSWORD	| xwiki |Dados da etapa 2|
{{</table>}}
Finalmente, eu entro nestas variáveis de ambiente:Veja:
{{< gallery match="images/11/*.png" >}}
O contentor pode agora ser iniciado. Eu chamo o servidor xWiki com o endereço IP Synology e minha porta de contêiner.
{{< gallery match="images/12/*.png" >}}
