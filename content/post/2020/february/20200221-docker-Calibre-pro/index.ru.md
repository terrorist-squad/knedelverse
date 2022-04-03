+++
date = "2020-02-21"
title = "Великие дела с контейнерами: Запуск Calibre с помощью Docker Compose (установка Synology pro)"
difficulty = "level-3"
tags = ["calibre", "calibre-web", "Docker", "docker-compose", "Synology", "linux"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2020/february/20200221-docker-Calibre-pro/index.ru.md"
+++
В этом блоге уже есть более простой учебник: [Синология-Нас: Установите Calibre Web в качестве библиотеки электронных книг]({{< ref "post/2020/february/20200213-synology-calibreweb" >}} "Синология-Нас: Установите Calibre Web в качестве библиотеки электронных книг"). Это руководство предназначено для всех специалистов Synology DS.
## Шаг 1: Подготовьте Synology
Во-первых, на DiskStation должен быть активирован вход SSH. Для этого перейдите в "Панель управления" > "Терминал
{{< gallery match="images/1/*.png" >}}
Затем вы можете войти в систему через "SSH", указанный порт и пароль администратора (пользователи Windows используют Putty или WinSCP).
{{< gallery match="images/2/*.png" >}}
Я вхожу в систему через Terminal, winSCP или Putty и оставляю эту консоль открытой на потом.
## Шаг 2: Создайте папку с книгами
Я создаю новую папку для библиотеки Calibre. Для этого я вызываю "Управление системой" -> "Общая папка" и создаю новую папку под названием "Книги". Если папки "Docker" еще нет, то ее также необходимо создать.
{{< gallery match="images/3/*.png" >}}

## Шаг 3: Подготовьте папку для книг
Теперь необходимо загрузить и распаковать следующий файл: https://drive.google.com/file/d/1zfeU7Jh3FO_jFlWSuZcZQfQOGD0NvXBm/view. Содержимое ("metadata.db") должно быть помещено в новый каталог книг, см:
{{< gallery match="images/4/*.png" >}}

## Шаг 4: Подготовьте папку Docker
Я создаю новый каталог под названием "calibre" в каталоге Docker:
{{< gallery match="images/5/*.png" >}}
Затем я перехожу в новый каталог и создаю новый файл под названием "calibre.yml" со следующим содержимым:
```
version: '2'
services:
  calibre-web:
    image: linuxserver/calibre-web
    container_name: calibre-web-server
    environment:
      - PUID=1026
      - PGID=100
      - TZ=Europe/Berlin
    volumes:
      - /volume1/Buecher:/books
      - /volume1/docker/calibre:/briefkaste
    ports:
      - 8055:8083
    restart: unless-stopped

```
В этом новом файле необходимо настроить несколько мест следующим образом:* PUID/PGID: Идентификатор пользователя и группы пользователя DS должен быть введен в PUID/PGID. Здесь я использую консоль из "Шага 1" и команду "id -u", чтобы увидеть идентификатор пользователя. С помощью команды "id -g" я получаю ID группы.* порты: Для порта, передняя часть "8055:" должна быть скорректирована.каталогиВсе каталоги в этом файле должны быть скорректированы. Правильные адреса можно увидеть в окне свойств DS. (Далее следует скриншот)
{{< gallery match="images/6/*.png" >}}

## Шаг 5: Тестовый запуск
На этом этапе я также могу использовать консоль. Я перехожу в каталог Calibre и запускаю там сервер Calibre через Docker Compose.
{{< terminal >}}
cd /volume1/docker/calibre
sudo docker-compose -f calibre.yml up -d

{{</ terminal >}}

{{< gallery match="images/7/*.png" >}}

## Шаг 6: Настройка
Затем я могу вызвать мой сервер Calibre с IP дисковой станции и назначенным портом из "Шага 4". В настройках я использую точку монтирования "/books". После этого сервер уже можно использовать.
{{< gallery match="images/8/*.png" >}}

## Шаг 7: Завершение настройки
Консоль также необходима на этом этапе. Я использую команду "exec" для сохранения базы данных контейнера-внутреннего приложения.
{{< terminal >}}
sudo docker exec -it calibre-web-server cp /app/calibre-web/app.db /briefkaste/app.db

{{</ terminal >}}
После этого я вижу новый файл "app.db" в каталоге Calibre:
{{< gallery match="images/9/*.png" >}}
Затем я останавливаю сервер Calibre:
{{< terminal >}}
sudo docker-compose -f calibre.yml down

{{</ terminal >}}
Теперь я изменяю путь к почтовому ящику и сохраняю базу данных приложения поверх него.
```
version: '2'
services:
  calibre-web:
    image: linuxserver/calibre-web
    container_name: calibre-web-server
    environment:
      - PUID=1026
      - PGID=100
      - TZ=Europe/Berlin
    volumes:
      - /volume1/Buecher:/books
      - /volume1/docker/calibre/app.db:/app/calibre-web/app.db
    ports:
      - 8055:8083
    restart: unless-stopped

```
После этого сервер можно перезапустить:
{{< terminal >}}
sudo docker-compose -f calibre.yml up -d

{{</ terminal >}}
