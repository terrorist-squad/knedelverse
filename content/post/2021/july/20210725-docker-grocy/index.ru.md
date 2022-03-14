+++
date = "2021-07-25"
title = "Великие дела с контейнерами: управление холодильником с помощью Grocy"
difficulty = "level-1"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "kühlschrank", "erp", "mhd", "Speispläne", "cms", "Cafe", "Bistro"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/july/20210725-docker-grocy/index.ru.md"
+++
С помощью Grocy вы можете управлять целым хозяйством, рестораном, кафе, бистро или продовольственным рынком. Вы можете управлять холодильниками, меню, задачами, списками покупок и сроками годности продуктов.
{{< gallery match="images/1/*.png" >}}
Сегодня я покажу, как установить службу Grocy на дисковую станцию Synology.
## Вариант для профессионалов
Как опытный пользователь Synology, вы, конечно, можете войти в систему с помощью SSH и установить всю установку через файл Docker Compose.
```
version: "2.1"
services:
  grocy:
    image: ghcr.io/linuxserver/grocy
    container_name: grocy
    environment:
      - PUID=1024
      - PGID=100
      - TZ=Europe/Berlin
    volumes:
      - ./data:/config
    ports:
      - 9283:80
    restart: unless-stopped

```
Более полезные образы Docker для домашнего использования можно найти в [Dockerverse]({{< ref "dockerverse" >}} "Dockerverse").
## Шаг 1: Подготовьте папку Grocy
Я создаю новый каталог под названием "grocy" в каталоге Docker.
{{< gallery match="images/2/*.png" >}}

## Шаг 2: Установите Grocy
Я перехожу на вкладку "Регистрация" в окне Synology Docker и ищу "Grocy". Я выбираю образ Docker "linuxserver/grocy:latest", а затем нажимаю на тег "latest".
{{< gallery match="images/3/*.png" >}}
Я дважды щелкаю по своему изображению Grocy.
{{< gallery match="images/4/*.png" >}}
Затем я нажимаю на "Дополнительные настройки" и активирую "Автоматический перезапуск" здесь же. Я выбираю вкладку "Том" и нажимаю "Добавить папку". Там я создаю новую папку с таким путем монтирования "/config".
{{< gallery match="images/5/*.png" >}}
Я назначаю фиксированные порты для контейнера "Grocy". При отсутствии фиксированных портов может оказаться, что после перезапуска "сервер Grocy" работает на другом порту.
{{< gallery match="images/6/*.png" >}}
{{<table "table table-striped table-bordered">}}
|Имя переменной|Значение|Что это такое?|
|--- | --- |---|
|TZ | Europe/Berlin |Часовой пояс|
|PUID | 1024 |Идентификатор пользователя Synology Admin User|
|PGID |	100 |Идентификатор группы от пользователя Synology Admin|
{{</table>}}
Наконец, я ввожу эти переменные окружения:См:
{{< gallery match="images/7/*.png" >}}
Теперь контейнер можно запустить. Я вызываю сервер Grocy с IP-адресом Synology и портом моего контейнера и вхожу в систему с именем пользователя "admin" и паролем "admin".
{{< gallery match="images/8/*.png" >}}
