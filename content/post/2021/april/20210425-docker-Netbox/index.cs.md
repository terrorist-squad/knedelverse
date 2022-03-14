+++
date = "2021-04-25T09:28:11+01:00"
title = "Skvělé věci s kontejnery: Netbox na Synology - Disk"
difficulty = "level-3"
tags = ["Computernetzwerken", "DCIM", "Docker", "docker-compose", "IPAM", "netbox", "Synology", "netwerk"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/april/20210425-docker-Netbox/index.cs.md"
+++
NetBox je bezplatný software pro správu počítačové sítě. Dnes vám ukážu, jak nainstalovat službu Netbox do zařízení Synology DiskStation.
## Krok 1: Příprava společnosti Synology
Nejprve je třeba na zařízení DiskStation aktivovat přihlášení SSH. Chcete-li to provést, přejděte do nabídky "Ovládací panely" > "Terminál".
{{< gallery match="images/1/*.png" >}}
Poté se můžete přihlásit pomocí "SSH", zadaného portu a hesla správce (uživatelé Windows používají Putty nebo WinSCP).
{{< gallery match="images/2/*.png" >}}
Přihlašuji se přes Terminál, winSCP nebo Putty a nechávám tuto konzoli otevřenou na později.
## Krok 2: Vytvoření složky NETBOX
V adresáři Docker vytvořím nový adresář s názvem "netbox".
{{< gallery match="images/3/*.png" >}}
Nyní je třeba stáhnout následující soubor a rozbalit jej do adresáře: https://github.com/netbox-community/netbox-docker/archive/refs/heads/release.zip. K tomu používám konzolu:
{{< terminal >}}
cd /volume1/docker/netbox/
sudo wget https://github.com/netbox-community/netbox-docker/archive/refs/heads/release.zip
sudo /bin/7z x release.zip
cd netbox-docker-release
sudo mkdir netbox-media-files
sudo mkdir netbox-redis-data
sudo mkdir netbox-postgres-data

{{</ terminal >}}
Pak upravím soubor "docker/docker-compose.yml" a zadám adresy Synology do polí "netbox-media-files", "netbox-postgres-data" a "netbox-redis-data":
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
Poté mohu spustit soubor Compose:
{{< terminal >}}
sudo docker-compose up

{{</ terminal >}}
Vytvoření databáze může nějakou dobu trvat. Chování lze sledovat prostřednictvím podrobností o kontejneru.
{{< gallery match="images/4/*.png" >}}
Zavolám server netboxu s IP adresou Synology a portem kontejneru.
{{< gallery match="images/5/*.png" >}}