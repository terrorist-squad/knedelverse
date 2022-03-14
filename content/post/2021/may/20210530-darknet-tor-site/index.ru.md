+++
date = "2021-05-30"
title = "Создайте свою собственную страницу в Даркнете"
difficulty = "level-3"
tags = ["darknet", "tor", "website", "hosting", "hidden"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/may/20210530-darknet-tor-site/index.ru.md"
+++
Серфинг в Даркнете в качестве посетителя довольно прост. Но как я могу разместить у себя страницу Onion? Я покажу вам, как создать свою собственную страницу в Darknet.
## Шаг 1: Как пользоваться Даркнетом?
Я использую рабочий стол Ubuntu для лучшей иллюстрации. Там я устанавливаю следующие пакеты:
{{< terminal >}}
sudo apt-get update
sudo apt-get install tor 

{{</ terminal >}}
Затем я редактирую файл "/etc/privoxy/config" и ввожу следующее ($ sudo vim /etc/privoxy/config). IP компьютера можно узнать с помощью команды "ifconfig".
```
listen-address hier-muss-die-ip-des-rechners-rein:8118
forward-socks5 / 127.0.0.1:9050 .

```
См:
{{< gallery match="images/1/*.png" >}}
Чтобы Tor и Privoxy также выполнялись при запуске системы, нам все же придется ввести их в автозагрузку:
{{< terminal >}}
sudo update-rc.d tor defaults
sudo update-rc.d privoxy defaults

{{</ terminal >}}
Теперь службы можно запустить:
{{< terminal >}}
sudo service tor restart
sudo service privoxy restart

{{</ terminal >}}
Я ввожу адрес прокси-сервера в Firefox, отключаю "Javascript" и посещаю "тестовую страницу Tor". Если все сработало, теперь я могу посещать сайты TOR/.Onion.
{{< gallery match="images/2/*.png" >}}

## Шаг 2: Как я могу разместить сайт Darknet?
Сначала я устанавливаю HTTP-сервер:
{{< terminal >}}
sudo apt-get install nginx

{{</ terminal >}}
Затем я изменяю конфигурацию NGINX (vim /etc/nginx/nginx.conf) и отключаю эти функции:
```
server_tokens off;
port_in_redirect off;
server_name_in_redirect off;

```
См:
{{< gallery match="images/3/*.png" >}}
Теперь необходимо снова перезапустить сервер NGINX:
{{< terminal >}}
sudo service nginx restart

{{</ terminal >}}
Также необходимо внести изменения в конфигурацию Tor. Я закомментировал следующие строки "HiddenServiceDir" и "HiddenServicePort" в файле "/etc/tor/torrc".
{{< gallery match="images/4/*.png" >}}
После этого я также перезапускаю эту службу:
{{< terminal >}}
sudo service tor restart

{{</ terminal >}}

## Готовый
В разделе "/var/lib/tor/hidden_servic/hostname" я нашел свой адрес в Darknet/Onion. Теперь все содержимое под /var/www/html доступно в Darkent.
{{< gallery match="images/5/*.png" >}}