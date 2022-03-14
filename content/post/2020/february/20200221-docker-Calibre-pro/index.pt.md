+++
date = "2020-02-21"
title = "Coisas fantásticas com contentores: Calibre de funcionamento com Docker Compose (Synology pro setup)"
difficulty = "level-3"
tags = ["calibre", "calibre-web", "Docker", "docker-compose", "Synology", "linux"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2020/february/20200221-docker-Calibre-pro/index.pt.md"
+++
Já existe um tutorial mais fácil neste blog: [Synology-Nas: Instale o Calibre Web como uma biblioteca de livros eletrônicos]({{< ref "post/2020/february/20200213-synology-calibreweb" >}} "Synology-Nas: Instale o Calibre Web como uma biblioteca de livros eletrônicos"). Este tutorial é para todos os profissionais da Synology DS.
## Passo 1: Preparar a Sinologia
Primeiro, o login SSH deve ser ativado no DiskStation. Para fazer isso, vá para o "Painel de Controle" > "Terminal
{{< gallery match="images/1/*.png" >}}
Então você pode entrar via "SSH", a porta especificada e a senha do administrador (usuários do Windows usam Putty ou WinSCP).
{{< gallery match="images/2/*.png" >}}
Eu inicio sessão via Terminal, winSCP ou Putty e deixo este console aberto para mais tarde.
## Passo 2: Criar uma pasta de livros
Eu crio uma nova pasta para a biblioteca Calibre. Para fazer isso, chamo "System Control" -> "Shared Folder" e crio uma nova pasta chamada "Books". Se ainda não existe uma pasta "Docker", então esta também deve ser criada.
{{< gallery match="images/3/*.png" >}}

## Passo 3: Preparar pasta de livros
Agora o seguinte arquivo deve ser baixado e descompactado: https://drive.google.com/file/d/1zfeU7Jh3FO_jFlWSuZcZQfQOGD0NvXBm/view. O conteúdo ("metadata.db") deve ser colocado no novo diretório de livros, veja:
{{< gallery match="images/4/*.png" >}}

## Passo 4: Preparar pasta Docker
Eu crio um novo diretório chamado "calibre" no diretório Docker:
{{< gallery match="images/5/*.png" >}}
Então eu mudo para o novo diretório e crio um novo arquivo chamado "calibre.yml" com o seguinte conteúdo:
```
version: '2'
services:
  calibre-web:
    image: linuxserver/calibre-web
    container_name: calibre-web-server
    environment:
      - PUID=1026
      - PGID=100
      - TZ=Europe/Berlin
    volumes:
      - /volume1/Buecher:/books
      - /volume1/docker/calibre:/briefkaste
    ports:
      - 8055:8083
    restart: unless-stopped

```
Neste novo arquivo, vários lugares devem ser ajustados da seguinte forma:* PUID/PGID: O ID de usuário e grupo do usuário DS deve ser inserido em PUID/PGID. Aqui eu uso o console do "Passo 1" e os comandos "id -u" para ver o ID do usuário. Com o comando "id -g" obtenho o ID do grupo.* portas: Para a porta, a parte frontal "8055:" deve ser ajustada.directoriasTodos os directórios neste ficheiro devem ser corrigidos. Os endereços correctos podem ser vistos na janela de propriedades da DS. (Segue-se uma captura de ecrã)
{{< gallery match="images/6/*.png" >}}

## Passo 5: Início do teste
Eu também posso fazer bom uso do console neste passo. Eu mudo para o diretório Calibre e inicio o servidor Calibre lá através do Docker Compose.
{{< terminal >}}
cd /volume1/docker/calibre
sudo docker-compose -f calibre.yml up -d

{{</ terminal >}}

{{< gallery match="images/7/*.png" >}}

## Passo 6: Configuração
Então eu posso chamar o meu servidor Calibre com o IP da estação de disco e a porta atribuída a partir do "Passo 4". Eu uso o meu ponto de montagem "/books" na configuração. Depois disso, o servidor já está utilizável.
{{< gallery match="images/8/*.png" >}}

## Passo 7: Finalização da configuração
O console também é necessário nesta etapa. Eu uso o comando "exec" para salvar a base de dados da aplicação interna do container.
{{< terminal >}}
sudo docker exec -it calibre-web-server cp /app/calibre-web/app.db /briefkaste/app.db

{{</ terminal >}}
Depois disso eu vejo um novo arquivo "app.db" no diretório Calibre:
{{< gallery match="images/9/*.png" >}}
Então paro o servidor Calibre:
{{< terminal >}}
sudo docker-compose -f calibre.yml down

{{</ terminal >}}
Agora eu mudo o caminho da caixa postal e persisto na base de dados da aplicação sobre ela.
```
version: '2'
services:
  calibre-web:
    image: linuxserver/calibre-web
    container_name: calibre-web-server
    environment:
      - PUID=1026
      - PGID=100
      - TZ=Europe/Berlin
    volumes:
      - /volume1/Buecher:/books
      - /volume1/docker/calibre/app.db:/app/calibre-web/app.db
    ports:
      - 8055:8083
    restart: unless-stopped

```
Depois disso, o servidor pode ser reiniciado:
{{< terminal >}}
sudo docker-compose -f calibre.yml up -d

{{</ terminal >}}