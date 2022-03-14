+++
date = "2021-05-30"
title = "Skapa din egen Darknet-sida"
difficulty = "level-3"
tags = ["darknet", "tor", "website", "hosting", "hidden"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/may/20210530-darknet-tor-site/index.sv.md"
+++
Att surfa på Darknet som besökare är ganska enkelt. Men hur kan jag vara värd för en Onion-sida? Jag kommer att visa dig hur du skapar din egen Darknet-sida.
## Steg 1: Hur kan jag surfa på Darknet?
Jag använder ett Ubuntu-datorbord för att illustrera det bättre. Där installerar jag följande paket:
{{< terminal >}}
sudo apt-get update
sudo apt-get install tor 

{{</ terminal >}}
Sedan redigerar jag filen "/etc/privoxy/config" och skriver in följande ($ sudo vim /etc/privoxy/config). Du kan ta reda på datorns IP-adress med "ifconfig".
```
listen-address hier-muss-die-ip-des-rechners-rein:8118
forward-socks5 / 127.0.0.1:9050 .

```
Se:
{{< gallery match="images/1/*.png" >}}
För att se till att Tor och Privoxy också körs när systemet startas måste vi fortfarande ange dem i autostart:
{{< terminal >}}
sudo update-rc.d tor defaults
sudo update-rc.d privoxy defaults

{{</ terminal >}}
Nu kan tjänsterna startas:
{{< terminal >}}
sudo service tor restart
sudo service privoxy restart

{{</ terminal >}}
Jag anger proxyadressen i min Firefox, inaktiverar "Javascript" och besöker "Tor-testsidan". Om allt har fungerat kan jag nu besöka TOR/.Onion-webbplatser.
{{< gallery match="images/2/*.png" >}}

## Steg 2: Hur kan jag vara värd för en Darknet-webbplats?
Först installerar jag en HTTP-server:
{{< terminal >}}
sudo apt-get install nginx

{{</ terminal >}}
Sedan ändrar jag NGINX-konfigurationen (vim /etc/nginx/nginx.conf) och stänger av dessa funktioner:
```
server_tokens off;
port_in_redirect off;
server_name_in_redirect off;

```
Se:
{{< gallery match="images/3/*.png" >}}
NGINX-servern måste nu startas om igen:
{{< terminal >}}
sudo service nginx restart

{{</ terminal >}}
En ändring måste också göras i Tor-konfigurationen. Jag kommenterar följande rader "HiddenServiceDir" och "HiddenServicePort" i filen "/etc/tor/torrc".
{{< gallery match="images/4/*.png" >}}
Därefter startar jag om tjänsten:
{{< terminal >}}
sudo service tor restart

{{</ terminal >}}

## Redo
Under "/var/lib/tor/hidden_servic/hostname" hittar jag min Darknet/Onion-adress. Nu är allt innehåll under /var/www/html tillgängligt i Darkent.
{{< gallery match="images/5/*.png" >}}