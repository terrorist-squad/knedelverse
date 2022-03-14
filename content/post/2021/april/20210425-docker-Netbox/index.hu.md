+++
date = "2021-04-25T09:28:11+01:00"
title = "Nagyszerű dolgok konténerekkel: Netbox a Synology-n - Lemez"
difficulty = "level-3"
tags = ["Computernetzwerken", "DCIM", "Docker", "docker-compose", "IPAM", "netbox", "Synology", "netwerk"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/april/20210425-docker-Netbox/index.hu.md"
+++
A NetBox egy ingyenes szoftver, amelyet számítógépes hálózatok kezelésére használnak. Ma megmutatom, hogyan kell telepíteni a Netbox szolgáltatást a Synology DiskStationre.
## 1. lépés: A Synology előkészítése
Először is aktiválni kell az SSH bejelentkezést a DiskStationön. Ehhez menjen a "Vezérlőpult" > "Terminál" > "Terminál" menüpontba.
{{< gallery match="images/1/*.png" >}}
Ezután bejelentkezhet az "SSH"-n keresztül, a megadott porton és a rendszergazdai jelszóval (Windows felhasználók a Putty vagy a WinSCP segítségével).
{{< gallery match="images/2/*.png" >}}
Terminal, winSCP vagy Putty segítségével jelentkezem be, és ezt a konzolt későbbre nyitva hagyom.
## 2. lépés: NETBOX mappa létrehozása
Létrehozok egy új könyvtárat "netbox" néven a Docker könyvtárban.
{{< gallery match="images/3/*.png" >}}
Most a következő fájlt kell letölteni és kicsomagolni a következő könyvtárba: https://github.com/netbox-community/netbox-docker/archive/refs/heads/release.zip. Ehhez a konzolt használom:
{{< terminal >}}
cd /volume1/docker/netbox/
sudo wget https://github.com/netbox-community/netbox-docker/archive/refs/heads/release.zip
sudo /bin/7z x release.zip
cd netbox-docker-release
sudo mkdir netbox-media-files
sudo mkdir netbox-redis-data
sudo mkdir netbox-postgres-data

{{</ terminal >}}
Ezután szerkesztem a "docker/docker-compose.yml" fájlt, és beírom a Synology címeket a "netbox-media-files", "netbox-postgres-data" és "netbox-redis-data" címekbe:
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
Ezután elindíthatom a Compose fájlt:
{{< terminal >}}
sudo docker-compose up

{{</ terminal >}}
Az adatbázis létrehozása eltarthat egy ideig. A viselkedés a konténer részletein keresztül figyelhető meg.
{{< gallery match="images/4/*.png" >}}
Felhívom a netbox szervert a Synology IP-címével és a konténerportommal.
{{< gallery match="images/5/*.png" >}}