+++
date = "2021-04-18"
title = "Великие дела с контейнерами: установка собственной dokuWiki на дисковую станцию Synology"
difficulty = "level-2"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "dokuwiki", "wiki"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210418-docker-dokuWiki/index.ru.md"
+++
DokuWiki - это соответствующее стандартам, простое в использовании и в то же время чрезвычайно многофункциональное программное обеспечение с открытым исходным кодом для создания вики. Сегодня я покажу, как установить службу DokuWiki на дисковую станцию Synology.
## Вариант для профессионалов
Как опытный пользователь Synology, вы, конечно, можете войти в систему с помощью SSH и установить всю установку через файл Docker Compose.
```
version: '3'
services:
  dokuwiki:
    image:  bitnami/dokuwiki:latest
    restart: always
    ports:
      - 8080:8080
      - 8443:8443
    environment:
      TZ: 'Europe/Berlin'
      DOKUWIKI_USERNAME: 'admin'
      DOKUWIKI_FULL_NAME: 'wiki'
      DOKUWIKI_PASSWORD: 'password'
    volumes:
      - ./data:/bitnami/dokuwiki

```
Более полезные образы Docker для домашнего использования можно найти в [Dockerverse]({{< ref "dockerverse" >}} "Dockerverse").
## Шаг 1: Подготовьте папку wiki
Я создаю новый каталог под названием "wiki" в каталоге Docker.
{{< gallery match="images/1/*.png" >}}

## Шаг 2: Установите DokuWiki
После этого необходимо создать базу данных. Я перехожу на вкладку "Регистрация" в окне Synology Docker и ищу "dokuwiki". Я выбираю образ Docker "bitnami/dokuwiki" и затем нажимаю на тег "latest".
{{< gallery match="images/2/*.png" >}}
После загрузки изображения оно доступно в виде рисунка. Docker различает 2 состояния: контейнер - "динамическое состояние" и образ (фиксированное состояние). Прежде чем мы создадим контейнер из образа, необходимо выполнить несколько настроек. Я дважды щелкаю на моем образе dokuwiki.
{{< gallery match="images/3/*.png" >}}
Я назначаю фиксированные порты для контейнера "dokuwiki". Без фиксированных портов может оказаться, что после перезапуска "сервер dokuwiki" работает на другом порту.
{{< gallery match="images/4/*.png" >}}
{{<table "table table-striped table-bordered">}}
|Имя переменной|Значение|Что это такое?|
|--- | --- |---|
|TZ	| Europe/Berlin	|Часовой пояс|
|DOKUWIKI_USERNAME	| admin|Имя пользователя администратора|
|DOKUWIKI_FULL_NAME |	wiki	|Название WIki|
|DOKUWIKI_PASSWORD	| password	|Пароль администратора|
{{</table>}}
Наконец, я ввожу эти переменные окружения:См:
{{< gallery match="images/5/*.png" >}}
Теперь контейнер можно запустить. Я вызываю сервер dokuWIki с IP-адресом Synology и портом моего контейнера.
{{< gallery match="images/6/*.png" >}}
