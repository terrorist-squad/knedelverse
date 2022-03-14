+++
date = "2020-02-28"
title = "Coisas ótimas com containers: Executando Papermerge DMS em um NAS Synology"
difficulty = "level-3"
tags = ["archiv", "automatisch", "dms", "Docker", "Document-Managment-System", "google", "ocr", "papermerge", "Synology", "tesseract", "texterkennung"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2020/february/20200228-docker-papermerge/index.pt.md"
+++
Papermerge é um jovem sistema de gestão de documentos (DMS) que pode atribuir e processar documentos automaticamente. Neste tutorial eu mostro como instalei o Papermerge em minha estação de disco Synology e como o DMS funciona.
## Opção para profissionais
Como um usuário experiente de Synology, é claro que você pode fazer login com SSH e instalar toda a configuração via arquivo Docker Compose.
```
version: "2.1"
services:
  papermerge:
    image: ghcr.io/linuxserver/papermerge
    container_name: papermerge
    environment:
      - PUID=1024
      - PGID=100
      - TZ=Europe/Berlin
    volumes:
      - ./config>:/config
      - ./appdata/data>:/data
    ports:
      - 8090:8000
    restart: unless-stopped

```

## Passo 1: Criar pasta
Primeiro eu crio uma pasta para a fusão do papel. Eu vou para "System Control" -> "Shared Folder" e crio uma nova pasta chamada "Document Archive".
{{< gallery match="images/1/*.png" >}}
Passo 2: Procure por imagem DockerI clique na guia "Registration" (Registro) na janela Synology Docker e procure por "Papermerge". Selecciono a imagem do Docker "linuxserver/papermerge" e depois clico na etiqueta "latest".
{{< gallery match="images/2/*.png" >}}
Após o download da imagem, a imagem está disponível como imagem. Docker distingue entre 2 estados, recipiente "estado dinâmico" e imagem/imagem (estado fixo). Antes de podermos criar um recipiente a partir da imagem, algumas configurações têm de ser feitas.
## Passo 3: Colocar a imagem em funcionamento:
Faço duplo clique na minha imagem de fusão de papel.
{{< gallery match="images/3/*.png" >}}
Depois clico em "Definições avançadas" e activo o "Reinício automático". Selecciono o separador "Volume" e clico em "Adicionar pasta". Lá eu crio uma nova pasta de banco de dados com este caminho de montagem "/dados".
{{< gallery match="images/4/*.png" >}}
Também guardo aqui uma segunda pasta que incluo com o caminho de montagem "/config". Não importa realmente onde esta pasta está. No entanto, é importante que ele pertença ao usuário administrador da Synology.
{{< gallery match="images/5/*.png" >}}
Eu atribuo portos fixos para o contentor "Papermerge". Sem portas fixas, poderia ser que o "Papermerge server" funcione em uma porta diferente após um reinício.
{{< gallery match="images/6/*.png" >}}
Finalmente, introduzo três variáveis de ambiente. A variável "PUID" é o ID do usuário e "PGID" é o ID do grupo do meu usuário administrador. Você pode encontrar o PGID/PUID via SSH com o comando "cat /etc/passwd | grep admin".
{{< gallery match="images/7/*.png" >}}
Após estas configurações, o servidor Papermerge pode ser iniciado! Em seguida, Papermerge pode ser chamado através do endereço Ip do disco de Synology e da porta atribuída, por exemplo http://192.168.21.23:8095.
{{< gallery match="images/8/*.png" >}}
O login padrão é admin com senha admin.
## Como funciona o Papermerge?
Papermerge analisa o texto de documentos e imagens. Papermerge utiliza uma biblioteca de OCR/"optical character recognition" chamada tesseract, publicada pela Goolge.
{{< gallery match="images/9/*.png" >}}
Eu criei uma pasta chamada "Tudo com Lorem" para testar a atribuição automática de documentos. Depois cliquei num novo padrão de reconhecimento no item de menu "Automatismos".
{{< gallery match="images/10/*.png" >}}
Todos os novos documentos contendo a palavra "Lorem" são colocados na pasta "Tudo com Lorem" e marcados com "has-lorem". É importante usar uma vírgula nas etiquetas, caso contrário, a etiqueta não será definida. Se você carregar um documento correspondente, ele será etiquetado e classificado.
{{< gallery match="images/11/*.png" >}}