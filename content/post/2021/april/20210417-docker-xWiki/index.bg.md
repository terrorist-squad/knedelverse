+++
date = "2021-04-17"
title = "Страхотни неща с контейнери: стартиране на собствена xWiki на дисковата станция на Synology"
difficulty = "level-1"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "xwiki", "wiki",]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210417-docker-xWiki/index.bg.md"
+++
XWiki е безплатна софтуерна платформа за уикита, написана на Java и проектирана с оглед на разширяемостта. Днес ще покажа как да инсталирате услугата xWiki на Synology DiskStation.
## Възможност за професионалисти
Като опитен потребител на Synology можете, разбира се, да влезете в системата с помощта на SSH и да инсталирате цялата инсталация чрез файла Docker Compose.
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
Още полезни образи на Docker за домашна употреба можете да намерите в [Dockerverse]({{< ref "dockerverse" >}} "Dockerverse").
## Стъпка 1: Подготвяне на папката wiki
Създавам нова директория, наречена "wiki", в директорията на Docker.
{{< gallery match="images/1/*.png" >}}

## Стъпка 2: Инсталиране на базата данни
След това трябва да се създаде база данни. Кликвам върху раздела "Регистрация" в прозореца на Synology Docker и търся "postgres". Избирам образа на Docker "postgres" и след това щраквам върху етикета "latest".
{{< gallery match="images/2/*.png" >}}
След изтеглянето на изображението то е достъпно като изображение. Docker прави разлика между 2 състояния - контейнер "динамично състояние" и образ (фиксирано състояние). Преди да създадем контейнер от изображението, трябва да се направят няколко настройки. Кликвам два пъти върху моето изображение postgres.
{{< gallery match="images/3/*.png" >}}
След това щракнах върху "Разширени настройки" и активирах "Автоматично рестартиране". Избирам раздела "Обем" и щраквам върху "Добавяне на папка". Там създавам нова папка с база данни с този път за монтиране "/var/lib/postgresql/data".
{{< gallery match="images/4/*.png" >}}
В раздел "Настройки на портовете" се изтриват всички портове. Това означава, че избирам порта "5432" и го изтривам с бутона "-".
{{< gallery match="images/5/*.png" >}}
{{<table "table table-striped table-bordered">}}
|Име на променливата|Стойност|Какво е то?|
|--- | --- |---|
|TZ	| Europe/Berlin	|Часова зона|
|POSTGRES_DB	| xwiki |Това е името на базата данни.|
|POSTGRES_USER	| xwiki |Потребителско име на базата данни на уикито.|
|POSTGRES_PASSWORD	| xwiki |Парола на потребителя на базата данни wiki.|
{{</table>}}
Накрая въвеждам тези четири променливи на средата:Вижте:
{{< gallery match="images/6/*.png" >}}
След тези настройки сървърът Mariadb може да бъде стартиран! Навсякъде натискам "Приложи".
## Стъпка 3: Инсталиране на xWiki
Кликвам върху раздела "Регистрация" в прозореца на Synology Docker и търся "xwiki". Избирам образа на Docker "xwiki" и след това щраквам върху етикета "10-postgres-tomcat".
{{< gallery match="images/7/*.png" >}}
Кликвам два пъти върху моето изображение в xwiki. След това щраквам върху "Разширени настройки" и активирам "Автоматично рестартиране" и тук.
{{< gallery match="images/8/*.png" >}}
Присвоявам фиксирани портове за контейнера "xwiki". При липса на фиксирани портове може да се окаже, че след рестартиране "сървърът xwiki" работи на друг порт.
{{< gallery match="images/9/*.png" >}}
Освен това трябва да се създаде "връзка" към контейнера "postgres". Щраквам върху раздела "Връзки" и избирам контейнера за бази данни. Името на псевдонима трябва да се запомни за инсталацията на уикито.
{{< gallery match="images/10/*.png" >}}
{{<table "table table-striped table-bordered">}}
|Име на променливата|Стойност|Какво е то?|
|--- | --- |---|
|TZ |	Europe/Berlin	|Часова зона|
|DB_HOST	| db |Имена на псевдоними / връзка с контейнер|
|DB_DATABASE	| xwiki	|Данни от стъпка 2|
|DB_USER	| xwiki	|Данни от стъпка 2|
|DB_PASSWORD	| xwiki |Данни от стъпка 2|
{{</table>}}
Накрая въвеждам тези променливи на средата:Вижте:
{{< gallery match="images/11/*.png" >}}
Контейнерът вече може да бъде стартиран. Извиквам сървъра xWiki с IP адреса на Synology и порта на контейнера.
{{< gallery match="images/12/*.png" >}}