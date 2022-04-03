+++
date = "2021-09-05"
title = "Великие дела с контейнерами: медиасерверы Logitech на дисковой станции Synology"
difficulty = "level-1"
tags = ["logitech", "synology", "diskstation", "nas", "sound-system", "multiroom"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/september/20210905-logitech-mediaserver/index.ru.md"
+++
В этом руководстве вы узнаете, как установить Logitech Media Server на Synology DiskStation.
{{< gallery match="images/1/*.jpg" >}}

## Шаг 1: Подготовьте папку Logitech Media Server
Я создаю новый каталог под названием "logitechmediaserver" в каталоге Docker.
{{< gallery match="images/2/*.png" >}}

## Шаг 2: Установите образ Logitech Mediaserver
Я перехожу на вкладку "Регистрация" в окне Synology Docker и ищу "logitechmediaserver". Я выбираю образ Docker "lmscommunity/logitechmediaserver", а затем нажимаю на тег "latest".
{{< gallery match="images/3/*.png" >}}
Я дважды щелкаю по образу Logitech Media Server. Затем я нажимаю на "Дополнительные настройки" и активирую "Автоматический перезапуск" здесь же.
{{< gallery match="images/4/*.png" >}}
{{<table "table table-striped table-bordered">}}
|Ordner |Маунтпат|
|--- |---|
|/volume1/docker/logitechmediaserver/config |/config|
|/volume1/docker/logitechmediaserver/music |/музыка|
|/volume1/docker/logitechmediaserver/playlist |/плейлист|
{{</table>}}
Я выбираю вкладку "Том" и нажимаю "Добавить папку". Там я создаю три папки:См:
{{< gallery match="images/5/*.png" >}}
Я назначаю фиксированные порты для контейнера "Logitechmediaserver". При отсутствии фиксированных портов может оказаться, что после перезапуска "сервер Logitechmediaserver" работает на другом порту.
{{< gallery match="images/6/*.png" >}}
Наконец, я ввожу переменную окружения. Переменная "TZ" - это часовой пояс "Европа/Берлин".
{{< gallery match="images/7/*.png" >}}
После этих настроек можно запускать Logitechmediaserver-Server! После этого можно вызвать Logitechmediaserver через Ip-адрес устройства Synology и назначенный порт, например http://192.168.21.23:9000 .
{{< gallery match="images/8/*.png" >}}

