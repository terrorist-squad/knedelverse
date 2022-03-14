+++
date = "2021-03-21"
title = "Grandes coisas com recipientes: Executando Jenkins sobre a Synology DS"
difficulty = "level-3"
tags = ["build", "devops", "diskstation", "java", "javascript", "Jenkins", "nas", "Synology"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/march/20210321-docker-jenkins/index.pt.md"
+++

## Passo 1: Preparar a Sinologia
Primeiro, o login SSH deve ser ativado no DiskStation. Para fazer isso, vá para o "Painel de Controle" > "Terminal
{{< gallery match="images/1/*.png" >}}
Então você pode entrar via "SSH", a porta especificada e a senha do administrador (usuários do Windows usam Putty ou WinSCP).
{{< gallery match="images/2/*.png" >}}
Eu inicio sessão via Terminal, winSCP ou Putty e deixo este console aberto para mais tarde.
## Passo 2: Preparar pasta Docker
Eu crio um novo diretório chamado "jenkins" no diretório Docker.
{{< gallery match="images/3/*.png" >}}
Depois mudo para o novo diretório e crio uma nova pasta "data":
{{< terminal >}}
sudo mkdir data

{{</ terminal >}}
Também crio um arquivo chamado "jenkins.yml" com o seguinte conteúdo. A parte da frente da porta "8081:" pode ser ajustada.
```
version: '2.0'
services:
  jenkins:
    restart: always
    image: jenkins/jenkins:lts
    privileged: true
    user: root
    ports:
      - 8081:8080
    container_name: jenkins
    volumes:
      - ./data:/var/jenkins_home
      - /var/run/docker.sock:/var/run/docker.sock
      - /usr/local/bin/docker:/usr/local/bin/docker

```

## Passo 3: Início
Eu também posso fazer bom uso do console neste passo. Eu inicio o servidor Jenkins através do Docker Compose.
{{< terminal >}}
sudo docker-compose -f jenkins.yml up -d

{{</ terminal >}}
Depois disso, eu posso chamar meu servidor Jenkins com o IP da estação de disco e a porta atribuída a partir do "Passo 2".
{{< gallery match="images/4/*.png" >}}

## Passo 4: Configuração

{{< gallery match="images/5/*.png" >}}
Mais uma vez, eu uso o console para ler a senha inicial:
{{< terminal >}}
cat data/secrets/initialAdminPassword

{{</ terminal >}}
Veja:
{{< gallery match="images/6/*.png" >}}
Eu selecionei a "Instalação recomendada".
{{< gallery match="images/7/*.png" >}}

## Passo 5: O meu primeiro emprego
Eu inicio sessão e crio o meu trabalho no Docker.
{{< gallery match="images/8/*.png" >}}
Como você pode ver, tudo funciona muito bem!
{{< gallery match="images/9/*.png" >}}