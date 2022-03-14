+++
date = "2021-04-25T09:28:11+01:00"
title = "Velike stvari z zabojniki: Netbox na Synology - Disk"
difficulty = "level-3"
tags = ["Computernetzwerken", "DCIM", "Docker", "docker-compose", "IPAM", "netbox", "Synology", "netwerk"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210425-docker-Netbox/index.sl.md"
+++
NetBox je brezplačna programska oprema za upravljanje računalniškega omrežja. Danes bom pokazal, kako namestiti storitev Netbox v strežnik Synology DiskStation.
## Korak 1: Pripravite Synology
Najprej je treba na napravi DiskStation aktivirati prijavo SSH. To storite tako, da greste v "Nadzorna plošča" > "Terminal".
{{< gallery match="images/1/*.png" >}}
Nato se lahko prijavite prek SSH, določenih vrat in skrbniškega gesla (uporabniki Windows uporabljajo Putty ali WinSCP).
{{< gallery match="images/2/*.png" >}}
Prijavim se prek terminala, winSCP ali Puttyja in pustim to konzolo odprto za pozneje.
## Korak 2: Ustvarite mapo NETBOX
V imeniku programa Docker ustvarim nov imenik z imenom "netbox".
{{< gallery match="images/3/*.png" >}}
Zdaj je treba prenesti in razpakirati naslednjo datoteko v imeniku: https://github.com/netbox-community/netbox-docker/archive/refs/heads/release.zip. Za to uporabljam konzolo:
{{< terminal >}}
cd /volume1/docker/netbox/
sudo wget https://github.com/netbox-community/netbox-docker/archive/refs/heads/release.zip
sudo /bin/7z x release.zip
cd netbox-docker-release
sudo mkdir netbox-media-files
sudo mkdir netbox-redis-data
sudo mkdir netbox-postgres-data

{{</ terminal >}}
Nato uredim datoteko "docker/docker-compose.yml" in vnesem svoje naslove Synology v "netbox-media-files", "netbox-postgres-data" in "netbox-redis-data":
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
Nato lahko zaženem datoteko Compose:
{{< terminal >}}
sudo docker-compose up

{{</ terminal >}}
Ustvarjanje podatkovne zbirke lahko traja nekaj časa. Obnašanje lahko opazujete v podrobnostih o vsebniku.
{{< gallery match="images/4/*.png" >}}
Strežnik netboxa pokličem z naslovom IP Synology in vratom za zabojnik.
{{< gallery match="images/5/*.png" >}}