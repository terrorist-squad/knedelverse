+++
date = "2021-05-30"
title = "Vzpostavitev lastne strani v Darknetu"
difficulty = "level-3"
tags = ["darknet", "tor", "website", "hosting", "hidden"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/may/20210530-darknet-tor-site/index.sl.md"
+++
Surfiranje po Darknetu je kot obiskovalec precej preprosto. Toda kako lahko gostim stran Onion? Pokazal vam bom, kako vzpostaviti svojo stran v Darknetu.
## Korak 1: Kako lahko brskam po Darknetu?
Za boljšo ponazoritev uporabljam namizje Ubuntu. Tam namestim naslednje pakete:
{{< terminal >}}
sudo apt-get update
sudo apt-get install tor 

{{</ terminal >}}
Nato uredim datoteko "/etc/privoxy/config" in vnesem naslednje ($ sudo vim /etc/privoxy/config). IP računalnika lahko ugotovite z ukazom "ifconfig".
```
listen-address hier-muss-die-ip-des-rechners-rein:8118
forward-socks5 / 127.0.0.1:9050 .

```
Oglejte si:
{{< gallery match="images/1/*.png" >}}
Da bi zagotovili, da se Tor in Privoxy izvajata tudi ob zagonu sistema, ju moramo še vedno vnesti v program za samodejni zagon:
{{< terminal >}}
sudo update-rc.d tor defaults
sudo update-rc.d privoxy defaults

{{</ terminal >}}
Zdaj lahko zaženete storitve:
{{< terminal >}}
sudo service tor restart
sudo service privoxy restart

{{</ terminal >}}
V brskalnik Firefox vnesem naslov posrednika, deaktiviram "Javascript" in obiščem "testno stran Tor". Če je vse delovalo, lahko zdaj obiščem spletna mesta TOR/.Onion.
{{< gallery match="images/2/*.png" >}}

## 2. korak: Kako lahko gostim spletno mesto Darknet?
Najprej namestim strežnik HTTP:
{{< terminal >}}
sudo apt-get install nginx

{{</ terminal >}}
Nato spremenim konfiguracijo NGINX (vim /etc/nginx/nginx.conf) in izklopim te funkcije:
```
server_tokens off;
port_in_redirect off;
server_name_in_redirect off;

```
Oglejte si:
{{< gallery match="images/3/*.png" >}}
Strežnik NGINX je treba znova zagnati:
{{< terminal >}}
sudo service nginx restart

{{</ terminal >}}
Spremembo je treba izvesti tudi v konfiguraciji omrežja Tor. V datoteki "/etc/tor/torrc" komentiram naslednji vrstici "HiddenServiceDir" in "HiddenServicePort".
{{< gallery match="images/4/*.png" >}}
Po tem znova zaženem tudi to storitev:
{{< terminal >}}
sudo service tor restart

{{</ terminal >}}

## Pripravljen
Pod "/var/lib/tor/hidden_servic/hostname" najdem svoj naslov Darknet/Onion. Zdaj so vse vsebine pod /var/www/html na voljo v Darkentu.
{{< gallery match="images/5/*.png" >}}
