+++
date = "2021-04-16"
title = "Великие дела с контейнерами: установка Wiki.js на Synology Diskstation"
difficulty = "level-1"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "wikijs", "wiki"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210416-docker-Wikijs/index.ru.md"
+++
Wiki.js - это мощное программное обеспечение для вики с открытым исходным кодом, которое превращает документирование в удовольствие благодаря простому интерфейсу. Сегодня я покажу, как установить службу Wiki.js на Synology DiskStation.
## Вариант для профессионалов
Как опытный пользователь Synology, вы, конечно, можете войти в систему с помощью SSH и установить всю установку через файл Docker Compose.
```
version: '3'
services:
  wikijs:
    image: requarks/wiki:latest
    restart: always
    ports:
      - 8082:3000
    links:
      - database
    environment:
      DB_TYPE: mysql
      DB_HOST: database
      DB_PORT: 3306
      DB_NAME: my_wiki
      DB_USER: wikiuser
      DB_PASS: my_wiki_pass
      TZ: 'Europe/Berlin'

  database:
    image: mysql
    restart: always
    expose:
      - 3306
    volumes:
       - ./mysql:/var/lib/mysql
    environment:
      MYSQL_ROOT_PASSWORD: my_wiki_pass
      MYSQL_DATABASE: my_wiki
      MYSQL_USER: wikiuser
      MYSQL_PASSWORD: my_wiki_pass

```
Вы можете найти больше полезных образов Docker для домашнего использования в Dockerverse.
## Шаг 1: Подготовьте папку wiki
Я создаю новый каталог под названием "wiki" в каталоге Docker.
{{< gallery match="images/1/*.png" >}}

## Шаг 2: Установите базу данных
После этого необходимо создать базу данных. Я перехожу на вкладку "Регистрация" в окне Synology Docker и ищу "mysql". Я выбираю образ Docker "mysql", а затем нажимаю на метку "latest".
{{< gallery match="images/2/*.png" >}}
После загрузки изображения оно доступно в виде рисунка. Docker различает 2 состояния, контейнер - "динамическое состояние" и образ (фиксированное состояние). Прежде чем мы создадим контейнер из образа, необходимо выполнить несколько настроек. Я дважды щелкаю на моем образе mysql.
{{< gallery match="images/3/*.png" >}}
Затем я нажимаю на "Дополнительные настройки" и активирую "Автоматический перезапуск". Я выбираю вкладку "Том" и нажимаю "Добавить папку". Там я создаю новую папку базы данных с таким путем монтирования "/var/lib/mysql".
{{< gallery match="images/4/*.png" >}}
В разделе "Настройки порта" все порты удалены. Это означает, что я выбираю порт "3306" и удаляю его с помощью кнопки "-".
{{< gallery match="images/5/*.png" >}}
{{<table "table table-striped table-bordered">}}
|Имя переменной|Значение|Что это такое?|
|--- | --- |---|
|TZ	| Europe/Berlin |Часовой пояс|
|MYSQL_ROOT_PASSWORD	| my_wiki_pass |Главный пароль базы данных.|
|MYSQL_DATABASE |	my_wiki |Это имя базы данных.|
|MYSQL_USER	| wikiuser |Имя пользователя базы данных вики.|
|MYSQL_PASSWORD |	my_wiki_pass	|Пароль пользователя базы данных wiki.|
{{</table>}}
Наконец, я ввожу эти четыре переменные окружения:См:
{{< gallery match="images/6/*.png" >}}
После этих настроек сервер Mariadb может быть запущен! Я везде нажимаю "Применить".
## Шаг 3: Установите Wiki.js
Я перехожу на вкладку "Регистрация" в окне Synology Docker и ищу "wiki". Я выбираю образ Docker "requarks/wiki" и затем нажимаю на тег "latest".
{{< gallery match="images/7/*.png" >}}
Я дважды щелкаю на своем изображении WikiJS. Затем я нажимаю на "Дополнительные настройки" и активирую "Автоматический перезапуск" здесь же.
{{< gallery match="images/8/*.png" >}}
Я назначаю фиксированные порты для контейнера "WikiJS". При отсутствии фиксированных портов может оказаться, что после перезапуска "сервер bookstack" работает на другом порту.
{{< gallery match="images/9/*.png" >}}
Кроме того, необходимо создать "ссылку" на контейнер "mysql". Я перехожу на вкладку "Ссылки" и выбираю контейнер базы данных. Имя псевдонима должно быть запомнено для установки вики.
{{< gallery match="images/10/*.png" >}}
{{<table "table table-striped table-bordered">}}
|Имя переменной|Значение|Что это такое?|
|--- | --- |---|
|TZ	| Europe/Berlin	|Часовой пояс|
|DB_HOST	| wiki-db	|Псевдонимы / ссылка на контейнер|
|DB_TYPE	| mysql	||
|DB_PORT	| 3306	 ||
|DB_PASSWORD	| my_wiki	|Данные из шага 2|
|DB_USER	| wikiuser |Данные из шага 2|
|DB_PASS	| my_wiki_pass	|Данные из шага 2|
{{</table>}}
Наконец, я ввожу эти переменные окружения:См:
{{< gallery match="images/11/*.png" >}}
Теперь контейнер можно запустить. Я вызываю сервер Wiki.js с IP-адресом Synology и портом контейнера/3000.
{{< gallery match="images/12/*.png" >}}