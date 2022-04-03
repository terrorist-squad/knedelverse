+++
date = "2021-05-30"
title = "Založení vlastní stránky Darknetu"
difficulty = "level-3"
tags = ["darknet", "tor", "website", "hosting", "hidden"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/may/20210530-darknet-tor-site/index.cs.md"
+++
Surfování v Darknetu je jako pro návštěvníky poměrně jednoduché. Jak ale mohu hostovat stránku Onion? Ukážu vám, jak si založit vlastní stránku Darknetu.
## Krok 1: Jak mohu surfovat na Darknetu?
Pro lepší ilustraci používám desktop Ubuntu. Tam nainstaluji následující balíčky:
{{< terminal >}}
sudo apt-get update
sudo apt-get install tor 

{{</ terminal >}}
Pak upravím soubor "/etc/privoxy/config" a zadám následující ($ sudo vim /etc/privoxy/config). IP adresu počítače můžete zjistit pomocí příkazu "ifconfig".
```
listen-address hier-muss-die-ip-des-rechners-rein:8118
forward-socks5 / 127.0.0.1:9050 .

```
Viz:
{{< gallery match="images/1/*.png" >}}
Abychom zajistili, že se Tor a Privoxy spustí také při startu systému, musíme je ještě zadat do autostartu:
{{< terminal >}}
sudo update-rc.d tor defaults
sudo update-rc.d privoxy defaults

{{</ terminal >}}
Nyní lze služby spustit:
{{< terminal >}}
sudo service tor restart
sudo service privoxy restart

{{</ terminal >}}
Zadám adresu proxy serveru do Firefoxu, deaktivuji "Javascript" a navštívím "testovací stránku Tor". Pokud vše fungovalo, mohu nyní navštěvovat stránky TOR/.Onion.
{{< gallery match="images/2/*.png" >}}

## Krok 2: Jak mohu hostovat stránky Darknetu?
Nejprve nainstaluji server HTTP:
{{< terminal >}}
sudo apt-get install nginx

{{</ terminal >}}
Pak změním konfiguraci NGINX (vim /etc/nginx/nginx.conf) a tyto funkce vypnu:
```
server_tokens off;
port_in_redirect off;
server_name_in_redirect off;

```
Viz:
{{< gallery match="images/3/*.png" >}}
Nyní je třeba server NGINX znovu restartovat:
{{< terminal >}}
sudo service nginx restart

{{</ terminal >}}
Změna musí být provedena také v konfiguraci Tor. V souboru "/etc/tor/torrc" jsem zakomentoval následující řádky "HiddenServiceDir" a "HiddenServicePort".
{{< gallery match="images/4/*.png" >}}
Poté tuto službu také restartuji:
{{< terminal >}}
sudo service tor restart

{{</ terminal >}}

## Připraveno
Pod položkou "/var/lib/tor/hidden_servic/hostname" najdu svou adresu Darknet/Onion. Nyní je veškerý obsah v adresáři /var/www/html dostupný v Darkentu.
{{< gallery match="images/5/*.png" >}}
