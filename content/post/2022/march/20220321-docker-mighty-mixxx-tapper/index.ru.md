+++
date = "2022-03-21"
title = "Великие дела с контейнерами: Запись MP3 с радио"
difficulty = "level-1"
tags = ["diskstation", "Docker", "docker-compose", "docker-for-desktop", "radio", "mp3", "ripp", "streamripper", "radiorecorder"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2022/march/20220321-docker-mighty-mixxx-tapper/index.ru.md"
+++
Streamripper - это инструмент для командной строки, который можно использовать для записи потоков MP3 или OGG/Vorbis и сохранения их непосредственно на жесткий диск. Песни автоматически называются по имени исполнителя и сохраняются индивидуально, формат - тот, который был отправлен изначально (таким образом, фактически создаются файлы с расширением .mp3 или .ogg). Я нашел отличный интерфейс радиорекордера и собрал из него образ Docker, см.: https://github.com/terrorist-squad/mightyMixxxTapper/.
{{< gallery match="images/1/*.png" >}}

## Вариант для профессионалов
Как опытный пользователь Synology, вы, конечно, можете войти в систему с помощью SSH и установить всю установку через файл Docker Compose.
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

## Шаг 1: Поиск образа Docker
Я перехожу на вкладку "Регистрация" в окне Synology Docker и ищу "mighty-mixxx-tapper". Я выбираю образ Docker "chrisknedel/mighty-mixxx-tapper" и затем нажимаю на тег "latest".
{{< gallery match="images/2/*.png" >}}
После загрузки изображения оно доступно в виде рисунка. Docker различает 2 состояния, контейнер "динамическое состояние" и образ/изображение (фиксированное состояние). Прежде чем мы сможем создать контейнер из образа, необходимо выполнить несколько настроек.
## Шаг 2: Введите изображение в работу:
Я дважды щелкаю по своему изображению "mighty-mixxx-tapper".
{{< gallery match="images/3/*.png" >}}
Затем я нажимаю на "Дополнительные настройки" и активирую "Автоматический перезапуск". Я выбираю вкладку "Том" и нажимаю "Добавить папку". Там я создаю новую папку с таким путем монтирования "/tmp/ripps/".
{{< gallery match="images/4/*.png" >}}
Я назначаю фиксированные порты для контейнера "mighty-mixxx-tapper". Без фиксированных портов может оказаться, что "mighty-mixxx-tapper-server" работает на другом порту после перезапуска.
{{< gallery match="images/5/*.png" >}}
После этих настроек можно запускать сервер mighty-mixxx-tapper-server! После этого вы можете позвонить на mighty-mixxx-tapper через Ip-адрес устройства Synology и назначенный порт, например, http://192.168.21.23:8097.
{{< gallery match="images/6/*.png" >}}
