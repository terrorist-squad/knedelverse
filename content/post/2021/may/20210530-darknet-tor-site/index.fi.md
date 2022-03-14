+++
date = "2021-05-30"
title = "Perusta oma Darknet-sivusi"
difficulty = "level-3"
tags = ["darknet", "tor", "website", "hosting", "hidden"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/may/20210530-darknet-tor-site/index.fi.md"
+++
Darknetissä surffailu vierailijana on melko yksinkertaista. Mutta miten voin isännöidä Onion-sivua? Näytän sinulle, miten voit perustaa oman Darknet-sivusi.
## Vaihe 1: Miten voin surffata Darknetissä?
Käytän Ubuntu-työpöytää paremman havainnollistamisen vuoksi. Asennan sinne seuraavat paketit:
{{< terminal >}}
sudo apt-get update
sudo apt-get install tor 

{{</ terminal >}}
Sitten muokkaan tiedostoa "/etc/privoxy/config" ja kirjoitan seuraavan ($ sudo vim /etc/privoxy/config). Voit selvittää tietokoneen IP-osoitteen komennolla "ifconfig".
```
listen-address hier-muss-die-ip-des-rechners-rein:8118
forward-socks5 / 127.0.0.1:9050 .

```
Katso:
{{< gallery match="images/1/*.png" >}}
Varmistaaksemme, että Tor ja Privoxy suoritetaan myös järjestelmän käynnistyessä, meidän on vielä syötettävä ne automaattiseen käynnistykseen:
{{< terminal >}}
sudo update-rc.d tor defaults
sudo update-rc.d privoxy defaults

{{</ terminal >}}
Nyt palvelut voidaan käynnistää:
{{< terminal >}}
sudo service tor restart
sudo service privoxy restart

{{</ terminal >}}
Syötän välityspalvelimen osoitteen Firefoxiin, poistan "Javascriptin" käytöstä ja käyn "Torin testisivulla". Jos kaikki on toiminut, voin nyt vierailla TOR/.Onion-sivustoilla.
{{< gallery match="images/2/*.png" >}}

## Vaihe 2: Miten voin isännöidä Darknet-sivustoa?
Asennan ensin HTTP-palvelimen:
{{< terminal >}}
sudo apt-get install nginx

{{</ terminal >}}
Sitten muutan NGINX-konfiguraatiota (vim /etc/nginx/nginx.conf) ja kytken nämä ominaisuudet pois päältä:
```
server_tokens off;
port_in_redirect off;
server_name_in_redirect off;

```
Katso:
{{< gallery match="images/3/*.png" >}}
NGINX-palvelin on nyt käynnistettävä uudelleen:
{{< terminal >}}
sudo service nginx restart

{{</ terminal >}}
Myös Tor-konfiguraatioon on tehtävä muutos. Kommentoin seuraavat rivit "HiddenServiceDir" ja "HiddenServicePort" tiedostoon "/etc/tor/torrc".
{{< gallery match="images/4/*.png" >}}
Tämän jälkeen käynnistän myös tämän palvelun uudelleen:
{{< terminal >}}
sudo service tor restart

{{</ terminal >}}

## Valmis
Kohdassa "/var/lib/tor/hidden_servic/hostname" on Darknet/Onion-osoitteeni. Nyt kaikki /var/www/html:n alla oleva sisältö on saatavilla Darkentissa.
{{< gallery match="images/5/*.png" >}}