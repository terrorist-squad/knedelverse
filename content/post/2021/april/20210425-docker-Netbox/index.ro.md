+++
date = "2021-04-25T09:28:11+01:00"
title = "Lucruri grozave cu containere: Netbox pe Synology - Disk"
difficulty = "level-3"
tags = ["Computernetzwerken", "DCIM", "Docker", "docker-compose", "IPAM", "netbox", "Synology", "netwerk"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/april/20210425-docker-Netbox/index.ro.md"
+++
NetBox este un software gratuit utilizat pentru gestionarea rețelelor de calculatoare. Astăzi vă voi arăta cum să instalați un serviciu Netbox pe Synology DiskStation.
## Pasul 1: Pregătiți Synology
În primul rând, conectarea SSH trebuie să fie activată pe DiskStation. Pentru a face acest lucru, mergeți la "Control Panel" > "Terminal".
{{< gallery match="images/1/*.png" >}}
Apoi vă puteți conecta prin "SSH", portul specificat și parola de administrator (utilizatorii de Windows folosesc Putty sau WinSCP).
{{< gallery match="images/2/*.png" >}}
Mă conectez prin Terminal, winSCP sau Putty și las această consolă deschisă pentru mai târziu.
## Pasul 2: Creați dosarul NETBOX
Creez un nou director numit "netbox" în directorul Docker.
{{< gallery match="images/3/*.png" >}}
Acum, următorul fișier trebuie descărcat și despachetat în directorul: https://github.com/netbox-community/netbox-docker/archive/refs/heads/release.zip. Eu folosesc consola pentru acest lucru:
{{< terminal >}}
cd /volume1/docker/netbox/
sudo wget https://github.com/netbox-community/netbox-docker/archive/refs/heads/release.zip
sudo /bin/7z x release.zip
cd netbox-docker-release
sudo mkdir netbox-media-files
sudo mkdir netbox-redis-data
sudo mkdir netbox-postgres-data

{{</ terminal >}}
Apoi, editez fișierul "docker/docker-compose.yml" și introduc adresele Synology în "netbox-media-files", "netbox-postgres-data" și "netbox-redis-data":
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
După aceea, pot să pornesc fișierul Compose:
{{< terminal >}}
sudo docker-compose up

{{</ terminal >}}
Crearea bazei de date poate dura ceva timp. Comportamentul poate fi observat prin intermediul detaliilor containerului.
{{< gallery match="images/4/*.png" >}}
Sun la serverul netbox cu adresa IP Synology și portul containerului meu.
{{< gallery match="images/5/*.png" >}}