+++
date = "2020-02-27"
title = "Coisas ótimas com containers: Executando o download do Youtube no Synology Diskstation"
difficulty = "level-1"
tags = ["Docker", "docker-compose", "download", "linux", "Synology", "video", "youtube"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2020/february/20200227-docker-youtube-dl/index.pt.md"
+++
Muitos dos meus amigos sabem que eu dirijo um portal de vídeo de aprendizagem privado no meu Homelab - Network. Eu salvei cursos em vídeo de adesões a portais de aprendizagem anteriores e bons tutoriais do Youtube para uso offline no meu NAS.
{{< gallery match="images/1/*.png" >}}
Ao longo do tempo coletei 8845 cursos de vídeo com 282616 vídeos individuais. O tempo total de funcionamento equivale a cerca de 2 anos. Absolutamente louco! Neste tutorial eu mostro como fazer backup de bons tutoriais do Youtube com um serviço de download do Docker para fins offline.
## Opção para profissionais
Como um usuário experiente de Synology, é claro que você pode fazer login com SSH e instalar toda a configuração via arquivo Docker Compose.
```
version: "2"
services:
  youtube-dl:
    image: modenaf360/youtube-dl-nas
    container_name: youtube-dl
    environment:
      - MY_ID=admin
      - MY_PW=admin
    volumes:
      - ./YouTube:/downfolder
    ports:
      - 8080:8080
    restart: unless-stopped

```

## Passo 1
Primeiro eu crio uma pasta para os downloads. Vou para "System Control" -> "Shared Folder" e crio uma nova pasta chamada "Downloads".
{{< gallery match="images/2/*.png" >}}

## Passo 2: Procura da imagem do Docker
Clico na guia "Registration" na janela do Synology Docker e procuro por "youtube-dl-nas". Selecciono a imagem do Docker "modenaf360/youtube-dl-nas" e depois clico na etiqueta "latest".
{{< gallery match="images/3/*.png" >}}
Após o download da imagem, a imagem está disponível como imagem. Docker distingue entre 2 estados, recipiente "estado dinâmico" e imagem/imagem (estado fixo). Antes de podermos criar um recipiente a partir da imagem, algumas configurações têm de ser feitas.
## Passo 3: Colocar a imagem em funcionamento:
Faço duplo clique na minha imagem do youtube-dl-nas.
{{< gallery match="images/4/*.png" >}}
Depois clico em "Definições avançadas" e activo o "Reinício automático". Selecciono o separador "Volume" e clico em "Adicionar pasta". Lá eu crio uma nova pasta de banco de dados com este caminho de montagem "/downfolder".
{{< gallery match="images/5/*.png" >}}
Atribuo portos fixos para o contentor "Youtube Downloader". Sem portas fixas, poderia ser que o "Youtube Downloader" funcione em uma porta diferente após um reinício.
{{< gallery match="images/6/*.png" >}}
Finalmente, introduzo duas variáveis de ambiente. A variável "MY_ID" é o meu nome de utilizador e "MY_PW" é a minha palavra-passe.
{{< gallery match="images/7/*.png" >}}
Após estas configurações, o Downloader pode ser iniciado! Em seguida, você pode chamar o downloader através do endereço Ip do disco Synology e da porta atribuída, por exemplo http://192.168.21.23:8070 .
{{< gallery match="images/8/*.png" >}}
Para autenticação, pegue o nome de usuário e senha de MY_ID e MY_PW.
## Passo 4: Vamos
Agora as urls de vídeo e lista de reprodução do Youtube podem ser inseridas no campo "URL" e todos os vídeos acabam automaticamente na pasta de download da estação de disco Synology.
{{< gallery match="images/9/*.png" >}}
Descarregar pasta:
{{< gallery match="images/10/*.png" >}}
