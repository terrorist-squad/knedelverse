+++
date = "2021-04-16"
title = "Страхотни неща с контейнери: Инсталиране на собствена MediaWiki на дисковата станция на Synology"
difficulty = "level-1"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "mediawiki", "wiki"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210416-docker-MediaWiki/index.bg.md"
+++
MediaWiki е базирана на PHP система за уикита, която се предлага безплатно като продукт с отворен код. Днес ще покажа как да инсталирате услуга MediaWiki на дисковата станция на Synology.
## Възможност за професионалисти
Като опитен потребител на Synology можете, разбира се, да влезете в системата с помощта на SSH и да инсталирате цялата инсталация чрез файла Docker Compose.
```
version: '3'
services:
  mediawiki:
    image: mediawiki
    restart: always
    ports:
      - 8081:80
    links:
      - database
    volumes:
      - ./images:/var/www/html/images
      # After initial setup, download LocalSettings.php to the same directory as
      # this yaml and uncomment the following line and use compose to restart
      # the mediawiki service
      # - ./LocalSettings.php:/var/www/html/LocalSettings.php

  database:
    image: mariadb
    restart: always
    volumes:
       - ./mysql:/var/lib/mysql
    environment:
      # @see https://phabricator.wikimedia.org/source/mediawiki/browse/master/includes/DefaultSettings.php
      MYSQL_ROOT_PASSWORD: my_wiki_pass1
      MYSQL_DATABASE: my_wiki
      MYSQL_USER: wikiuser
      MYSQL_PASSWORD: my_wiki_pass

```
Още полезни образи на Docker за домашна употреба можете да намерите в [Dockerverse]({{< ref "dockerverse" >}} "Dockerverse").
## Стъпка 1: Подготовка на папката MediaWiki
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
|TZ	| Europe/Berlin	|Часова зона|
|MYSQL_ROOT_PASSWORD	| my_wiki_pass	|Главна парола на базата данни.|
|MYSQL_DATABASE |	my_wiki	|Това е името на базата данни.|
|MYSQL_USER	| wikiuser |Потребителско име на базата данни на уикито.|
|MYSQL_PASSWORD	| my_wiki_pass |Парола на потребителя на базата данни wiki.|
{{</table>}}
Накрая въвеждам тези променливи на средата:Вижте:
{{< gallery match="images/6/*.png" >}}
След тези настройки сървърът Mariadb може да бъде стартиран! Навсякъде натискам "Приложи".
## Стъпка 3: Инсталиране на MediaWiki
Кликвам върху раздела "Регистрация" в прозореца на Synology Docker и търся "mediawiki". Избирам образа на Docker "mediawiki" и след това щраквам върху етикета "latest".
{{< gallery match="images/7/*.png" >}}
Кликвам два пъти върху моето изображение в Mediawiki.
{{< gallery match="images/8/*.png" >}}
След това щраквам върху "Разширени настройки" и активирам "Автоматично рестартиране" и тук. Избирам раздела "Том" и щраквам върху "Добавяне на папка". Там създавам нова папка с този път за монтиране "/var/www/html/images".
{{< gallery match="images/9/*.png" >}}
Присвоявам фиксирани портове за контейнера "MediaWiki". При липса на фиксирани портове може да се окаже, че "сървърът на MediaWiki" работи на друг порт след рестартиране.
{{< gallery match="images/10/*.png" >}}
Освен това все още трябва да се създаде "връзка" към контейнера "mariadb". Щраквам върху раздела "Връзки" и избирам контейнера за бази данни. Името на псевдонима трябва да се запомни за инсталацията на уикито.
{{< gallery match="images/11/*.png" >}}
Накрая въвеждам променлива на средата "TZ" със стойност "Europe/Berlin".
{{< gallery match="images/12/*.png" >}}
Контейнерът вече може да бъде стартиран. Извиквам сървъра Mediawiki с IP адреса на Synology и порта на контейнера. В полето Database server (Сървър за бази данни) въвеждам псевдонима на контейнера за бази данни. Въвеждам също така името на базата данни, потребителското име и паролата от "Стъпка 2".
{{< gallery match="images/13/*.png" >}}