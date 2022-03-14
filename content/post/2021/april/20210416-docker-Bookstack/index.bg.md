+++
date = "2021-04-16"
title = "Страхотни неща с контейнери: Вашият собствен Bookstack Wiki на Synology DiskStation"
difficulty = "level-1"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "bookstack", "wiki"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/april/20210416-docker-Bookstack/index.bg.md"
+++
Bookstack е алтернатива с отворен код на MediaWiki или Confluence. Днес ще покажа как да инсталирате услугата Bookstack на дисковата станция на Synology.
## Възможност за професионалисти
Като опитен потребител на Synology можете, разбира се, да влезете в системата с помощта на SSH и да инсталирате цялата инсталация чрез файла Docker Compose.
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
Още полезни образи на Docker за домашна употреба можете да намерите в [Dockerverse]({{< ref "dockerverse" >}} "Dockerverse").
## Стъпка 1: Подготвяне на папката за книгохранилище
Създавам нова директория, наречена "wiki", в директорията на Docker.
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
|TZ	| Europe/Berlin |Часова зона|
|MYSQL_ROOT_PASSWORD	|  my_wiki_pass |Главна парола на базата данни.|
|MYSQL_DATABASE | 	my_wiki	|Това е името на базата данни.|
|MYSQL_USER	|  wikiuser	|Потребителско име на базата данни на уикито.|
|MYSQL_PASSWORD	|  my_wiki_pass	|Парола на потребителя на базата данни wiki.|
{{</table>}}
Накрая въвеждам тези променливи на средата:Вижте:
{{< gallery match="images/6/*.png" >}}
След тези настройки сървърът Mariadb може да бъде стартиран! Навсякъде натискам "Приложи".
## Стъпка 3: Инсталиране на Bookstack
Кликвам върху раздела "Регистрация" в прозореца на Synology Docker и търся "bookstack". Избирам образа на Docker "solidnerd/bookstack" и след това щраквам върху етикета "latest".
{{< gallery match="images/7/*.png" >}}
Кликвам два пъти върху моето изображение в Bookstack. След това щраквам върху "Разширени настройки" и активирам "Автоматично рестартиране" и тук.
{{< gallery match="images/8/*.png" >}}
Присвоявам фиксирани портове за контейнера "bookstack". Без фиксирани портове може да се окаже, че "bookstack сървърът" работи на различен порт след рестартиране. Първият контейнерен порт може да бъде изтрит. Другото пристанище трябва да бъде запомнено.
{{< gallery match="images/9/*.png" >}}
Освен това все още трябва да се създаде "връзка" към контейнера "mariadb". Щраквам върху раздела "Връзки" и избирам контейнера за бази данни. Името на псевдонима трябва да се запомни за инсталацията на уикито.
{{< gallery match="images/10/*.png" >}}
{{<table "table table-striped table-bordered">}}
|Име на променливата|Стойност|Какво е то?|
|--- | --- |---|
|TZ	| Europe/Berlin |Часова зона|
|DB_HOST	| wiki-db:3306	|Имена на псевдоними / връзка с контейнер|
|DB_DATABASE	| my_wiki |Данни от стъпка 2|
|DB_USERNAME	| wikiuser |Данни от стъпка 2|
|DB_PASSWORD	| my_wiki_pass	|Данни от стъпка 2|
{{</table>}}
Накрая въвеждам тези променливи на средата:Вижте:
{{< gallery match="images/11/*.png" >}}
Контейнерът вече може да бъде стартиран. Създаването на базата данни може да отнеме известно време. Поведението може да бъде наблюдавано чрез данните за контейнера.
{{< gallery match="images/12/*.png" >}}
Извиквам сървъра на Bookstack с IP адреса на Synology и порта на контейнера. Името за вход е "admin@admin.com", а паролата - "password".
{{< gallery match="images/13/*.png" >}}
