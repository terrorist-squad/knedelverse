+++
date = "2021-04-25T09:28:11+01:00"
title = "Grandes coisas com recipientes: Portainer como alternativa ao Synology Docker GUI"
difficulty = "level-3"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "watchtower"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210425-docker-Portainer/index.pt.md"
+++

## Passo 1: Preparar a Sinologia
Primeiro, o login SSH deve ser ativado no DiskStation. Para fazer isso, vá para o "Painel de Controle" > "Terminal
{{< gallery match="images/1/*.png" >}}
Então você pode entrar via "SSH", a porta especificada e a senha do administrador (usuários do Windows usam Putty ou WinSCP).
{{< gallery match="images/2/*.png" >}}
Eu inicio sessão via Terminal, winSCP ou Putty e deixo este console aberto para mais tarde.
## Passo 2: Criar pasta de portainer
Eu crio um novo diretório chamado "portainer" no diretório Docker.
{{< gallery match="images/3/*.png" >}}
Então eu vou para o diretório portainer com o console e crio uma pasta e um novo arquivo chamado "portainer.yml" lá.
{{< terminal >}}
cd /volume1/docker/portainer
mkdir portainer_data
vim portainer.yml

{{</ terminal >}}
Aqui está o conteúdo do arquivo "portainer.yml":
```
version: '3'

services:
  portainer:
    image: portainer/portainer:latest
    container_name: portainer
    restart: always
    ports:
      - 90070:9000
      - 9090:8000
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - ./portainer_data:/data

```
Imagens mais úteis do Docker para uso doméstico podem ser encontradas no [Dockerverse]({{< ref "dockerverse" >}} "Dockerverse").
## Passo 3: Início do Portainer
Eu também posso fazer bom uso do console neste passo. Eu inicio o servidor do portainer através do Docker Compose.
{{< terminal >}}
sudo docker-compose -f portainer.yml up -d

{{</ terminal >}}
Então eu posso chamar meu servidor Portainer com o IP da estação de disco e a porta atribuída a partir do "Passo 2". Eu digito minha senha de administrador e seleciono a variante local.
{{< gallery match="images/4/*.png" >}}
Como você pode ver, tudo funciona muito bem!
{{< gallery match="images/5/*.png" >}}