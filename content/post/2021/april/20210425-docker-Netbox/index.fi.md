+++
date = "2021-04-25T09:28:11+01:00"
title = "Suuria asioita konttien avulla: Netbox Synologylla - Disk"
difficulty = "level-3"
tags = ["Computernetzwerken", "DCIM", "Docker", "docker-compose", "IPAM", "netbox", "Synology", "netwerk"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/april/20210425-docker-Netbox/index.fi.md"
+++
NetBox on ilmainen ohjelmisto, jota käytetään tietokoneverkon hallintaan. Tänään näytän, miten Netbox-palvelu asennetaan Synology DiskStationiin.
## Vaihe 1: Synologyn valmistelu
Ensin SSH-kirjautuminen on aktivoitava DiskStationissa. Tee tämä menemällä "Ohjauspaneeli" > "Pääte" > "Pääte".
{{< gallery match="images/1/*.png" >}}
Sitten voit kirjautua sisään "SSH:n", määritetyn portin ja järjestelmänvalvojan salasanan kautta (Windows-käyttäjät käyttävät Puttya tai WinSCP:tä).
{{< gallery match="images/2/*.png" >}}
Kirjaudun sisään terminaalin, winSCP:n tai Puttyn kautta ja jätän tämän konsolin auki myöhempää käyttöä varten.
## Vaihe 2: Luo NETBOX-kansio
Luon Docker-hakemistoon uuden hakemiston nimeltä "netbox".
{{< gallery match="images/3/*.png" >}}
Nyt seuraava tiedosto on ladattava ja purettava hakemistoon: https://github.com/netbox-community/netbox-docker/archive/refs/heads/release.zip. Käytän tähän konsolia:
{{< terminal >}}
cd /volume1/docker/netbox/
sudo wget https://github.com/netbox-community/netbox-docker/archive/refs/heads/release.zip
sudo /bin/7z x release.zip
cd netbox-docker-release
sudo mkdir netbox-media-files
sudo mkdir netbox-redis-data
sudo mkdir netbox-postgres-data

{{</ terminal >}}
Sitten muokkaan tiedostoa "docker/docker-compose.yml" ja kirjoitan Synologyn osoitteet kohtiin "netbox-media-files", "netbox-postgres-data" ja "netbox-redis-data":
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
Sen jälkeen voin käynnistää Compose-tiedoston:
{{< terminal >}}
sudo docker-compose up

{{</ terminal >}}
Tietokannan luominen voi kestää jonkin aikaa. Käyttäytymistä voi tarkkailla säiliön yksityiskohdista.
{{< gallery match="images/4/*.png" >}}
Soitan netbox-palvelimelle Synologyn IP-osoitteella ja konttiportilla.
{{< gallery match="images/5/*.png" >}}