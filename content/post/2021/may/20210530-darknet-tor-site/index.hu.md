+++
date = "2021-05-30"
title = "Saját Darknet oldal létrehozása"
difficulty = "level-3"
tags = ["darknet", "tor", "website", "hosting", "hidden"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/may/20210530-darknet-tor-site/index.hu.md"
+++
Látogatóként szörfözni a Darknetben nagyon egyszerű. De hogyan tudok egy Onion oldalt üzemeltetni? Megmutatom, hogyan hozhatod létre a saját Darknet oldaladat.
## 1. lépés: Hogyan szörfözhetek a Darknetben?
A jobb szemléltetés érdekében Ubuntu asztali gépet használok. Ott telepítem a következő csomagokat:
{{< terminal >}}
sudo apt-get update
sudo apt-get install tor 

{{</ terminal >}}
Ezután szerkesztem a "/etc/privoxy/config" fájlt, és beírom a következőket ($ sudo vim /etc/privoxy/config). A számítógép IP-címét az "ifconfig" segítségével tudhatja meg.
```
listen-address hier-muss-die-ip-des-rechners-rein:8118
forward-socks5 / 127.0.0.1:9050 .

```
Lásd:
{{< gallery match="images/1/*.png" >}}
Ahhoz, hogy a Tor és a Privoxy is elinduljon a rendszer indításakor, még mindig be kell írnunk őket az automatikus indításba:
{{< terminal >}}
sudo update-rc.d tor defaults
sudo update-rc.d privoxy defaults

{{</ terminal >}}
Most már elindíthatók a szolgáltatások:
{{< terminal >}}
sudo service tor restart
sudo service privoxy restart

{{</ terminal >}}
Beírom a proxy-címet a Firefoxomban, kikapcsolom a "Javascriptet", és meglátogatom a "Tor tesztoldalt". Ha minden működött, akkor most már meglátogathatom a TOR/.Onion oldalakat.
{{< gallery match="images/2/*.png" >}}

## 2. lépés: Hogyan tudok Darknet oldalt üzemeltetni?
Először is telepítek egy HTTP-kiszolgálót:
{{< terminal >}}
sudo apt-get install nginx

{{</ terminal >}}
Ezután megváltoztatom az NGINX konfigurációját (vim /etc/nginx/nginx.conf), és kikapcsolom ezeket a funkciókat:
```
server_tokens off;
port_in_redirect off;
server_name_in_redirect off;

```
Lásd:
{{< gallery match="images/3/*.png" >}}
Az NGINX-kiszolgálót most újra kell indítani:
{{< terminal >}}
sudo service nginx restart

{{</ terminal >}}
A Tor konfigurációban is változtatni kell. A "/etc/tor/torrc" fájlban a következő "HiddenServiceDir" és "HiddenServicePort" sorokat kommentálom.
{{< gallery match="images/4/*.png" >}}
Ezt követően én is újraindítom ezt a szolgáltatást:
{{< terminal >}}
sudo service tor restart

{{</ terminal >}}

## Kész
A "/var/lib/tor/hidden_servic/hostname" alatt találom a Darknet/Onion címemet. Most a /var/www/html alatt található összes tartalom elérhető a Darkentben.
{{< gallery match="images/5/*.png" >}}
