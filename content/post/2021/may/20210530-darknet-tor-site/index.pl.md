+++
date = "2021-05-30"
title = "Załóż własną stronę Darknet"
difficulty = "level-3"
tags = ["darknet", "tor", "website", "hosting", "hidden"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/may/20210530-darknet-tor-site/index.pl.md"
+++
Surfowanie po Darknecie jako gość jest całkiem proste. Ale jak mogę hostować stronę Onion? Pokażę Ci jak założyć własną stronę w Darknecie.
## Krok 1: Jak mogę surfować po Darknecie?
Używam pulpitu Ubuntu dla lepszego zobrazowania. Tam instaluję następujące pakiety:
{{< terminal >}}
sudo apt-get update
sudo apt-get install tor 

{{</ terminal >}}
Następnie edytuję plik "/etc/privoxy/config" i wpisuję następujące dane ($ sudo vim /etc/privoxy/config). Możesz sprawdzić IP komputera za pomocą "ifconfig".
```
listen-address hier-muss-die-ip-des-rechners-rein:8118
forward-socks5 / 127.0.0.1:9050 .

```
Zobacz:
{{< gallery match="images/1/*.png" >}}
Aby zapewnić, że Tor i Privoxy są również uruchamiane przy starcie systemu, musimy jeszcze wpisać je do autostartu:
{{< terminal >}}
sudo update-rc.d tor defaults
sudo update-rc.d privoxy defaults

{{</ terminal >}}
Teraz można uruchomić usługi:
{{< terminal >}}
sudo service tor restart
sudo service privoxy restart

{{</ terminal >}}
Wpisuję adres proxy w moim Firefoxie, dezaktywuję "Javascript" i odwiedzam "Tor test page". Jeśli wszystko zadziałało, mogę teraz odwiedzać strony TOR/.Onion.
{{< gallery match="images/2/*.png" >}}

## Krok 2: Jak mogę hostować stronę Darknet?
Najpierw instaluję serwer HTTP:
{{< terminal >}}
sudo apt-get install nginx

{{</ terminal >}}
Następnie zmieniam konfigurację NGINX (vim /etc/nginx/nginx.conf) i wyłączam te funkcje:
```
server_tokens off;
port_in_redirect off;
server_name_in_redirect off;

```
Zobacz:
{{< gallery match="images/3/*.png" >}}
Teraz należy ponownie uruchomić serwer NGINX:
{{< terminal >}}
sudo service nginx restart

{{</ terminal >}}
Należy również dokonać zmiany w konfiguracji Tor. Skomentowałem następujące linie "HiddenServiceDir" i "HiddenServicePort" w pliku "/etc/tor/torrc".
{{< gallery match="images/4/*.png" >}}
Po tym, również zrestartowałem tę usługę:
{{< terminal >}}
sudo service tor restart

{{</ terminal >}}

## Gotowe
Pod "/var/lib/tor/hidden_servic/hostname" znajduję mój adres Darknet/Onion. Teraz cała zawartość pod /var/www/html jest dostępna w Darkent.
{{< gallery match="images/5/*.png" >}}