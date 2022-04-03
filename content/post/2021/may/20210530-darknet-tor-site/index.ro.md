+++
date = "2021-05-30"
title = "Creați-vă propria pagină Darknet"
difficulty = "level-3"
tags = ["darknet", "tor", "website", "hosting", "hidden"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/may/20210530-darknet-tor-site/index.ro.md"
+++
Navigarea în Darknet ca vizitator este destul de simplă. Dar cum pot găzdui o pagină Onion? Vă voi arăta cum să vă creați propria pagină Darknet.
## Pasul 1: Cum pot naviga pe Darknet?
Folosesc un desktop Ubuntu pentru o mai bună ilustrare. Acolo instalez următoarele pachete:
{{< terminal >}}
sudo apt-get update
sudo apt-get install tor 

{{</ terminal >}}
Apoi, editez fișierul "/etc/privoxy/config" și introduc următoarele ($ sudo vim /etc/privoxy/config). Puteți afla IP-ul computerului cu "ifconfig".
```
listen-address hier-muss-die-ip-des-rechners-rein:8118
forward-socks5 / 127.0.0.1:9050 .

```
A se vedea:
{{< gallery match="images/1/*.png" >}}
Pentru a ne asigura că Tor și Privoxy sunt de asemenea executate la pornirea sistemului, trebuie să le introducem în autostart:
{{< terminal >}}
sudo update-rc.d tor defaults
sudo update-rc.d privoxy defaults

{{</ terminal >}}
Acum serviciile pot fi pornite:
{{< terminal >}}
sudo service tor restart
sudo service privoxy restart

{{</ terminal >}}
Introduc adresa proxy în Firefox, dezactivez "Javascript" și vizitez "Pagina de test Tor". Dacă totul a funcționat, acum pot vizita site-uri TOR/.Onion.
{{< gallery match="images/2/*.png" >}}

## Pasul 2: Cum pot găzdui un site Darknet?
Mai întâi, instalez un server HTTP:
{{< terminal >}}
sudo apt-get install nginx

{{</ terminal >}}
Apoi, schimb configurația NGINX (vim /etc/nginx/nginx.conf) și dezactivez aceste caracteristici:
```
server_tokens off;
port_in_redirect off;
server_name_in_redirect off;

```
A se vedea:
{{< gallery match="images/3/*.png" >}}
Serverul NGINX trebuie să fie repornit din nou:
{{< terminal >}}
sudo service nginx restart

{{</ terminal >}}
De asemenea, trebuie să se facă o modificare în configurația Tor. Comentez următoarele linii "HiddenServiceDir" și "HiddenServicePort" din fișierul "/etc/tor/torrc".
{{< gallery match="images/4/*.png" >}}
După aceea, am repornit și acest serviciu:
{{< terminal >}}
sudo service tor restart

{{</ terminal >}}

## Gata
Sub "/var/lib/tor/hidden_servic/hostname" găsesc adresa mea Darknet/Onion. Acum, tot conținutul din /var/www/html este disponibil în Darkent.
{{< gallery match="images/5/*.png" >}}
