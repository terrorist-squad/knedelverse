+++
date = "2020-02-28"
title = "Великие дела с контейнерами: Запуск Papermerge DMS на NAS Synology"
difficulty = "level-3"
tags = ["archiv", "automatisch", "dms", "Docker", "Document-Managment-System", "google", "ocr", "papermerge", "Synology", "tesseract", "texterkennung"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2020/february/20200228-docker-papermerge/index.ru.md"
+++
Papermerge - это молодая система управления документами (DMS), которая может автоматически назначать и обрабатывать документы. В этом руководстве я показываю, как я установил Papermerge на дисковую станцию Synology и как работает DMS.
## Вариант для профессионалов
Как опытный пользователь Synology, вы, конечно, можете войти в систему с помощью SSH и установить всю установку через файл Docker Compose.
```
version: "2.1"
services:
  papermerge:
    image: ghcr.io/linuxserver/papermerge
    container_name: papermerge
    environment:
      - PUID=1024
      - PGID=100
      - TZ=Europe/Berlin
    volumes:
      - ./config>:/config
      - ./appdata/data>:/data
    ports:
      - 8090:8000
    restart: unless-stopped

```

## Шаг 1: Создайте папку
Сначала я создаю папку для слияния документов. Я перехожу в "Управление системой" -> "Общая папка" и создаю новую папку под названием "Архив документов".
{{< gallery match="images/1/*.png" >}}
Шаг 2: Поиск образа DockerВ окне Synology Docker перейдите на вкладку "Регистрация" и найдите "Papermerge". Я выбираю образ Docker "linuxserver/papermerge" и затем нажимаю на тег "latest".
{{< gallery match="images/2/*.png" >}}
После загрузки изображения оно доступно в виде рисунка. Docker различает 2 состояния, контейнер "динамическое состояние" и образ/изображение (фиксированное состояние). Прежде чем мы сможем создать контейнер из образа, необходимо выполнить несколько настроек.
## Шаг 3: Введите изображение в работу:
Я дважды щелкаю на изображении слияния бумаги.
{{< gallery match="images/3/*.png" >}}
Затем я нажимаю на "Дополнительные настройки" и активирую "Автоматический перезапуск". Я выбираю вкладку "Том" и нажимаю "Добавить папку". Там я создаю новую папку базы данных с таким путем монтирования "/data".
{{< gallery match="images/4/*.png" >}}
Я также храню здесь вторую папку, которую включаю в путь монтирования "/config". Не имеет значения, где находится эта папка. Однако важно, чтобы он принадлежал пользователю Synology admin.
{{< gallery match="images/5/*.png" >}}
Я назначаю фиксированные порты для контейнера "Papermerge". При отсутствии фиксированных портов может оказаться, что после перезапуска "сервер Papermerge" работает на другом порту.
{{< gallery match="images/6/*.png" >}}
Наконец, я ввожу три переменные окружения. Переменная "PUID" - это идентификатор пользователя, а "PGID" - идентификатор группы моего пользователя-администратора. Вы можете узнать PGID/PUID через SSH с помощью команды "cat /etc/passwd | grep admin".
{{< gallery match="images/7/*.png" >}}
После этих настроек сервер Papermerge можно запускать! После этого Papermerge можно вызвать через Ip-адрес устройства Synology и назначенный порт, например, http://192.168.21.23:8095.
{{< gallery match="images/8/*.png" >}}
По умолчанию используется логин admin с паролем admin.
## Как работает Papermerge?
Papermerge анализирует текст документов и изображений. Papermerge использует библиотеку OCR/"оптического распознавания символов" под названием tesseract, опубликованную компанией Goolge.
{{< gallery match="images/9/*.png" >}}
Я создал папку под названием "Все с Lorem", чтобы протестировать автоматическое назначение документов. Затем я создал новый образец распознавания в пункте меню "Автоматы".
{{< gallery match="images/10/*.png" >}}
Все новые документы, содержащие слово "Lorem", помещаются в папку "Everything with Lorem" и помечаются тегом "has-lorem". Важно использовать запятую в тегах, иначе тег не будет установлен. Если вы загрузите соответствующий документ, он будет помечен и отсортирован.
{{< gallery match="images/11/*.png" >}}