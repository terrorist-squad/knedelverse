+++
date = "2021-05-30"
title = "Eigene Darknet-Seite aufsetzen"
difficulty = "level-3"
tags = ["darknet", "tor", "website", "hosting", "hidden"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/may/20210530-darknet-tor-site/index.de.md"
+++


Als Besucher ins Darknet zu surfen ist ziemlich simpel. Doch wie kann ich eine Onion-Seite hosten? Ich zzeige, wie Sie eine eigene Darknet-Seite aufsetzen können.

## Schritt 1: Wie kann ich durchs Darknet surfen?
Ich verwende einen Ubuntu-Desktop zur besseren Veranschaulichung. Dort installiere ich folgende Pakete:
{{< terminal >}}
sudo apt-get update
sudo apt-get install tor 
{{</ terminal >}}

Danach editiere ich die "/etc/privoxy/config"-Datei und trage dort folgendes ein ($ sudo vim /etc/privoxy/config). Die IP des Rechners bekommt man mit "ifconfig" raus.
```
listen-address hier-muss-die-ip-des-rechners-rein:8118
forward-socks5 / 127.0.0.1:9050 .
```
Siehe:
{{< gallery match="images/1/*.png" >}}

Damit Tor und Privoxy auch beim Systemstart ausgeführt werden, müssen wir diese noch in den Autostart eintragen:
{{< terminal >}}
sudo update-rc.d tor defaults
sudo update-rc.d privoxy defaults
{{</ terminal >}}

Nun können die Dienste gestartet werden:
{{< terminal >}}
sudo service tor restart
sudo service privoxy restart
{{</ terminal >}}

Ich trage die Proxy-Adresse in meinen Firefox ein, deaktiviere "Javascript" und besuche die "Tor-Testseite". Wenn alles geklappt hat, kann ich nun TOR/.Onion-Sites besuchen.
{{< gallery match="images/2/*.png" >}}

## Schritt 2: Wie kann ich Darknet-Seite hosten?
Zunächst installiere ich mir einen HTTP-Server:
{{< terminal >}}
sudo apt-get install nginx
{{</ terminal >}}

Danach ändere ich die NGINX-Konfiguration (vim /etc/nginx/nginx.conf) und schalte diese Features aus:
```
server_tokens off;
port_in_redirect off;
server_name_in_redirect off;
```
Siehe:
{{< gallery match="images/3/*.png" >}}

Der NGINX-Server muss nun noch einmal neu gestartet werden:
{{< terminal >}}
sudo service nginx restart
{{</ terminal >}}

Auch in der Tor-Konfiguration muss einen Änderung gemacht werden. Ich kommentiere folgende Zeilen "HiddenServiceDir" und "HiddenServicePort" in der "/etc/tor/torrc"-Datei ein.
{{< gallery match="images/4/*.png" >}}

Danach starte ich auch diesen DIenst neu:
{{< terminal >}}
sudo service tor restart
{{</ terminal >}}

## Fertig
Unter "/var/lib/tor/hidden_servic/hostname" finde ich meine Darknet/Onion-Adresse. Nun sind alle Inhalte unter /var/www/html im Darkent verfügbar.
{{< gallery match="images/5/*.png" >}}