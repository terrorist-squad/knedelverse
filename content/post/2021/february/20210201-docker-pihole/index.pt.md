+++
date = "2021-02-01"
title = "Grandes coisas com recipientes: Pihole on the Synology Diskstation"
difficulty = "level-3"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "dns", "adblocker", "fritzbox"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/february/20210201-docker-pihole/index.pt.md"
+++
Hoje eu mostro como instalar um serviço Pihole na estação de disco Synology e conectá-lo ao Fritzbox.
## Passo 1: Preparar a Sinologia
Primeiro, o login do SSH deve ser ativado no DiskStation. Para fazer isso, vá para o "Painel de Controle" > "Terminal
{{< gallery match="images/1/*.png" >}}
Então você pode entrar via "SSH", a porta especificada e a senha do administrador (usuários do Windows usam Putty ou WinSCP).
{{< gallery match="images/2/*.png" >}}
Eu inicio sessão via Terminal, winSCP ou Putty e deixo esta consola aberta para mais tarde.
## Passo 2: Criar pasta Pihole
Eu crio um novo diretório chamado "pihole" no diretório Docker.
{{< gallery match="images/3/*.png" >}}
Depois mudo para o novo directório e crio duas pastas "etc-pihole" e "etc-dnsmasq.d":
{{< terminal >}}
cd /volume1/docker/
mkdir -p {etc-pihole,etc-dnsmasq.d}

{{</ terminal >}}
Agora o seguinte arquivo Docker Compose chamado "pihole.yml" deve ser colocado no diretório Pihole:
```
version: "3"

services:
  pihole:
    container_name: pihole
    image: pihole/pihole:latest
    ports:
      - "53:53/tcp"
      - "53:53/udp"
      - "67:67/udp"
      - "8080:80/tcp"
    environment:
      TZ: 'Europe/Berlin'
      WEBPASSWORD: 'password'
    volumes:
      - './etc-pihole/:/etc/pihole/'
      - './etc-dnsmasq.d/:/etc/dnsmasq.d/'
    cap_add:
      - NET_ADMIN
    restart: unless-stopped

```
O contentor pode agora ser iniciado:
{{< terminal >}}
sudo docker-compose up -d

{{</ terminal >}}
Chamo o servidor Pihole com o endereço IP de Synology e minha porta de contêiner e faço login com a senha WEBPASSWORD.
{{< gallery match="images/4/*.png" >}}
Agora o endereço DNS pode ser alterado no Fritzbox em "Home Network" > "Network" > "Network Settings".
{{< gallery match="images/5/*.png" >}}
