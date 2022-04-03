+++
date = "2021-04-16"
title = "Великие дела с контейнерами: установка собственной MediaWiki на дисковую станцию Synology"
difficulty = "level-1"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "mediawiki", "wiki"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210416-docker-MediaWiki/index.ru.md"
+++
MediaWiki - это основанная на PHP вики-система, которая доступна бесплатно как продукт с открытым исходным кодом. Сегодня я покажу, как установить службу MediaWiki на дисковую станцию Synology.
## Вариант для профессионалов
Как опытный пользователь Synology, вы, конечно, можете войти в систему с помощью SSH и установить всю установку через файл Docker Compose.
```
version: '3'
services:
  mediawiki:
    image: mediawiki
    restart: always
    ports:
      - 8081:80
    links:
      - database
    volumes:
      - ./images:/var/www/html/images
      # After initial setup, download LocalSettings.php to the same directory as
      # this yaml and uncomment the following line and use compose to restart
      # the mediawiki service
      # - ./LocalSettings.php:/var/www/html/LocalSettings.php

  database:
    image: mariadb
    restart: always
    volumes:
       - ./mysql:/var/lib/mysql
    environment:
      # @see https://phabricator.wikimedia.org/source/mediawiki/browse/master/includes/DefaultSettings.php
      MYSQL_ROOT_PASSWORD: my_wiki_pass1
      MYSQL_DATABASE: my_wiki
      MYSQL_USER: wikiuser
      MYSQL_PASSWORD: my_wiki_pass

```
Более полезные образы Docker для домашнего использования можно найти в [Dockerverse]({{< ref "dockerverse" >}} "Dockerverse").
## Шаг 1: Подготовьте папку MediaWiki
Я создаю новый каталог под названием "wiki" в каталоге Docker.
{{< gallery match="images/1/*.png" >}}

## Шаг 2: Установите базу данных
После этого необходимо создать базу данных. Я перехожу на вкладку "Регистрация" в окне Synology Docker и ищу "mariadb". Я выбираю образ Docker "mariadb" и затем нажимаю на тег "latest".
{{< gallery match="images/2/*.png" >}}
После загрузки изображения оно доступно в виде рисунка. Docker различает 2 состояния: контейнер - "динамическое состояние" и образ (фиксированное состояние). Прежде чем мы создадим контейнер из образа, необходимо выполнить несколько настроек. Я дважды щелкаю на моем образе mariadb.
{{< gallery match="images/3/*.png" >}}
Затем я нажимаю на "Дополнительные настройки" и активирую "Автоматический перезапуск". Я выбираю вкладку "Том" и нажимаю "Добавить папку". Там я создаю новую папку базы данных с таким путем монтирования "/var/lib/mysql".
{{< gallery match="images/4/*.png" >}}
В разделе "Настройки порта" все порты удалены. Это означает, что я выбираю порт "3306" и удаляю его с помощью кнопки "-".
{{< gallery match="images/5/*.png" >}}
{{<table "table table-striped table-bordered">}}
|Имя переменной|Значение|Что это такое?|
|--- | --- |---|
|TZ	| Europe/Berlin	|Часовой пояс|
|MYSQL_ROOT_PASSWORD	| my_wiki_pass	|Главный пароль базы данных.|
|MYSQL_DATABASE |	my_wiki	|Это имя базы данных.|
|MYSQL_USER	| wikiuser |Имя пользователя базы данных вики.|
|MYSQL_PASSWORD	| my_wiki_pass |Пароль пользователя базы данных wiki.|
{{</table>}}
Наконец, я ввожу эти переменные окружения:См:
{{< gallery match="images/6/*.png" >}}
После этих настроек сервер Mariadb может быть запущен! Я везде нажимаю "Применить".
## Шаг 3: Установите MediaWiki
Я перехожу на вкладку "Регистрация" в окне Synology Docker и ищу "mediawiki". Я выбираю образ Docker "mediawiki", а затем нажимаю на тег "latest".
{{< gallery match="images/7/*.png" >}}
Я дважды щелкаю на своем изображении Mediawiki.
{{< gallery match="images/8/*.png" >}}
Затем я нажимаю на "Дополнительные настройки" и активирую "Автоматический перезапуск" здесь же. Я выбираю вкладку "Том" и нажимаю "Добавить папку". Там я создаю новую папку с таким путем монтирования "/var/www/html/images".
{{< gallery match="images/9/*.png" >}}
Я назначаю фиксированные порты для контейнера "MediaWiki". При отсутствии фиксированных портов может оказаться, что "сервер MediaWiki" после перезапуска работает на другом порту.
{{< gallery match="images/10/*.png" >}}
Кроме того, необходимо создать "ссылку" на контейнер "mariadb". Я перехожу на вкладку "Ссылки" и выбираю контейнер базы данных. Имя псевдонима должно быть запомнено для установки вики.
{{< gallery match="images/11/*.png" >}}
Наконец, я ввожу переменную среды "TZ" со значением "Europe/Berlin".
{{< gallery match="images/12/*.png" >}}
Теперь контейнер можно запустить. Я вызываю сервер Mediawiki с IP-адресом Synology и портом моего контейнера. В разделе Сервер базы данных я ввожу псевдонимное имя контейнера базы данных. Я также ввожу имя базы данных, имя пользователя и пароль из "Шага 2".
{{< gallery match="images/13/*.png" >}}
