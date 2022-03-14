+++
date = "2021-04-25T09:28:11+01:00"
title = "Świetne rzeczy z kontenerami: Netbox na Synology - Disk"
difficulty = "level-3"
tags = ["Computernetzwerken", "DCIM", "Docker", "docker-compose", "IPAM", "netbox", "Synology", "netwerk"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/april/20210425-docker-Netbox/index.pl.md"
+++
NetBox to darmowe oprogramowanie służące do zarządzania siecią komputerową. Dzisiaj pokażę jak zainstalować usługę Netbox na serwerze Synology DiskStation.
## Krok 1: Przygotuj Synology
Najpierw należy aktywować logowanie SSH na serwerze DiskStation. W tym celu należy wejść w "Panel sterowania" > "Terminal
{{< gallery match="images/1/*.png" >}}
Następnie można zalogować się poprzez "SSH", podany port i hasło administratora (użytkownicy Windows używają Putty lub WinSCP).
{{< gallery match="images/2/*.png" >}}
Loguję się przez Terminal, winSCP lub Putty i zostawiam tę konsolę otwartą na później.
## Krok 2: Utwórz folder NETBOX
Tworzę nowy katalog o nazwie "netbox" w katalogu Docker.
{{< gallery match="images/3/*.png" >}}
Teraz należy pobrać i rozpakować następujący plik w katalogu: https://github.com/netbox-community/netbox-docker/archive/refs/heads/release.zip. Używam do tego konsoli:
{{< terminal >}}
cd /volume1/docker/netbox/
sudo wget https://github.com/netbox-community/netbox-docker/archive/refs/heads/release.zip
sudo /bin/7z x release.zip
cd netbox-docker-release
sudo mkdir netbox-media-files
sudo mkdir netbox-redis-data
sudo mkdir netbox-postgres-data

{{</ terminal >}}
Następnie edytuję plik "docker/docker-compose.yml" i wpisuję moje adresy Synology w "netbox-media-files", "netbox-postgres-data" i "netbox-redis-data":
```
version: '3.4'
services:
  netbox: &netbox
    image: netboxcommunity/netbox:${VERSION-latest}
    depends_on:
    - postgres
    - redis
    - redis-cache
    - netbox-worker
    env_file: env/netbox.env
    user: '101'
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
    <<: *netbox
    depends_on:
    - redis
    entrypoint:
    - /opt/netbox/venv/bin/python
    - /opt/netbox/netbox/manage.py
    command:
    - rqworker
    ports: []

  # postgres
  postgres:
    image: postgres:12-alpine
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
Po tym mogę uruchomić plik Compose:
{{< terminal >}}
sudo docker-compose up

{{</ terminal >}}
Tworzenie bazy danych może zająć trochę czasu. Zachowanie to można obserwować poprzez szczegóły kontenera.
{{< gallery match="images/4/*.png" >}}
Wywołuję serwer netbox podając adres IP Synology i port mojego kontenera.
{{< gallery match="images/5/*.png" >}}