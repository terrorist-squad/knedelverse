+++
date = "2021-04-25T09:28:11+01:00"
title = "Skvelé veci s kontajnermi: Netbox na Synology - Disk"
difficulty = "level-3"
tags = ["Computernetzwerken", "DCIM", "Docker", "docker-compose", "IPAM", "netbox", "Synology", "netwerk"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210425-docker-Netbox/index.sk.md"
+++
NetBox je bezplatný softvér používaný na správu počítačovej siete. Dnes vám ukážem, ako nainštalovať službu Netbox do zariadenia Synology DiskStation.
## Krok 1: Príprava spoločnosti Synology
Najprv je potrebné aktivovať prihlásenie SSH na zariadení DiskStation. Ak to chcete urobiť, prejdite na "Ovládací panel" > "Terminál".
{{< gallery match="images/1/*.png" >}}
Potom sa môžete prihlásiť cez "SSH", zadaný port a heslo správcu (používatelia systému Windows používajú Putty alebo WinSCP).
{{< gallery match="images/2/*.png" >}}
Prihlásim sa cez terminál, winSCP alebo Putty a túto konzolu nechám otvorenú na neskôr.
## Krok 2: Vytvorenie priečinka NETBOX
V adresári Docker vytvorím nový adresár s názvom "netbox".
{{< gallery match="images/3/*.png" >}}
Teraz je potrebné stiahnuť a rozbaliť nasledujúci súbor do adresára: https://github.com/netbox-community/netbox-docker/archive/refs/heads/release.zip. Používam na to konzolu:
{{< terminal >}}
cd /volume1/docker/netbox/
sudo wget https://github.com/netbox-community/netbox-docker/archive/refs/heads/release.zip
sudo /bin/7z x release.zip
cd netbox-docker-release
sudo mkdir netbox-media-files
sudo mkdir netbox-redis-data
sudo mkdir netbox-postgres-data

{{</ terminal >}}
Potom upravím súbor "docker/docker-compose.yml" a zadám svoje adresy Synology do položiek "netbox-media-files", "netbox-postgres-data" a "netbox-redis-data":
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
Potom môžem spustiť súbor Compose:
{{< terminal >}}
sudo docker-compose up

{{</ terminal >}}
Vytvorenie databázy môže chvíľu trvať. Správanie je možné sledovať prostredníctvom podrobností o kontajneri.
{{< gallery match="images/4/*.png" >}}
Zavolám server netboxu s IP adresou Synology a svojím kontajnerovým portom.
{{< gallery match="images/5/*.png" >}}