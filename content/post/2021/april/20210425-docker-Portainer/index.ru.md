+++
date = "2021-04-25T09:28:11+01:00"
title = "Великие дела с контейнерами: Portainer как альтернатива Synology Docker GUI"
difficulty = "level-3"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "watchtower"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/april/20210425-docker-Portainer/index.ru.md"
+++

## Шаг 1: Подготовьте Synology
Во-первых, на DiskStation должен быть активирован вход SSH. Для этого перейдите в "Панель управления" > "Терминал
{{< gallery match="images/1/*.png" >}}
Затем вы можете войти в систему через "SSH", указанный порт и пароль администратора (пользователи Windows используют Putty или WinSCP).
{{< gallery match="images/2/*.png" >}}
Я вхожу в систему через Terminal, winSCP или Putty и оставляю эту консоль открытой на потом.
## Шаг 2: Создайте папку portainer
Я создаю новый каталог под названием "portainer" в каталоге Docker.
{{< gallery match="images/3/*.png" >}}
Затем я перехожу в каталог portainer с консолью и создаю там папку и новый файл под названием "portainer.yml".
{{< terminal >}}
cd /volume1/docker/portainer
mkdir portainer_data
vim portainer.yml

{{</ terminal >}}
Вот содержимое файла "portainer.yml":
```
version: '3'

services:
  portainer:
    image: portainer/portainer:latest
    container_name: portainer
    restart: always
    ports:
      - 90070:9000
      - 9090:8000
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - ./portainer_data:/data

```
Более полезные образы Docker для домашнего использования можно найти в [Dockerverse]({{< ref "dockerverse" >}} "Dockerverse").
## Шаг 3: Запуск портьеры
На этом этапе я также могу использовать консоль. Я запускаю сервер portainer через Docker Compose.
{{< terminal >}}
sudo docker-compose -f portainer.yml up -d

{{</ terminal >}}
Затем я могу вызвать свой сервер Portainer с IP дисковой станции и назначенным портом из "Шага 2". Я ввожу свой пароль администратора и выбираю локальный вариант.
{{< gallery match="images/4/*.png" >}}
Как видите, все работает отлично!
{{< gallery match="images/5/*.png" >}}