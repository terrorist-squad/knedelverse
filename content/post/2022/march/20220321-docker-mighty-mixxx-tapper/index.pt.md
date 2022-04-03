+++
date = "2022-03-21"
title = "Grandes coisas com contentores: Gravação de MP3 a partir do rádio"
difficulty = "level-1"
tags = ["diskstation", "Docker", "docker-compose", "docker-for-desktop", "radio", "mp3", "ripp", "streamripper", "radiorecorder"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2022/march/20220321-docker-mighty-mixxx-tapper/index.pt.md"
+++
Streamripper é uma ferramenta para a linha de comando que pode ser usada para gravar streams MP3 ou OGG/Vorbis e salvá-los diretamente no disco rígido. As músicas recebem automaticamente o nome do artista e são salvas individualmente, o formato é o originalmente enviado (assim, com efeito, arquivos com a extensão .mp3 ou .ogg são criados). Encontrei uma grande interface de radiorecorder e construí uma imagem Docker a partir dela, veja: https://github.com/terrorist-squad/mightyMixxxTapper/
{{< gallery match="images/1/*.png" >}}

## Opção para profissionais
Como um usuário experiente de Synology, é claro que você pode fazer login com SSH e instalar toda a configuração via arquivo Docker Compose.
```
version: "2.0"
services:
  mealie:
    container_name: mighty-mixxx-tapper
    image: chrisknedel/mighty-mixxx-tapper:latest
    restart: always
    ports:
      - 9000:80
    environment:
      TZ: Europa/Berlin
    volumes:
      - ./ripps/:/tmp/ripps/

```

## Passo 1: Procura da imagem do Docker
Clico na guia "Registration" na janela Synology Docker e procuro por "mighty-mixxx-tapper". Selecciono a imagem do Docker "chrisknedel/mighty-mixxx-tapper" e depois clico na etiqueta "latest".
{{< gallery match="images/2/*.png" >}}
Após o download da imagem, a imagem está disponível como imagem. Docker distingue entre 2 estados, recipiente "estado dinâmico" e imagem/imagem (estado fixo). Antes de podermos criar um recipiente a partir da imagem, algumas configurações têm de ser feitas.
## Passo 2: Colocar a imagem em funcionamento:
Clico duas vezes na minha imagem de "poderoso mix de tatuagens".
{{< gallery match="images/3/*.png" >}}
Depois clico em "Definições avançadas" e activo o "Reinício automático". Eu seleciono o separador "Volume" e clico em "Adicionar pasta". Lá eu crio uma nova pasta com este caminho de montagem "/tmp/ripps/".
{{< gallery match="images/4/*.png" >}}
Atribuo portos fixos para o contentor "mighty-mixxx-tapper". Sem portas fixas, pode ser que o "mighty-mixxx-tapper-server" funcione em uma porta diferente após um reinício.
{{< gallery match="images/5/*.png" >}}
Depois destas configurações, o poderoso servidor-misturador-tapper-server pode ser iniciado! Depois disso, você pode chamar o mighty-mixxx-tapper através do endereço Ip do disco de Synology e da porta atribuída, por exemplo http://192.168.21.23:8097.
{{< gallery match="images/6/*.png" >}}
