+++
date = "2021-04-16"
title = "Страхотни неща с контейнери: Инсталиране на Wiki.js на Synology Diskstation"
difficulty = "level-1"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "wikijs", "wiki"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/april/20210416-docker-Wikijs/index.bg.md"
+++
Wiki.js е мощен софтуер с отворен код за уикита, който прави документирането удоволствие със своя прост интерфейс. Днес ще покажа как да инсталирате услугата Wiki.js на Synology DiskStation.
## Възможност за професионалисти
Като опитен потребител на Synology можете, разбира се, да влезете в системата с помощта на SSH и да инсталирате цялата инсталация чрез файла Docker Compose.
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
Можете да намерите още полезни образи на Docker за домашна употреба в Dockerverse.
## Стъпка 1: Подготвяне на папката wiki
Създавам нова директория, наречена "wiki", в директорията на Docker.
{{< gallery match="images/1/*.png" >}}

## Стъпка 2: Инсталиране на базата данни
След това трябва да се създаде база данни. Кликвам върху раздела "Регистрация" в прозореца на Synology Docker и търся "mysql". Избирам образа на Docker "mysql" и след това щраквам върху етикета "latest".
{{< gallery match="images/2/*.png" >}}
След изтеглянето на изображението то е достъпно като изображение. Docker прави разлика между 2 състояния - контейнер "динамично състояние" и образ (фиксирано състояние). Преди да създадем контейнер от образа, трябва да се направят няколко настройки. Кликвам два пъти върху моя образ mysql.
{{< gallery match="images/3/*.png" >}}
След това щракнах върху "Разширени настройки" и активирах "Автоматично рестартиране". Избирам раздела "Том" и щраквам върху "Добавяне на папка". Там създавам нова папка с база данни с този път за монтиране "/var/lib/mysql".
{{< gallery match="images/4/*.png" >}}
В раздел "Настройки на портовете" се изтриват всички портове. Това означава, че избирам порта "3306" и го изтривам с бутона "-".
{{< gallery match="images/5/*.png" >}}
{{<table "table table-striped table-bordered">}}
|Име на променливата|Стойност|Какво е то?|
|--- | --- |---|
|TZ	| Europe/Berlin |Часова зона|
|MYSQL_ROOT_PASSWORD	| my_wiki_pass |Главна парола на базата данни.|
|MYSQL_DATABASE |	my_wiki |Това е името на базата данни.|
|MYSQL_USER	| wikiuser |Потребителско име на базата данни на уикито.|
|MYSQL_PASSWORD |	my_wiki_pass	|Парола на потребителя на базата данни wiki.|
{{</table>}}
Накрая въвеждам тези четири променливи на средата:Вижте:
{{< gallery match="images/6/*.png" >}}
След тези настройки сървърът Mariadb може да бъде стартиран! Навсякъде натискам "Приложи".
## Стъпка 3: Инсталиране на Wiki.js
Кликвам върху раздела "Регистрация" в прозореца на Synology Docker и търся "wiki". Избирам образа на Docker "requarks/wiki" и след това щраквам върху етикета "latest".
{{< gallery match="images/7/*.png" >}}
Кликвам два пъти върху моето изображение в WikiJS. След това щраквам върху "Разширени настройки" и активирам "Автоматично рестартиране" и тук.
{{< gallery match="images/8/*.png" >}}
Определям фиксирани портове за контейнера "WikiJS". Без фиксирани портове може да се окаже, че "bookstack сървърът" работи на различен порт след рестартиране.
{{< gallery match="images/9/*.png" >}}
Освен това трябва да се създаде "връзка" към контейнера "mysql". Щраквам върху раздела "Връзки" и избирам контейнера за бази данни. Името на псевдонима трябва да се запомни за инсталацията на уикито.
{{< gallery match="images/10/*.png" >}}
{{<table "table table-striped table-bordered">}}
|Име на променливата|Стойност|Какво е то?|
|--- | --- |---|
|TZ	| Europe/Berlin	|Часова зона|
|DB_HOST	| wiki-db	|Имена на псевдоними / връзка с контейнер|
|DB_TYPE	| mysql	||
|DB_PORT	| 3306	 ||
|DB_PASSWORD	| my_wiki	|Данни от стъпка 2|
|DB_USER	| wikiuser |Данни от стъпка 2|
|DB_PASS	| my_wiki_pass	|Данни от стъпка 2|
{{</table>}}
Накрая въвеждам тези променливи на средата:Вижте:
{{< gallery match="images/11/*.png" >}}
Контейнерът вече може да бъде стартиран. Извиквам сървъра Wiki.js с IP адреса на Synology и порта на контейнера/3000.
{{< gallery match="images/12/*.png" >}}