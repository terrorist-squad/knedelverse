+++
date = "2021-05-30"
title = "Založenie vlastnej stránky Darknetu"
difficulty = "level-3"
tags = ["darknet", "tor", "website", "hosting", "hidden"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/may/20210530-darknet-tor-site/index.sk.md"
+++
Surfovanie v Darknete je ako návštevník pomerne jednoduché. Ako však môžem hostiť stránku Onion? Ukážem vám, ako si vytvoriť vlastnú stránku Darknetu.
## Krok 1: Ako môžem surfovať v Darknete?
Pre lepšiu ilustráciu používam pracovnú plochu Ubuntu. Tam nainštalujem nasledujúce balíky:
{{< terminal >}}
sudo apt-get update
sudo apt-get install tor 

{{</ terminal >}}
Potom upravím súbor "/etc/privoxy/config" a zadám nasledujúce ($ sudo vim /etc/privoxy/config). IP adresu počítača môžete zistiť pomocou príkazu "ifconfig".
```
listen-address hier-muss-die-ip-des-rechners-rein:8118
forward-socks5 / 127.0.0.1:9050 .

```
Pozri:
{{< gallery match="images/1/*.png" >}}
Aby sme zabezpečili, že sa Tor a Privoxy spustia aj pri štarte systému, musíme ich ešte zadať do autostartu:
{{< terminal >}}
sudo update-rc.d tor defaults
sudo update-rc.d privoxy defaults

{{</ terminal >}}
Teraz je možné spustiť služby:
{{< terminal >}}
sudo service tor restart
sudo service privoxy restart

{{</ terminal >}}
Zadám adresu proxy servera do prehliadača Firefox, deaktivujem "Javascript" a navštívim "testovaciu stránku Tor". Ak všetko fungovalo, môžem teraz navštíviť stránky TOR/.Onion.
{{< gallery match="images/2/*.png" >}}

## Krok 2: Ako môžem hostiť stránku Darknet?
Najprv nainštalujem server HTTP:
{{< terminal >}}
sudo apt-get install nginx

{{</ terminal >}}
Potom zmením konfiguráciu NGINX (vim /etc/nginx/nginx.conf) a vypnem tieto funkcie:
```
server_tokens off;
port_in_redirect off;
server_name_in_redirect off;

```
Pozri:
{{< gallery match="images/3/*.png" >}}
Server NGINX je teraz potrebné znova reštartovať:
{{< terminal >}}
sudo service nginx restart

{{</ terminal >}}
Zmena sa musí vykonať aj v konfigurácii Tor. V súbore "/etc/tor/torrc" som zakomentoval nasledujúce riadky "HiddenServiceDir" a "HiddenServicePort".
{{< gallery match="images/4/*.png" >}}
Potom som túto službu tiež reštartoval:
{{< terminal >}}
sudo service tor restart

{{</ terminal >}}

## Pripravené
V časti "/var/lib/tor/hidden_servic/hostname" nájdem svoju adresu Darknet/Onion. Teraz je všetok obsah pod /var/www/html dostupný v Darkent.
{{< gallery match="images/5/*.png" >}}