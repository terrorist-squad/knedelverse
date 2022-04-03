+++
date = "2021-05-30"
title = "Opret din egen Darknet-side"
difficulty = "level-3"
tags = ["darknet", "tor", "website", "hosting", "hidden"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/may/20210530-darknet-tor-site/index.da.md"
+++
Det er ganske enkelt at surfe på Darknet som besøgende. Men hvordan kan jeg være vært for en Onion-side? Jeg vil vise dig, hvordan du opretter din egen Darknet-side.
## Trin 1: Hvordan kan jeg surfe på Darknet?
Jeg bruger et Ubuntu-skrivebord for at illustrere det bedre. Der installerer jeg følgende pakker:
{{< terminal >}}
sudo apt-get update
sudo apt-get install tor 

{{</ terminal >}}
Derefter redigerer jeg filen "/etc/privoxy/config" og indtaster følgende ($ sudo vim /etc/privoxy/config). Du kan finde computerens IP-nummer med "ifconfig".
```
listen-address hier-muss-die-ip-des-rechners-rein:8118
forward-socks5 / 127.0.0.1:9050 .

```
Se:
{{< gallery match="images/1/*.png" >}}
For at sikre, at Tor og Privoxy også udføres ved systemstart, skal vi stadig indtaste dem i autostart:
{{< terminal >}}
sudo update-rc.d tor defaults
sudo update-rc.d privoxy defaults

{{</ terminal >}}
Nu kan tjenesterne startes:
{{< terminal >}}
sudo service tor restart
sudo service privoxy restart

{{</ terminal >}}
Jeg indtaster proxy-adressen i min Firefox, deaktiverer "Javascript" og besøger "Tor-testsiden". Hvis alt har virket, kan jeg nu besøge TOR/.Onion-websteder.
{{< gallery match="images/2/*.png" >}}

## Trin 2: Hvordan kan jeg være vært for et Darknet-websted?
Først installerer jeg en HTTP-server:
{{< terminal >}}
sudo apt-get install nginx

{{</ terminal >}}
Derefter ændrer jeg NGINX-konfigurationen (vim /etc/nginx/nginx.conf) og slår disse funktioner fra:
```
server_tokens off;
port_in_redirect off;
server_name_in_redirect off;

```
Se:
{{< gallery match="images/3/*.png" >}}
NGINX-serveren skal nu genstartes igen:
{{< terminal >}}
sudo service nginx restart

{{</ terminal >}}
Der skal også foretages en ændring i Tor-konfigurationen. Jeg kommenterer følgende linjer "HiddenServiceDir" og "HiddenServicePort" i filen "/etc/tor/torrc".
{{< gallery match="images/4/*.png" >}}
Derefter genstarter jeg også denne tjeneste:
{{< terminal >}}
sudo service tor restart

{{</ terminal >}}

## Klar
Under "/var/lib/tor/hidden_servic/hostname" finder jeg min Darknet/Onion-adresse. Nu er alt indhold under /var/www/html tilgængeligt i Darkent.
{{< gallery match="images/5/*.png" >}}
