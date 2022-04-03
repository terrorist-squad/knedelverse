+++
date = "2021-04-25T09:28:11+01:00"
title = "Великие вещи с контейнерами: Netbox на Synology - Diskstation"
difficulty = "level-3"
tags = ["Computernetzwerken", "DCIM", "Docker", "docker-compose", "IPAM", "netbox", "Synology", "netwerk"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210425-docker-Netbox/index.ru.md"
+++
NetBox - это бесплатное программное обеспечение, используемое для управления компьютерной сетью. Сегодня я покажу, как установить службу Netbox на Synology DiskStation.
## Шаг 1: Подготовьте Synology
Во-первых, на DiskStation должен быть активирован вход SSH. Для этого перейдите в "Панель управления" > "Терминал
{{< gallery match="images/1/*.png" >}}
Затем вы можете войти в систему через "SSH", указанный порт и пароль администратора (пользователи Windows используют Putty или WinSCP).
{{< gallery match="images/2/*.png" >}}
Я вхожу в систему через Terminal, winSCP или Putty и оставляю эту консоль открытой на потом.
## Шаг 2: Создайте папку NETBOX
Я создаю новый каталог под названием "netbox" в каталоге Docker.
{{< gallery match="images/3/*.png" >}}
Теперь необходимо скачать и распаковать следующий файл в директории: https://github.com/netbox-community/netbox-docker/archive/refs/heads/release.zip. Для этого я использую консоль:
{{< terminal >}}
cd /volume1/docker/netbox/
sudo wget https://github.com/netbox-community/netbox-docker/archive/refs/heads/release.zip
sudo /bin/7z x release.zip
cd netbox-docker-release
sudo mkdir netbox-media-files
sudo mkdir netbox-redis-data
sudo mkdir netbox-postgres-data

{{</ terminal >}}
Затем я редактирую файл "docker/docker-compose.yml" и ввожу адреса Synology в "netbox-media-files", "netbox-postgres-data" и "netbox-redis-data":
```
version: '3.4'
services:
  netbox: 
    image: netboxcommunity/netbox:${VERSION-v3.1-1.6.0}
    depends_on:
    - postgres
    - redis
    - redis-cache
    - netbox-worker
    env_file: env/netbox.env
    user: 'unit:root'
    volumes:
    - ./startup_scripts:/opt/netbox/startup_scripts:z,ro
    - ./initializers:/opt/netbox/initializers:z,ro
    - ./configuration:/etc/netbox/config:z,ro
    - ./reports:/etc/netbox/reports:z,ro
    - ./scripts:/etc/netbox/scripts:z,ro
    - ./netbox-media-files:/opt/netbox/netbox/media:z
    ports:
    - "8097:8080"
    
  netbox-worker:
    image: netboxcommunity/netbox:${VERSION-v3.1-1.6.0}
    env_file: env/netbox.env
    user: 'unit:root'
    depends_on:
    - redis
    - postgres
    command:
    - /opt/netbox/venv/bin/python
    - /opt/netbox/netbox/manage.py
    - rqworker

  netbox-housekeeping:
    image: netboxcommunity/netbox:${VERSION-v3.1-1.6.0}
    env_file: env/netbox.env
    user: 'unit:root'
    depends_on:
    - redis
    - postgres
    command:
    - /opt/netbox/housekeeping.sh

  # postgres
  postgres:
    image: postgres:14-alpine
    env_file: env/postgres.env
    volumes:
    - ./netbox-postgres-data:/var/lib/postgresql/data

  # redis
  redis:
    image: redis:6-alpine
    command:
    - sh
    - -c # this is to evaluate the $REDIS_PASSWORD from the env
    - redis-server --appendonly yes --requirepass $$REDIS_PASSWORD ## $$ because of docker-compose
    env_file: env/redis.env
    volumes:
    - ./netbox-redis-data:/data

  redis-cache:
    image: redis:6-alpine
    command:
    - sh
    - -c # this is to evaluate the $REDIS_PASSWORD from the env
    - redis-server --requirepass $$REDIS_PASSWORD ## $$ because of docker-compose
    env_file: env/redis-cache.env


```
Очень важно, чтобы наследование "<<: *netbox" заменяется и вводится порт для "netbox". После этого я могу запустить файл Compose:
{{< terminal >}}
sudo docker-compose up

{{</ terminal >}}
Создание базы данных может занять некоторое время. Поведение можно наблюдать через детали контейнера.
{{< gallery match="images/4/*.png" >}}
Я вызываю сервер netbox с IP-адресом Synology и портом моего контейнера.
{{< gallery match="images/5/*.png" >}}
