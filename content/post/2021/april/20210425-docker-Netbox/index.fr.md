+++
date = "2021-04-25T09:28:11+01:00"
title = "De grandes choses avec les conteneurs : Netbox sur Synology - Disque"
difficulty = "level-3"
tags = ["Computernetzwerken", "DCIM", "Docker", "docker-compose", "IPAM", "netbox", "Synology", "netwerk"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210425-docker-Netbox/index.fr.md"
+++
NetBox est un logiciel gratuit utilisé pour la gestion des réseaux informatiques. Aujourd'hui, je montre comment installer un service Netbox sur le disque dur Synology.
## Étape 1 : Préparer Synology
La première chose à faire est d'activer le login SSH sur le Diskstation. Pour cela, il faut aller dans le "Panneau de configuration" > "Terminal".
{{< gallery match="images/1/*.png" >}}
Ensuite, on peut se connecter via "SSH", le port indiqué et le mot de passe de l'administrateur (les utilisateurs de Windows utilisent Putty ou WinSCP).
{{< gallery match="images/2/*.png" >}}
Je me connecte via Terminal, winSCP ou Putty et je laisse cette console ouverte pour plus tard.
## Étape 2 : Créer un dossier NETBOX
Je crée un nouveau répertoire appelé "netbox" dans le répertoire Docker.
{{< gallery match="images/3/*.png" >}}
Il faut maintenant télécharger le fichier suivant et le décompresser dans le répertoire : https://github.com/netbox-community/netbox-docker/archive/refs/heads/release.zip. Pour cela, j'utilise la console :
{{< terminal >}}
cd /volume1/docker/netbox/
sudo wget https://github.com/netbox-community/netbox-docker/archive/refs/heads/release.zip
sudo /bin/7z x release.zip
cd netbox-docker-release
sudo mkdir netbox-media-files
sudo mkdir netbox-redis-data
sudo mkdir netbox-postgres-data

{{</ terminal >}}
Ensuite, j'édite le fichier "docker/docker-compose.yml" et j'y insère mes adresses Synology dans "netbox-media-files", "netbox-postgres-data" et "netbox-redis-data" :
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
Ensuite, je peux lancer le fichier Compose :
{{< terminal >}}
sudo docker-compose up

{{</ terminal >}}
La création de la base de données peut éventuellement prendre un certain temps. Le comportement peut être observé dans les détails du conteneur.
{{< gallery match="images/4/*.png" >}}
J'appelle le serveur netbox avec l'adresse IP de Synology et mon port de conteneur.
{{< gallery match="images/5/*.png" >}}