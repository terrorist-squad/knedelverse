+++
date = "2021-04-18"
title = "Великие дела с контейнерами: Запуск Docspell DMS на Synology DiskStation"
difficulty = "level-2"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "Document-Managment-System"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210418-docker-Docspell/index.ru.md"
+++
Docspell - это система управления документами для Synology DiskStation. С помощью Docspell документы можно индексировать, искать и находить гораздо быстрее. Сегодня я покажу, как установить службу Docspell на дисковую станцию Synology.
## Шаг 1: Подготовьте Synology
Во-первых, на DiskStation должен быть активирован вход SSH. Для этого перейдите в "Панель управления" > "Терминал
{{< gallery match="images/1/*.png" >}}
Затем вы можете войти в систему через "SSH", указанный порт и пароль администратора (пользователи Windows используют Putty или WinSCP).
{{< gallery match="images/2/*.png" >}}
Я вхожу в систему через Terminal, winSCP или Putty и оставляю эту консоль открытой на потом.
## Шаг 2: Создайте папку Docspel
Я создаю новый каталог под названием "docspell" в каталоге Docker.
{{< gallery match="images/3/*.png" >}}
Теперь необходимо скачать и распаковать следующий файл в директории: https://github.com/eikek/docspell/archive/refs/heads/master.zip . Для этого я использую консоль:
{{< terminal >}}
cd /volume1/docker/docspell/
mkdir docs
mkdir postgres_data
wget https://github.com/eikek/docspell/archive/refs/heads/master.zip 
/bin/7z x master.zip

{{</ terminal >}}
Затем я редактирую файл "docker/docker-compose.yml" и ввожу адреса моих Synology в "consumedir" и "db":
{{< gallery match="images/4/*.png" >}}
После этого я могу запустить файл Compose:
{{< terminal >}}
cd docspell-master/docker/
docker-compose up -d

{{</ terminal >}}
Через несколько минут я могу позвонить на свой сервер Docspell, указав IP-адрес дисковой станции и назначенный порт/7878.
{{< gallery match="images/5/*.png" >}}
Поиск документов работает хорошо. Жаль, что тексты на изображениях не индексируются. С помощью Papermerge вы также можете искать тексты в изображениях.
