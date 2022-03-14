+++
date = "2021-04-18"
title = "Страхотни неща с контейнери: Собствена чанта WallaBag на дисковата станция на Synology"
difficulty = "level-1"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "archiv", "wallabag"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210418-docker-WallaBag/index.bg.md"
+++
Wallabag е програма за архивиране на интересни уебсайтове или статии. Днес показвам как да инсталирате услугата Wallabag на дисковата станция на Synology.
## Възможност за професионалисти
Като опитен потребител на Synology можете, разбира се, да влезете в системата с помощта на SSH и да инсталирате цялата инсталация чрез файла Docker Compose.
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
Още полезни образи на Docker за домашна употреба можете да намерите в [Dockerverse]({{< ref "dockerverse" >}} "Dockerverse").
## Стъпка 1: Подгответе папката за чантата
Създавам нова директория, наречена "wallabag", в директорията на Docker.
{{< gallery match="images/1/*.png" >}}

## Стъпка 2: Инсталиране на базата данни
След това трябва да се създаде база данни. Кликвам върху раздела "Регистрация" в прозореца на Synology Docker и търся "mariadb". Избирам образа на Docker "mariadb" и след това щраквам върху етикета "latest".
{{< gallery match="images/2/*.png" >}}
След изтеглянето на изображението то е достъпно като изображение. Docker прави разлика между 2 състояния - контейнер "динамично състояние" и образ (фиксирано състояние). Преди да създадем контейнер от образа, трябва да се направят няколко настройки. Кликвам два пъти върху моя образ mariadb.
{{< gallery match="images/3/*.png" >}}
След това щракнах върху "Разширени настройки" и активирах "Автоматично рестартиране". Избирам раздела "Том" и щраквам върху "Добавяне на папка". Там създавам нова папка с база данни с този път за монтиране "/var/lib/mysql".
{{< gallery match="images/4/*.png" >}}
В раздел "Настройки на портовете" се изтриват всички портове. Това означава, че избирам порта "3306" и го изтривам с бутона "-".
{{< gallery match="images/5/*.png" >}}
{{<table "table table-striped table-bordered">}}
|Име на променливата|Стойност|Какво е то?|
|--- | --- |---|
|TZ| Europe/Berlin	|Часова зона|
|MYSQL_ROOT_PASSWORD	 | wallaroot |Главна парола на базата данни.|
{{</table>}}
Накрая въвеждам тези променливи на средата:Вижте:
{{< gallery match="images/6/*.png" >}}
След тези настройки сървърът Mariadb може да бъде стартиран! Навсякъде натискам "Приложи".
{{< gallery match="images/7/*.png" >}}

## Стъпка 3: Инсталиране на Wallabag
Кликвам върху раздела "Регистрация" в прозореца Synology Docker и търся "wallabag". Избирам образа на Docker "wallabag/wallabag" и след това щраквам върху етикета "latest".
{{< gallery match="images/8/*.png" >}}
Кликвам два пъти върху изображението на моята чанта. След това щраквам върху "Разширени настройки" и активирам "Автоматично рестартиране" и тук.
{{< gallery match="images/9/*.png" >}}
Избирам раздела "Том" и щраквам върху "Добавяне на папка". Там създавам нова папка с този път за монтиране "/var/www/wallabag/web/assets/images".
{{< gallery match="images/10/*.png" >}}
Определям фиксирани портове за контейнера "wallabag". Без фиксирани портове може да се окаже, че "сървърът на wallabag" работи на друг порт след рестартиране. Първият контейнерен порт може да бъде изтрит. Другото пристанище трябва да бъде запомнено.
{{< gallery match="images/11/*.png" >}}
Освен това все още трябва да се създаде "връзка" към контейнера "mariadb". Щраквам върху раздела "Връзки" и избирам контейнера за бази данни. Името на псевдонима трябва да се запомни за инсталацията на wallabag.
{{< gallery match="images/12/*.png" >}}
{{<table "table table-striped table-bordered">}}
|Umgebungsvariable	|Стойност|
|--- |---|
|MYSQL_ROOT_PASSWORD	|wallaroot|
|SYMFONY__ENV__DATABASE_DRIVER	|pdo_mysql|
|SYMFONY__ENV__DATABASE_HOST	|db|
|SYMFONY__ENV__DATABASE_PORT	|3306|
|SYMFONY__ENV__DATABASE_NAME	|wallabag|
|SYMFONY__ENV__DATABASE_USER	|wallabag|
|SYMFONY__ENV__DATABASE_PASSWORD	|wallapass|
|SYMFONY__ENV__DATABASE_CHARSET |utf8mb4|
|SYMFONY__ENV__DOMAIN_NAME	|"http://synology-ip:container-port" <- Моля, променете|
|SYMFONY__ENV__SERVER_NAME	|"Wallabag - Сървър"|
|SYMFONY__ENV__FOSUSER_CONFIRMATION	|фалшив|
|SYMFONY__ENV__TWOFACTOR_AUTH	|фалшив|
{{</table>}}
Накрая въвеждам тези променливи на средата:Вижте:
{{< gallery match="images/13/*.png" >}}
Контейнерът вече може да бъде стартиран. Създаването на базата данни може да отнеме известно време. Поведението може да бъде наблюдавано чрез данните за контейнера.
{{< gallery match="images/14/*.png" >}}
Обаждам се на сървъра wallabag с IP адреса на Synology и порта на контейнера.
{{< gallery match="images/15/*.png" >}}
