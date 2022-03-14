+++
date = "2021-04-16"
title = "Великие дела с контейнерами: собственный Bookstack Wiki на Synology DiskStation"
difficulty = "level-1"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "bookstack", "wiki"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210416-docker-Bookstack/index.ru.md"
+++
Bookstack - это альтернатива MediaWiki или Confluence с "открытым исходным кодом". Сегодня я покажу, как установить службу Bookstack на дисковую станцию Synology.
## Вариант для профессионалов
Как опытный пользователь Synology, вы, конечно, можете войти в систему с помощью SSH и установить всю установку через файл Docker Compose.
```
version: '3'
services:
  bookstack:
    image: solidnerd/bookstack:0.27.4-1
    restart: always
    ports:
      - 8080:8080
    links:
      - database
    environment:
      DB_HOST: database:3306
      DB_DATABASE: my_wiki
      DB_USERNAME: wikiuser
      DB_PASSWORD: my_wiki_pass
      
  database:
    image: mariadb
    restart: always
    volumes:
       - ./mysql:/var/lib/mysql
    environment:
      MYSQL_ROOT_PASSWORD: my_wiki_pass1
      MYSQL_DATABASE: my_wiki
      MYSQL_USER: wikiuser
      MYSQL_PASSWORD: my_wiki_pass

```
Более полезные образы Docker для домашнего использования можно найти в [Dockerverse]({{< ref "dockerverse" >}} "Dockerverse").
## Шаг 1: Подготовьте папку для книжных стопок
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
|TZ	| Europe/Berlin |Часовой пояс|
|MYSQL_ROOT_PASSWORD	|  my_wiki_pass |Главный пароль базы данных.|
|MYSQL_DATABASE | 	my_wiki	|Это имя базы данных.|
|MYSQL_USER	|  wikiuser	|Имя пользователя базы данных вики.|
|MYSQL_PASSWORD	|  my_wiki_pass	|Пароль пользователя базы данных wiki.|
{{</table>}}
Наконец, я ввожу эти переменные окружения:См:
{{< gallery match="images/6/*.png" >}}
После этих настроек сервер Mariadb может быть запущен! Я везде нажимаю "Применить".
## Шаг 3: Установите Bookstack
Я перехожу на вкладку "Регистрация" в окне Synology Docker и ищу "bookstack". Я выбираю образ Docker "solidnerd/bookstack", а затем нажимаю на метку "latest".
{{< gallery match="images/7/*.png" >}}
Я дважды щелкаю на своем изображении Bookstack. Затем я нажимаю на "Дополнительные настройки" и активирую "Автоматический перезапуск" здесь же.
{{< gallery match="images/8/*.png" >}}
Я назначаю фиксированные порты для контейнера "bookstack". При отсутствии фиксированных портов может оказаться, что после перезапуска "сервер bookstack" работает на другом порту. Первый контейнерный порт может быть удален. Следует помнить о другом порте.
{{< gallery match="images/9/*.png" >}}
Кроме того, необходимо создать "ссылку" на контейнер "mariadb". Я перехожу на вкладку "Ссылки" и выбираю контейнер базы данных. Имя псевдонима должно быть запомнено для установки вики.
{{< gallery match="images/10/*.png" >}}
{{<table "table table-striped table-bordered">}}
|Имя переменной|Значение|Что это такое?|
|--- | --- |---|
|TZ	| Europe/Berlin |Часовой пояс|
|DB_HOST	| wiki-db:3306	|Псевдонимы / ссылка на контейнер|
|DB_DATABASE	| my_wiki |Данные из шага 2|
|DB_USERNAME	| wikiuser |Данные из шага 2|
|DB_PASSWORD	| my_wiki_pass	|Данные из шага 2|
{{</table>}}
Наконец, я ввожу эти переменные окружения:См:
{{< gallery match="images/11/*.png" >}}
Теперь контейнер можно запустить. Создание базы данных может занять некоторое время. Поведение можно наблюдать через детали контейнера.
{{< gallery match="images/12/*.png" >}}
Я вызываю сервер Bookstack с IP-адресом Synology и портом моего контейнера. Имя для входа в систему - "admin@admin.com", а пароль - "password".
{{< gallery match="images/13/*.png" >}}
