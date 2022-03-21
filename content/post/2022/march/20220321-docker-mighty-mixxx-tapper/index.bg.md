+++
date = "2022-03-21"
title = "Страхотни неща с контейнери: Записване на MP3 файлове от радиото"
difficulty = "level-1"
tags = ["diskstation", "Docker", "docker-compose", "docker-for-desktop", "radio", "mp3", "ripp", "streamripper", "radiorecorder"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2022/march/20220321-docker-mighty-mixxx-tapper/index.bg.md"
+++
Streamripper е инструмент за командния ред, който може да се използва за записване на потоци от MP3 или OGG/Vorbis и да се записва директно на твърдия диск. Песните се именуват автоматично според изпълнителя и се записват поотделно, като форматът е този, който е изпратен първоначално (така че всъщност се създават файлове с разширение .mp3 или .ogg). Намерих страхотен интерфейс за радиорекордер и изградих образ на Docker от него, вижте: https://github.com/terrorist-squad/mightyMixxxTapper/
{{< gallery match="images/1/*.png" >}}

## Възможност за професионалисти
Като опитен потребител на Synology можете, разбира се, да влезете в системата с помощта на SSH и да инсталирате цялата инсталация чрез файла Docker Compose.
```
version: "2.0"
services:
  mealie:
    container_name: mighty-mixxx-tapper
    image: chrisknedel/mighty-mixxx-tapper:latest
    restart: always
    ports:
      - 9000:80
    environment:
      TZ: Europa/Berlin
    volumes:
      - ./ripps/:/tmp/ripps/

```

## Стъпка 1: Търсене на образ на Docker
Кликвам върху раздела "Регистрация" в прозореца Synology Docker и търся "mighty-mixxx-tapper". Избирам образа на Docker "chrisknedel/mighty-mixxx-tapper" и след това щраквам върху етикета "latest".
{{< gallery match="images/2/*.png" >}}
След изтеглянето на изображението то е достъпно като изображение. Docker прави разлика между 2 състояния - контейнер "динамично състояние" и образ/имдж (фиксирано състояние). Преди да можем да създадем контейнер от изображението, трябва да се направят няколко настройки.
## Стъпка 2: Въведете изображението в действие:
Кликвам два пъти върху моето изображение "mighty-mixxx-tapper".
{{< gallery match="images/3/*.png" >}}
След това щракнах върху "Разширени настройки" и активирах "Автоматично рестартиране". Избирам раздела "Том" и щраквам върху "Добавяне на папка". Там създавам нова папка с този път за монтиране "/tmp/ripps/".
{{< gallery match="images/4/*.png" >}}
Присвоявам фиксирани портове за контейнера "mighty-mixxx-tapper". Без фиксирани портове може да се окаже, че "mighty-mixxx-tapper-server" работи на различен порт след рестартиране.
{{< gallery match="images/5/*.png" >}}
След тези настройки може да се стартира mighty-mixxx-tapper-server! След това можете да се обадите на mighty-mixxx-tapper чрез Ip адреса на устройството Synology и назначения порт, например http://192.168.21.23:8097.
{{< gallery match="images/6/*.png" >}}