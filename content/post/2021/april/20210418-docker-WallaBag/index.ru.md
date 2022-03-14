+++
date = "2021-04-18"
title = "Великие дела с контейнерами: собственный WallaBag на дисковой станции Synology"
difficulty = "level-1"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "archiv", "wallabag"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210418-docker-WallaBag/index.ru.md"
+++
Wallabag - это программа для архивирования интересных сайтов или статей. Сегодня я покажу, как установить службу Wallabag на дисковую станцию Synology.
## Вариант для профессионалов
Как опытный пользователь Synology, вы, конечно, можете войти в систему с помощью SSH и установить всю установку через файл Docker Compose.
```
version: '3'
services:
  wallabag:
    image: wallabag/wallabag
    environment:
      - MYSQL_ROOT_PASSWORD=wallaroot
      - SYMFONY__ENV__DATABASE_DRIVER=pdo_mysql
      - SYMFONY__ENV__DATABASE_HOST=db
      - SYMFONY__ENV__DATABASE_PORT=3306
      - SYMFONY__ENV__DATABASE_NAME=wallabag
      - SYMFONY__ENV__DATABASE_USER=wallabag
      - SYMFONY__ENV__DATABASE_PASSWORD=wallapass
      - SYMFONY__ENV__DATABASE_CHARSET=utf8mb4
      - SYMFONY__ENV__DOMAIN_NAME=http://192.168.178.50:8089
      - SYMFONY__ENV__SERVER_NAME="Your wallabag instance"
      - SYMFONY__ENV__FOSUSER_CONFIRMATION=false
      - SYMFONY__ENV__TWOFACTOR_AUTH=false
    ports:
      - "8089:80"
    volumes:
      - ./wallabag/images:/var/www/wallabag/web/assets/images

  db:
    image: mariadb
    environment:
      - MYSQL_ROOT_PASSWORD=wallaroot
    volumes:
      - ./mariadb:/var/lib/mysql

```
Более полезные образы Docker для домашнего использования можно найти в [Dockerverse]({{< ref "dockerverse" >}} "Dockerverse").
## Шаг 1: Подготовьте папку для настенной сумки
Я создаю новый каталог под названием "wallabag" в каталоге Docker.
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
|TZ| Europe/Berlin	|Часовой пояс|
|MYSQL_ROOT_PASSWORD	 | wallaroot |Главный пароль базы данных.|
{{</table>}}
Наконец, я ввожу эти переменные окружения:См:
{{< gallery match="images/6/*.png" >}}
После этих настроек сервер Mariadb может быть запущен! Я везде нажимаю "Применить".
{{< gallery match="images/7/*.png" >}}

## Шаг 3: Установите Wallabag
Я перехожу на вкладку "Регистрация" в окне Synology Docker и ищу "wallabag". Я выбираю образ Docker "wallabag/wallabag", а затем нажимаю на метку "latest".
{{< gallery match="images/8/*.png" >}}
Я дважды щелкаю по изображению своего валлабага. Затем я нажимаю на "Дополнительные настройки" и активирую "Автоматический перезапуск" здесь же.
{{< gallery match="images/9/*.png" >}}
Я выбираю вкладку "Том" и нажимаю "Добавить папку". Там я создаю новую папку с таким путем монтирования "/var/www/wallabag/web/assets/images".
{{< gallery match="images/10/*.png" >}}
Я назначаю фиксированные порты для контейнера "wallabag". Без фиксированных портов может оказаться, что после перезапуска "сервер wallabag" работает на другом порту. Первый контейнерный порт может быть удален. Следует помнить о другом порте.
{{< gallery match="images/11/*.png" >}}
Кроме того, необходимо создать "ссылку" на контейнер "mariadb". Я перехожу на вкладку "Ссылки" и выбираю контейнер базы данных. Имя псевдонима должно быть запомнено для установки wallabag.
{{< gallery match="images/12/*.png" >}}
{{<table "table table-striped table-bordered">}}
|Umgebungsvariable	|Значение|
|--- |---|
|MYSQL_ROOT_PASSWORD	|wallaroot|
|SYMFONY__ENV__DATABASE_DRIVER	|pdo_mysql|
|SYMFONY__ENV__DATABASE_HOST	|db|
|SYMFONY__ENV__DATABASE_PORT	|3306|
|SYMFONY__ENV__DATABASE_NAME	|сумка для одежды|
|SYMFONY__ENV__DATABASE_USER	|сумка для одежды|
|SYMFONY__ENV__DATABASE_PASSWORD	|wallapass|
|SYMFONY__ENV__DATABASE_CHARSET |utf8mb4|
|SYMFONY__ENV__DOMAIN_NAME	|"http://synology-ip:container-port" <- Пожалуйста, измените|
|SYMFONY__ENV__SERVER_NAME	|"Wallabag - Сервер"|
|SYMFONY__ENV__FOSUSER_CONFIRMATION	|ложный|
|SYMFONY__ENV__TWOFACTOR_AUTH	|ложный|
{{</table>}}
Наконец, я ввожу эти переменные окружения:См:
{{< gallery match="images/13/*.png" >}}
Теперь контейнер можно запустить. Создание базы данных может занять некоторое время. Поведение можно наблюдать через детали контейнера.
{{< gallery match="images/14/*.png" >}}
Я вызываю сервер wallabag с IP-адресом Synology и портом моего контейнера.
{{< gallery match="images/15/*.png" >}}
