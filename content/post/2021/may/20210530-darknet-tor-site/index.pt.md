+++
date = "2021-05-30"
title = "Configure a sua própria página Darknet"
difficulty = "level-3"
tags = ["darknet", "tor", "website", "hosting", "hidden"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/may/20210530-darknet-tor-site/index.pt.md"
+++
Navegar no Darknet como visitante é bastante simples. Mas como posso hospedar uma página de cebola? Vou mostrar-te como criar a tua própria página Darknet.
## Passo 1: Como eu posso surfar no Darknet?
Eu uso um desktop Ubuntu para melhor ilustração. Lá eu instalo os seguintes pacotes:
{{< terminal >}}
sudo apt-get update
sudo apt-get install tor 

{{</ terminal >}}
Depois edito o ficheiro "/etc/privoxy/config" e introduzo o seguinte ($ sudo vim /etc/privoxy/config). Você pode descobrir o IP do computador com "ifconfig".
```
listen-address hier-muss-die-ip-des-rechners-rein:8118
forward-socks5 / 127.0.0.1:9050 .

```
Veja:
{{< gallery match="images/1/*.png" >}}
Para garantir que o Tor e o Privoxy também sejam executados na inicialização do sistema, ainda temos que inseri-los no autostart:
{{< terminal >}}
sudo update-rc.d tor defaults
sudo update-rc.d privoxy defaults

{{</ terminal >}}
Agora os serviços podem ser iniciados:
{{< terminal >}}
sudo service tor restart
sudo service privoxy restart

{{</ terminal >}}
Introduzo o endereço proxy no meu Firefox, desactivo o "Javascript" e visito a "página de teste do Tor". Se tudo funcionou, posso agora visitar os TOR/.Onion sites.
{{< gallery match="images/2/*.png" >}}

## Passo 2: Como posso hospedar o site da Darknet?
Primeiro, eu instalo um servidor HTTP:
{{< terminal >}}
sudo apt-get install nginx

{{</ terminal >}}
Depois mudo a configuração do NGINX (vim /etc/nginx/nginx.conf) e desligo estas funcionalidades:
```
server_tokens off;
port_in_redirect off;
server_name_in_redirect off;

```
Veja:
{{< gallery match="images/3/*.png" >}}
O servidor NGINX deve agora ser reiniciado novamente:
{{< terminal >}}
sudo service nginx restart

{{</ terminal >}}
Também deve ser feita uma alteração na configuração do Tor. Eu comento as seguintes linhas "HiddenServiceDir" e "HiddenServicePort" no arquivo "/etc/tor/torrc".
{{< gallery match="images/4/*.png" >}}
Depois disso, eu também reinicio este serviço:
{{< terminal >}}
sudo service tor restart

{{</ terminal >}}

## Pronto
Em "/var/lib/tor/hidden_servic/hostname" encontro o meu endereço Darknet/Onion. Agora todos os conteúdos em /var/wwww/html estão disponíveis no Darkent.
{{< gallery match="images/5/*.png" >}}