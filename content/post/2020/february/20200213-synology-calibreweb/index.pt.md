+++
date = "2020-02-13"
title = "Synology-Nas: Instale o Calibre Web como uma biblioteca de livros eletrônicos"
difficulty = "level-1"
tags = ["calbre-web", "calibre", "Docker", "ds918", "ebook", "epub", "nas", "pdf", "Synology"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2020/february/20200213-synology-calibreweb/index.pt.md"
+++
Como instalo o Calibre-Web como um recipiente Docker no meu Synology NAS? Atenção: Este método de instalação está desatualizado e não é compatível com o software Calibre atual. Por favor, dê uma olhada neste novo tutorial:[Grandes coisas com contentores: Calibre de funcionamento com Docker Compose]({{< ref "post/2020/february/20200221-docker-Calibre-pro" >}} "Grandes coisas com contentores: Calibre de funcionamento com Docker Compose"). Este tutorial é para todos os profissionais da Synology DS.
## Passo 1: Criar pasta
Primeiro, eu crio uma pasta para a biblioteca Calibre.  Chamo o "System control" -> "Shared folder" e crio uma nova pasta "Books".
{{< gallery match="images/1/*.png" >}}

##  Passo 2: Criar biblioteca Calibre
Agora eu copio uma biblioteca existente ou "[esta biblioteca de amostras vazias](https://drive.google.com/file/d/1zfeU7Jh3FO_jFlWSuZcZQfQOGD0NvXBm/view)" para o novo diretório. Eu mesmo copiei a biblioteca existente da aplicação desktop.
{{< gallery match="images/2/*.png" >}}

## Passo 3: Procura da imagem do Docker
Clico na guia "Registration" (Registro) na janela Synology Docker e procuro por "Calibre". Selecciono a imagem do Docker "janeczku/calibre-web" e depois clico na etiqueta "latest".
{{< gallery match="images/3/*.png" >}}
Após o download da imagem, a imagem está disponível como imagem. Docker distingue entre 2 estados, recipiente "estado dinâmico" e imagem/imagem (estado fixo). Antes de podermos criar um recipiente a partir da imagem, algumas configurações têm de ser feitas.
## Passo 4: Colocar a imagem em funcionamento:
Faço duplo clique na minha imagem Calibre.
{{< gallery match="images/4/*.png" >}}
Depois clico em "Definições avançadas" e activo o "Reinício automático". Eu seleciono o separador "Volume" e clico em "Adicionar pasta". Lá eu crio uma nova pasta de banco de dados com este caminho de montagem "/calibre".
{{< gallery match="images/5/*.png" >}}
Atribuo portos fixos para o contentor Calibre. Sem portas fixas, poderia ser que o Calibre funcione em uma porta diferente após um reinício.
{{< gallery match="images/6/*.png" >}}
Após estas configurações, o Calibre pode ser iniciado!
{{< gallery match="images/7/*.png" >}}
Agora chamo meu IP de Synology com a porta Calibre atribuída e vejo a figura a seguir. Eu digito "/calibre" como a "Localização da Base de Dados Calibre". As restantes configurações são uma questão de gosto.
{{< gallery match="images/8/*.png" >}}
O login padrão é "admin" com a senha "admin123".
{{< gallery match="images/9/*.png" >}}
Feito! É claro que agora também posso conectar a aplicação desktop através da minha "pasta de livros". Eu troco a biblioteca na minha aplicação e depois selecciono a minha pasta Nas.
{{< gallery match="images/10/*.png" >}}
Algo parecido com isto:
{{< gallery match="images/11/*.png" >}}
Se eu agora editar meta-infos na aplicação desktop, eles também são automaticamente atualizados na aplicação web.
{{< gallery match="images/12/*.png" >}}