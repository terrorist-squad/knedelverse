+++
date = "2021-04-25T09:28:11+01:00"
title = "Wspaniałe rzeczy z kontenerami: Netbox na Synology - Diskstation"
difficulty = "level-3"
tags = ["Computernetzwerken", "DCIM", "Docker", "docker-compose", "IPAM", "netbox", "Synology", "netwerk"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210425-docker-Netbox/index.pl.md"
+++
NetBox to bezpłatne oprogramowanie służące do zarządzania siecią komputerową. Dzisiaj pokażę, jak zainstalować usługę Netbox na serwerze Synology DiskStation.
## Krok 1: Przygotuj Synology
Najpierw należy aktywować logowanie SSH na serwerze DiskStation. W tym celu należy przejść do "Panelu sterowania" > "Terminal
{{< gallery match="images/1/*.png" >}}
Następnie można zalogować się przez "SSH", podany port i hasło administratora (użytkownicy systemu Windows używają Putty lub WinSCP).
{{< gallery match="images/2/*.png" >}}
Loguję się za pomocą Terminala, winSCP lub Putty i zostawiam tę konsolę otwartą na później.
## Krok 2: Utwórz folder NETBOX
W katalogu Docker tworzę nowy katalog o nazwie "netbox".
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
Następnie edytuję plik "docker/docker-compose.yml" i wpisuję adresy Synology w "netbox-media-files", "netbox-postgres-data" i "netbox-redis-data":
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
Bardzo ważne jest, aby dziedziczenie "<<: *Następnie można uruchomić plik Compose:
{{< terminal >}}
sudo docker-compose up

{{</ terminal >}}
Utworzenie bazy danych może zająć trochę czasu. Zachowanie to można zaobserwować w szczegółach kontenera.
{{< gallery match="images/4/*.png" >}}
Wywołuję serwer netbox, podając adres IP Synology i port kontenera.
{{< gallery match="images/5/*.png" >}}
