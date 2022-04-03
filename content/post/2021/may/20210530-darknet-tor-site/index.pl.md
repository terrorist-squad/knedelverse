+++
date = "2021-05-30"
title = "Załóż własną stronę Darknetu"
difficulty = "level-3"
tags = ["darknet", "tor", "website", "hosting", "hidden"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/may/20210530-darknet-tor-site/index.pl.md"
+++
Surfowanie po Darknecie jako odwiedzający jest dość proste. Ale jak mogę hostować stronę Onion? Pokażę Ci, jak założyć własną stronę Darknetu.
## Krok 1: Jak mogę surfować w Darknecie?
Dla lepszego zobrazowania używam komputera stacjonarnego z systemem Ubuntu. W tym celu należy zainstalować następujące pakiety:
{{< terminal >}}
sudo apt-get update
sudo apt-get install tor 

{{</ terminal >}}
Następnie dokonuję edycji pliku "/etc/privoxy/config" i wpisuję następujące polecenie ($ sudo vim /etc/privoxy/config). Adres IP komputera można sprawdzić za pomocą polecenia "ifconfig".
```
listen-address hier-muss-die-ip-des-rechners-rein:8118
forward-socks5 / 127.0.0.1:9050 .

```
Zobacz:
{{< gallery match="images/1/*.png" >}}
Aby zapewnić, że Tor i Privoxy będą również uruchamiane przy starcie systemu, musimy je jeszcze wprowadzić do autostartu:
{{< terminal >}}
sudo update-rc.d tor defaults
sudo update-rc.d privoxy defaults

{{</ terminal >}}
Teraz można uruchomić usługi:
{{< terminal >}}
sudo service tor restart
sudo service privoxy restart

{{</ terminal >}}
Wpisuję adres serwera proxy w przeglądarce Firefox, wyłączam obsługę Javascript i wchodzę na stronę testową Tor. Jeśli wszystko działa prawidłowo, mogę teraz odwiedzać witryny TOR/.Onion.
{{< gallery match="images/2/*.png" >}}

## Krok 2: Jak mogę hostować stronę Darknetu?
Najpierw należy zainstalować serwer HTTP:
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
Należy również dokonać zmiany w konfiguracji sieci Tor. Skomentowałem następujące wiersze "HiddenServiceDir" i "HiddenServicePort" w pliku "/etc/tor/torrc".
{{< gallery match="images/4/*.png" >}}
Następnie ponownie uruchamiam tę usługę:
{{< terminal >}}
sudo service tor restart

{{</ terminal >}}

## Gotowe
W sekcji "/var/lib/tor/hidden_servic/hostname" znajduje się mój adres Darknet/Onion. Teraz cała zawartość katalogu /var/www/html jest dostępna w programie Darkent.
{{< gallery match="images/5/*.png" >}}
