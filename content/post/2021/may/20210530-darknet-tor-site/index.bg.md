+++
date = "2021-05-30"
title = "Създаване на собствена страница в Darknet"
difficulty = "level-3"
tags = ["darknet", "tor", "website", "hosting", "hidden"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/may/20210530-darknet-tor-site/index.bg.md"
+++
Сърфирането в Даркнет като посетител е съвсем просто. Но как мога да хоствам страница на Onion? Ще ви покажа как да създадете своя собствена страница в Даркнет.
## Стъпка 1: Как мога да сърфирам в Darknet?
Използвам десктоп Ubuntu за по-добра илюстрация. Там инсталирам следните пакети:
{{< terminal >}}
sudo apt-get update
sudo apt-get install tor 

{{</ terminal >}}
След това редактирам файла "/etc/privoxy/config" и въвеждам следното ($ sudo vim /etc/privoxy/config). Можете да откриете IP адреса на компютъра с помощта на "ifconfig".
```
listen-address hier-muss-die-ip-des-rechners-rein:8118
forward-socks5 / 127.0.0.1:9050 .

```
Вижте:
{{< gallery match="images/1/*.png" >}}
За да гарантираме, че Tor и Privoxy се изпълняват и при стартиране на системата, все пак трябва да ги въведем в автоматичното стартиране:
{{< terminal >}}
sudo update-rc.d tor defaults
sudo update-rc.d privoxy defaults

{{</ terminal >}}
Сега услугите могат да бъдат стартирани:
{{< terminal >}}
sudo service tor restart
sudo service privoxy restart

{{</ terminal >}}
Въвеждам адреса на прокси сървъра във Firefox, деактивирам "Javascript" и посещавам "тестовата страница на Tor". Ако всичко е работило, вече мога да посещавам сайтове TOR/.Onion.
{{< gallery match="images/2/*.png" >}}

## Стъпка 2: Как мога да хоствам Darknet сайт?
Първо инсталирам HTTP сървър:
{{< terminal >}}
sudo apt-get install nginx

{{</ terminal >}}
След това променям конфигурацията на NGINX (vim /etc/nginx/nginx.conf) и изключвам тези функции:
```
server_tokens off;
port_in_redirect off;
server_name_in_redirect off;

```
Вижте:
{{< gallery match="images/3/*.png" >}}
Сега сървърът NGINX трябва да бъде рестартиран отново:
{{< terminal >}}
sudo service nginx restart

{{</ terminal >}}
Промяна трябва да бъде направена и в конфигурацията на Tor. Коментирам следните редове "HiddenServiceDir" и "HiddenServicePort" във файла "/etc/tor/torrc".
{{< gallery match="images/4/*.png" >}}
След това рестартирах и тази услуга:
{{< terminal >}}
sudo service tor restart

{{</ terminal >}}

## Готов
Под "/var/lib/tor/hidden_servic/hostname" намирам адреса си в Darknet/Onion. Сега цялото съдържание в /var/www/html е достъпно в Darkent.
{{< gallery match="images/5/*.png" >}}