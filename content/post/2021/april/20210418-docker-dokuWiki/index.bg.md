+++
date = "2021-04-18"
title = "Страхотни неща с контейнери: Инсталиране на собствен dokuWiki на дисковата станция на Synology"
difficulty = "level-2"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "dokuwiki", "wiki"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210418-docker-dokuWiki/index.bg.md"
+++
DokuWiki е съвместим със стандартите, лесен за използване и в същото време изключително гъвкав софтуер с отворен код за уикита. Днес ще покажа как да инсталирате услугата DokuWiki на дисковата станция на Synology.
## Възможност за професионалисти
Като опитен потребител на Synology можете, разбира се, да влезете в системата с помощта на SSH и да инсталирате цялата инсталация чрез файла Docker Compose.
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
Още полезни образи на Docker за домашна употреба можете да намерите в [Dockerverse]({{< ref "dockerverse" >}} "Dockerverse").
## Стъпка 1: Подготвяне на папката wiki
Създавам нова директория, наречена "wiki", в директорията на Docker.
{{< gallery match="images/1/*.png" >}}

## Стъпка 2: Инсталиране на DokuWiki
След това трябва да се създаде база данни. Кликвам върху раздела "Регистрация" в прозореца на Synology Docker и търся "dokuwiki". Избирам образа на Docker "bitnami/dokuwiki" и след това щраквам върху етикета "latest".
{{< gallery match="images/2/*.png" >}}
След изтеглянето на изображението то е достъпно като изображение. Docker прави разлика между 2 състояния - контейнер "динамично състояние" и образ (фиксирано състояние). Преди да създадем контейнер от изображението, трябва да се направят няколко настройки. Щраквам два пъти върху моето изображение dokuwiki.
{{< gallery match="images/3/*.png" >}}
Присвоявам фиксирани портове за контейнера "dokuwiki". Без фиксирани портове може да се окаже, че след рестартиране "сървърът dokuwiki" работи на друг порт.
{{< gallery match="images/4/*.png" >}}
{{<table "table table-striped table-bordered">}}
|Име на променливата|Стойност|Какво е то?|
|--- | --- |---|
|TZ	| Europe/Berlin	|Часова зона|
|DOKUWIKI_USERNAME	| admin|Потребителско име на администратора|
|DOKUWIKI_FULL_NAME |	wiki	|Име WIki|
|DOKUWIKI_PASSWORD	| password	|Парола на администратора|
{{</table>}}
Накрая въвеждам тези променливи на средата:Вижте:
{{< gallery match="images/5/*.png" >}}
Контейнерът вече може да бъде стартиран. Извиквам сървъра dokuWIki с IP адреса на Synology и порта на контейнера.
{{< gallery match="images/6/*.png" >}}
