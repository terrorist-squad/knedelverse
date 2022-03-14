+++
date = "2021-07-25"
title = "Страхотни неща с контейнери: управление на хладилника с Grocy"
difficulty = "level-1"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "kühlschrank", "erp", "mhd", "Speispläne", "cms", "Cafe", "Bistro"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/july/20210725-docker-grocy/index.bg.md"
+++
С Grocy можете да управлявате цяло домакинство, ресторант, кафене, бистро или хранителен пазар. Можете да управлявате хладилници, менюта, задачи, списъци за пазаруване и срок на годност на хранителните продукти.
{{< gallery match="images/1/*.png" >}}
Днес ще покажа как да инсталирате услугата Grocy на дисковата станция на Synology.
## Възможност за професионалисти
Като опитен потребител на Synology можете, разбира се, да влезете в системата с помощта на SSH и да инсталирате цялата инсталация чрез файла Docker Compose.
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
Още полезни образи на Docker за домашна употреба можете да намерите в [Dockerverse]({{< ref "dockerverse" >}} "Dockerverse").
## Стъпка 1: Подготовка на папката Grocy
Създавам нова директория, наречена "grocy", в директорията на Docker.
{{< gallery match="images/2/*.png" >}}

## Стъпка 2: Инсталиране на Grocy
Кликвам върху раздела "Регистрация" в прозореца на Synology Docker и търся "Grocy". Избирам образа на Docker "linuxserver/grocy:latest" и след това щраквам върху етикета "latest".
{{< gallery match="images/3/*.png" >}}
Кликвам два пъти върху изображението на Grocy.
{{< gallery match="images/4/*.png" >}}
След това щраквам върху "Разширени настройки" и активирам "Автоматично рестартиране" и тук. Избирам раздела "Том" и щраквам върху "Добавяне на папка". Там създавам нова папка с този път за монтиране "/config".
{{< gallery match="images/5/*.png" >}}
Присвоявам фиксирани портове за контейнера "Grocy". При липса на фиксирани портове може да се окаже, че след рестартиране "сървърът Grocy" работи на друг порт.
{{< gallery match="images/6/*.png" >}}
{{<table "table table-striped table-bordered">}}
|Име на променливата|Стойност|Какво е то?|
|--- | --- |---|
|TZ | Europe/Berlin |Часова зона|
|PUID | 1024 |Идентификатор на потребител от Synology Admin User|
|PGID |	100 |Идентификатор на група от потребител на Synology Admin|
{{</table>}}
Накрая въвеждам тези променливи на средата:Вижте:
{{< gallery match="images/7/*.png" >}}
Контейнерът вече може да бъде стартиран. Извиквам сървъра Grocy с IP адреса на Synology и порта на контейнера и влизам в него с потребителското име "admin" и паролата "admin".
{{< gallery match="images/8/*.png" >}}
