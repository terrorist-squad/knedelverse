+++
date = "2021-05-30"
title = "Zet uw eigen Darknet pagina op"
difficulty = "level-3"
tags = ["darknet", "tor", "website", "hosting", "hidden"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/may/20210530-darknet-tor-site/index.nl.md"
+++
Surfen op Darknet als bezoeker is vrij eenvoudig. Maar hoe kan ik een Onion pagina hosten? Ik zal je laten zien hoe je je eigen Darknet pagina kunt opzetten.
## Stap 1: Hoe kan ik op het Darknet surfen?
Ik gebruik een Ubuntu desktop voor een betere illustratie. Daar installeer ik de volgende pakketten:
{{< terminal >}}
sudo apt-get update
sudo apt-get install tor 

{{</ terminal >}}
Dan bewerk ik het "/etc/privoxy/config" bestand en voer het volgende in ($ sudo vim /etc/privoxy/config). U kunt het IP-adres van de computer achterhalen met "ifconfig".
```
listen-address hier-muss-die-ip-des-rechners-rein:8118
forward-socks5 / 127.0.0.1:9050 .

```
Zie:
{{< gallery match="images/1/*.png" >}}
Om er zeker van te zijn dat Tor en Privoxy ook worden uitgevoerd bij het opstarten van het systeem, moeten we ze nog invoeren in de autostart:
{{< terminal >}}
sudo update-rc.d tor defaults
sudo update-rc.d privoxy defaults

{{</ terminal >}}
Nu kunnen de diensten worden gestart:
{{< terminal >}}
sudo service tor restart
sudo service privoxy restart

{{</ terminal >}}
Ik voer het proxy adres in in mijn Firefox, deactiveer "Javascript" en bezoek de "Tor test pagina". Als alles gewerkt heeft, kan ik nu TOR/.Onion sites bezoeken.
{{< gallery match="images/2/*.png" >}}

## Stap 2: Hoe kan ik Darknet site hosten?
Eerst installeer ik een HTTP server:
{{< terminal >}}
sudo apt-get install nginx

{{</ terminal >}}
Dan verander ik de NGINX configuratie (vim /etc/nginx/nginx.conf) en schakel deze functies uit:
```
server_tokens off;
port_in_redirect off;
server_name_in_redirect off;

```
Zie:
{{< gallery match="images/3/*.png" >}}
De NGINX server moet nu opnieuw worden opgestart:
{{< terminal >}}
sudo service nginx restart

{{</ terminal >}}
Er moet ook een wijziging worden aangebracht in de Tor-configuratie. Ik becommentarieer de volgende regels "HiddenServiceDir" en "HiddenServicePort" in het bestand "/etc/tor/torrc".
{{< gallery match="images/4/*.png" >}}
Daarna start ik ook deze service opnieuw op:
{{< terminal >}}
sudo service tor restart

{{</ terminal >}}

## Klaar
Onder "/var/lib/tor/hidden_servic/hostname" vind ik mijn Darknet/Onion adres. Nu is alle inhoud onder /var/www/html beschikbaar in de Darkent.
{{< gallery match="images/5/*.png" >}}