+++
date = "2020-02-13"
title = "Синология-Нас: Установите Calibre Web в качестве библиотеки электронных книг"
difficulty = "level-1"
tags = ["calbre-web", "calibre", "Docker", "ds918", "ebook", "epub", "nas", "pdf", "Synology"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2020/february/20200213-synology-calibreweb/index.ru.md"
+++
Как установить Calibre-Web как контейнер Docker на NAS Synology? Внимание: Этот метод установки устарел и не совместим с текущим программным обеспечением Calibre. Пожалуйста, взгляните на этот новый учебник:[Великие вещи с контейнерами: Запуск Calibre с помощью Docker Compose]({{< ref "post/2020/february/20200221-docker-Calibre-pro" >}} "Великие вещи с контейнерами: Запуск Calibre с помощью Docker Compose"). Это руководство предназначено для всех специалистов Synology DS.
## Шаг 1: Создайте папку
Сначала я создаю папку для библиотеки Calibre.  Я вызываю "Управление системой" -> "Общая папка" и создаю новую папку "Книги".
{{< gallery match="images/1/*.png" >}}

##  Шаг 2: Создайте библиотеку Calibre
Теперь я копирую существующую библиотеку или "[эта пустая библиотека-образец](https://drive.google.com/file/d/1zfeU7Jh3FO_jFlWSuZcZQfQOGD0NvXBm/view)" в новый каталог. Я сам скопировал существующую библиотеку настольного приложения.
{{< gallery match="images/2/*.png" >}}

## Шаг 3: Поиск образа Docker
Я перехожу на вкладку "Регистрация" в окне Synology Docker и ищу "Calibre". Я выбираю образ Docker "janeczku/calibre-web" и затем нажимаю на тег "latest".
{{< gallery match="images/3/*.png" >}}
После загрузки изображения оно доступно в виде рисунка. Docker различает 2 состояния, контейнер "динамическое состояние" и образ/изображение (фиксированное состояние). Прежде чем мы сможем создать контейнер из образа, необходимо выполнить несколько настроек.
## Шаг 4: Введите изображение в работу:
Я дважды щелкаю на своем изображении Calibre.
{{< gallery match="images/4/*.png" >}}
Затем я нажимаю на "Дополнительные настройки" и активирую "Автоматический перезапуск". Я выбираю вкладку "Том" и нажимаю "Добавить папку". Там я создаю новую папку базы данных с таким путем монтирования "/calibre".
{{< gallery match="images/5/*.png" >}}
Я назначаю фиксированные порты для контейнера Calibre. При отсутствии фиксированных портов может оказаться, что после перезапуска Calibre работает на другом порту.
{{< gallery match="images/6/*.png" >}}
После этих настроек Calibre можно запускать!
{{< gallery match="images/7/*.png" >}}
Теперь я вызываю IP-адрес Synology с назначенным портом Calibre и вижу следующее изображение. Я ввожу "/calibre" в качестве "Расположение базы данных Calibre". Остальные настройки - дело вкуса.
{{< gallery match="images/8/*.png" >}}
Логин по умолчанию - "admin" с паролем "admin123".
{{< gallery match="images/9/*.png" >}}
Готово! Конечно, теперь я также могу подключить настольное приложение через мою "папку с книгами". Я переключаю библиотеку в своем приложении, а затем выбираю папку Nas.
{{< gallery match="images/10/*.png" >}}
Что-то вроде этого:
{{< gallery match="images/11/*.png" >}}
Если теперь я редактирую мета-инфо в настольном приложении, они также автоматически обновляются в веб-приложении.
{{< gallery match="images/12/*.png" >}}
