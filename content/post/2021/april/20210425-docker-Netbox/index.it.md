+++
date = "2021-04-25T09:28:11+01:00"
title = "Grandi cose con i contenitori: Netbox su Synology - Disk"
difficulty = "level-3"
tags = ["Computernetzwerken", "DCIM", "Docker", "docker-compose", "IPAM", "netbox", "Synology", "netwerk"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210425-docker-Netbox/index.it.md"
+++
NetBox è un software gratuito utilizzato per la gestione delle reti di computer. Oggi mostro come installare un servizio Netbox sulla Synology DiskStation.
## Passo 1: Preparare Synology
Innanzitutto, il login SSH deve essere attivato sulla DiskStation. Per farlo, andate nel "Pannello di controllo" > "Terminale
{{< gallery match="images/1/*.png" >}}
Poi si può accedere tramite "SSH", la porta specificata e la password dell'amministratore (gli utenti Windows usano Putty o WinSCP).
{{< gallery match="images/2/*.png" >}}
Mi collego tramite Terminale, winSCP o Putty e lascio questa console aperta per dopo.
## Passo 2: Creare la cartella NETBOX
Creo una nuova directory chiamata "netbox" nella directory Docker.
{{< gallery match="images/3/*.png" >}}
Ora il seguente file deve essere scaricato e scompattato nella directory: https://github.com/netbox-community/netbox-docker/archive/refs/heads/release.zip. Io uso la console per questo:
{{< terminal >}}
cd /volume1/docker/netbox/
sudo wget https://github.com/netbox-community/netbox-docker/archive/refs/heads/release.zip
sudo /bin/7z x release.zip
cd netbox-docker-release
sudo mkdir netbox-media-files
sudo mkdir netbox-redis-data
sudo mkdir netbox-postgres-data

{{</ terminal >}}
Poi modifico il file "docker/docker-compose.yml" e inserisco i miei indirizzi Synology in "netbox-media-files", "netbox-postgres-data" e "netbox-redis-data":
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
Dopo di che posso avviare il file Compose:
{{< terminal >}}
sudo docker-compose up

{{</ terminal >}}
Potrebbe essere necessario un po' di tempo per creare il database. Il comportamento può essere osservato attraverso i dettagli del contenitore.
{{< gallery match="images/4/*.png" >}}
Chiamo il server netbox con l'indirizzo IP del Synology e la mia porta del container.
{{< gallery match="images/5/*.png" >}}