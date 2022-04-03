+++
date = "2021-05-30"
title = "Программа загрузки Udemy на Synology DiskStation"
difficulty = "level-2"
tags = ["udemy", "download", "synology", "diskstation", "udemydl"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/may/20210530-udemydl/index.ru.md"
+++
В этом руководстве вы узнаете, как скачать курсы "udemy" для автономного использования.
## Шаг 1: Подготовьте папку Udemy
Я создаю новый каталог под названием "udemy" в каталоге Docker.
{{< gallery match="images/1/*.png" >}}

## Шаг 2: Установите образ Ubuntu
Я перехожу на вкладку "Регистрация" в окне Synology Docker и ищу "ubunutu". Я выбираю образ Docker "ubunutu" и затем нажимаю на тег "latest".
{{< gallery match="images/2/*.png" >}}
Я дважды щелкаю по образу Ubuntu. Затем я нажимаю на "Дополнительные настройки" и активирую "Автоматический перезапуск" здесь же.
{{< gallery match="images/3/*.png" >}}
Я выбираю вкладку "Том" и нажимаю "Добавить папку". Там я создаю новую папку с таким путем монтирования "/download".
{{< gallery match="images/4/*.png" >}}
Теперь контейнер можно запустить
{{< gallery match="images/5/*.png" >}}

## Шаг 4: Установите программу загрузки Udemy
Я нажимаю на "Контейнер" в окне Synology Docker и дважды щелкаю на моем "контейнере Udemy". Затем я перехожу на вкладку "Терминал" и ввожу следующие команды.
{{< gallery match="images/6/*.png" >}}

##  Команды:

{{< terminal >}}
apt-get update
apt-get install python3 python3-pip wget unzip
cd /download
wget https://github.com/r0oth3x49/udemy-dl/archive/refs/heads/master.zip
unzip master.zip
cd udemy-dl-master
pip3 pip install -r requirements.txt

{{</ terminal >}}
Скриншоты:
{{< gallery match="images/7/*.png" >}}

## Шаг 4: Ввод в действие программы загрузки Udemy
Теперь мне нужен "маркер доступа". Я захожу на сайт Udemy через браузер Firefox и открываю Firebug. Я перехожу на вкладку "Веб-хранилище" и копирую "Токен доступа".
{{< gallery match="images/8/*.png" >}}
Я создаю новый файл в своем контейнере:
{{< terminal >}}
echo "access_token=859wjuhV7PMLsZu15GOWias9A0iFnRjkL9pJXOv2" > /download/cookie.txt

{{</ terminal >}}
После этого я могу загрузить уже купленные курсы:
{{< terminal >}}
cd /download
python3 udemy-dl-master/udemy-dl.py -k /download/cookie.txt https://www.udemy.com/course/ansible-grundlagen/learn/

{{</ terminal >}}
См:
{{< gallery match="images/9/*.png" >}}

