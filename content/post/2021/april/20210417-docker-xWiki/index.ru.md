+++
date = "2021-04-17"
title = "Великие дела с контейнерами: Запуск собственной xWiki на дисковой станции Synology"
difficulty = "level-1"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "xwiki", "wiki",]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/april/20210417-docker-xWiki/index.ru.md"
+++
XWiki - это свободная программная платформа вики, написанная на Java и разработанная с учетом расширяемости. Сегодня я покажу, как установить службу xWiki на Synology DiskStation.
## Вариант для профессионалов
Как опытный пользователь Synology, вы, конечно, можете войти в систему с помощью SSH и установить всю установку через файл Docker Compose.
```
version: '3'
services:
  xwiki:
    image: xwiki:10-postgres-tomcat
    restart: always
    ports:
      - 8080:8080
    links:
      - db
    environment:
      DB_HOST: db
      DB_DATABASE: xwiki
      DB_DATABASE: xwiki
      DB_PASSWORD: xwiki
      TZ: 'Europe/Berlin'

  db:
    image: postgres:latest
    restart: always
    volumes:
      - ./postgresql:/var/lib/postgresql/data
    environment:
      - POSTGRES_USER=xwiki
      - POSTGRES_PASSWORD=xwiki
      - POSTGRES_DB=xwiki
      - TZ='Europe/Berlin'

```
Более полезные образы Docker для домашнего использования можно найти в [Dockerverse]({{< ref "dockerverse" >}} "Dockerverse").
## Шаг 1: Подготовьте папку wiki
Я создаю новый каталог под названием "wiki" в каталоге Docker.
{{< gallery match="images/1/*.png" >}}

## Шаг 2: Установите базу данных
После этого необходимо создать базу данных. Я перехожу на вкладку "Регистрация" в окне Synology Docker и ищу "postgres". Я выбираю образ Docker "postgres", а затем нажимаю на метку "latest".
{{< gallery match="images/2/*.png" >}}
После загрузки изображения оно доступно в виде рисунка. Docker различает 2 состояния: контейнер - "динамическое состояние" и образ (фиксированное состояние). Прежде чем мы создадим контейнер из образа, необходимо выполнить несколько настроек. Я дважды щелкаю на моем образе postgres.
{{< gallery match="images/3/*.png" >}}
Затем я нажимаю на "Дополнительные настройки" и активирую "Автоматический перезапуск". Я выбираю вкладку "Том" и нажимаю "Добавить папку". Там я создаю новую папку базы данных с таким путем монтирования "/var/lib/postgresql/data".
{{< gallery match="images/4/*.png" >}}
В разделе "Настройки порта" все порты удалены. Это означает, что я выбираю порт "5432" и удаляю его с помощью кнопки "-".
{{< gallery match="images/5/*.png" >}}
{{<table "table table-striped table-bordered">}}
|Имя переменной|Значение|Что это такое?|
|--- | --- |---|
|TZ	| Europe/Berlin	|Часовой пояс|
|POSTGRES_DB	| xwiki |Это имя базы данных.|
|POSTGRES_USER	| xwiki |Имя пользователя базы данных вики.|
|POSTGRES_PASSWORD	| xwiki |Пароль пользователя базы данных wiki.|
{{</table>}}
Наконец, я ввожу эти четыре переменные окружения:См:
{{< gallery match="images/6/*.png" >}}
После этих настроек сервер Mariadb может быть запущен! Я везде нажимаю "Применить".
## Шаг 3: Установите xWiki
Я перехожу на вкладку "Регистрация" в окне Synology Docker и ищу "xwiki". Я выбираю образ Docker "xwiki", а затем нажимаю на тег "10-postgres-tomcat".
{{< gallery match="images/7/*.png" >}}
Я дважды щелкаю на своем изображении xwiki. Затем я нажимаю на "Дополнительные настройки" и активирую "Автоматический перезапуск" здесь же.
{{< gallery match="images/8/*.png" >}}
Я назначаю фиксированные порты для контейнера "xwiki". Без фиксированных портов может оказаться, что после перезапуска "сервер xwiki" работает на другом порту.
{{< gallery match="images/9/*.png" >}}
Кроме того, необходимо создать "ссылку" на контейнер "postgres". Я перехожу на вкладку "Ссылки" и выбираю контейнер базы данных. Имя псевдонима должно быть запомнено для установки вики.
{{< gallery match="images/10/*.png" >}}
{{<table "table table-striped table-bordered">}}
|Имя переменной|Значение|Что это такое?|
|--- | --- |---|
|TZ |	Europe/Berlin	|Часовой пояс|
|DB_HOST	| db |Псевдонимы / ссылка на контейнер|
|DB_DATABASE	| xwiki	|Данные из шага 2|
|DB_USER	| xwiki	|Данные из шага 2|
|DB_PASSWORD	| xwiki |Данные из шага 2|
{{</table>}}
Наконец, я ввожу эти переменные окружения:См:
{{< gallery match="images/11/*.png" >}}
Теперь контейнер можно запустить. Я вызываю сервер xWiki с IP-адресом Synology и портом моего контейнера.
{{< gallery match="images/12/*.png" >}}