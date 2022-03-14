+++
date = "2021-04-25T09:28:11+01:00"
title = "Großartiges mit Containern: Netbox auf der Synology – Disk"
difficulty = "level-3"
tags = ["Computernetzwerken", "DCIM", "Docker", "docker-compose", "IPAM", "netbox", "Synology", "netwerk"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/april/20210425-docker-Netbox/index.de.md"
+++

NetBox ist eine kostenlose Software, die für das Management von Computernetzwerken verwendet wird. Heute zeige ich, wie man einen Netbox-Dienst auf der Synology-Diskstation installiert.

## Schritt 1: Synology vorbereiten
Als erstes muss der SSH-Login auf der Diskstation aktiviert werden. Dazu geht man in die „Systemsteuerung“ > „Terminal & SNMP“ und aktiviert dort die „SSH-Dienst aktivieren“-Einstellung.
{{< gallery match="images/1/*.png" >}}

Danach kann man sich via „SSH„, den angegebenen Port und den Administrator-Password anmelden (Windows-Nutzer nehmen Putty oder WinSCP).
{{< gallery match="images/2/*.png" >}}
Ich logge mich via Terminal, winSCP oder Putty ein und lasse diese Konsole für später offen. 

## Schritt 2: NETBOX-Ordner erstellen
Ich erstelle ein neues Verzeichnis namens „netbox“ im Docker-Verzeichnis.
{{< gallery match="images/3/*.png" >}}

Jetzt muss die folgende Datei heruntergeladen und im Verzeichnis entpackt werden: https://github.com/netbox-community/netbox-docker/archive/refs/heads/release.zip. Ich benutze dazu die Konsole:
{{< terminal >}}
cd /volume1/docker/netbox/
sudo wget https://github.com/netbox-community/netbox-docker/archive/refs/heads/release.zip
sudo /bin/7z x release.zip
cd netbox-docker-release
sudo mkdir netbox-media-files
sudo mkdir netbox-redis-data
sudo mkdir netbox-postgres-data
{{</ terminal >}}

Dann editiere ich die „docker/docker-compose.yml“-Datei und trage dort bei „netbox-media-files“, „netbox-postgres-data“ und „netbox-redis-data“ meine Synology-Adressen ein:
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
Danach kann ich die Compose-Datei starten:
{{< terminal >}}
sudo docker-compose up
{{</ terminal >}}

Eventuell kann das Anlegen der Datenbank etwas dauern. Das verhalten lässt sich über die Container-Details beobachten.
{{< gallery match="images/4/*.png" >}}

Ich rufe den netbox-Server mit der Synology-IP-Adresse und meinem Container–Port auf.
{{< gallery match="images/5/*.png" >}}