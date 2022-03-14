+++
date = "2021-04-25T09:28:11+01:00"
title = "BitwardenRS на Synology DiskStation"
difficulty = "level-2"
tags = ["bitwardenrs", "Docker", "docker-compose", "password-manager", "passwort", "Synology"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/april/20210425-docker-BitwardenRS/index.ru.md"
+++
Bitwarden - это бесплатная служба управления паролями с открытым исходным кодом, которая хранит конфиденциальную информацию, такую как учетные данные веб-сайтов, в зашифрованном хранилище. Сегодня я покажу, как установить BitwardenRS на Synology DiskStation.
## Шаг 1: Подготовьте папку BitwardenRS
Я создаю новый каталог под названием "bitwarden" в каталоге Docker.
{{< gallery match="images/1/*.png" >}}

## Шаг 2: Установите BitwardenRS
Я перехожу на вкладку "Регистрация" в окне Synology Docker и ищу "bitwarden". Я выбираю образ Docker "bitwardenrs/server", а затем нажимаю на тег "latest".
{{< gallery match="images/2/*.png" >}}
Я дважды щелкаю по изображению моего битварденрса. Затем я нажимаю на "Дополнительные настройки" и активирую "Автоматический перезапуск" здесь же.
{{< gallery match="images/3/*.png" >}}
Я выбираю вкладку "Том" и нажимаю "Добавить папку". Там я создаю новую папку с таким путем монтирования "/data".
{{< gallery match="images/4/*.png" >}}
Я назначаю фиксированные порты для контейнера "bitwardenrs". При отсутствии фиксированных портов может оказаться, что после перезапуска "bitwardenrs server" работает на другом порту. Первый контейнерный порт может быть удален. Следует помнить о другом порте.
{{< gallery match="images/5/*.png" >}}
Теперь контейнер можно запустить. Я вызываю сервер bitwardenrs с IP-адресом Synology и портом моего контейнера 8084.
{{< gallery match="images/6/*.png" >}}

## Шаг 3: Настройте HTTPS
Я нажимаю на "Панель управления" > "Обратный прокси" и "Создать".
{{< gallery match="images/7/*.png" >}}
После этого я могу позвонить на сервер bitwardenrs с IP-адреса Synology и моего прокси-порта 8085, зашифрованного.
{{< gallery match="images/8/*.png" >}}