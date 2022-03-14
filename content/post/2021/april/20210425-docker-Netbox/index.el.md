+++
date = "2021-04-25T09:28:11+01:00"
title = "Μεγάλα πράγματα με δοχεία: Netbox σε Synology - Disk"
difficulty = "level-3"
tags = ["Computernetzwerken", "DCIM", "Docker", "docker-compose", "IPAM", "netbox", "Synology", "netwerk"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/april/20210425-docker-Netbox/index.el.md"
+++
Το NetBox είναι ένα δωρεάν λογισμικό που χρησιμοποιείται για τη διαχείριση δικτύων υπολογιστών. Σήμερα θα σας δείξω πώς να εγκαταστήσετε μια υπηρεσία Netbox στον Synology DiskStation.
## Βήμα 1: Προετοιμάστε τη Synology
Πρώτον, η σύνδεση SSH πρέπει να ενεργοποιηθεί στον DiskStation. Για να το κάνετε αυτό, μεταβείτε στον "Πίνακα Ελέγχου" > "Τερματικό
{{< gallery match="images/1/*.png" >}}
Στη συνέχεια, μπορείτε να συνδεθείτε μέσω "SSH", της καθορισμένης θύρας και του κωδικού πρόσβασης διαχειριστή (οι χρήστες των Windows χρησιμοποιούν το Putty ή το WinSCP).
{{< gallery match="images/2/*.png" >}}
Συνδέομαι μέσω Terminal, winSCP ή Putty και αφήνω αυτή την κονσόλα ανοιχτή για αργότερα.
## Βήμα 2: Δημιουργία φακέλου NETBOX
Δημιουργώ έναν νέο κατάλογο με όνομα "netbox" στον κατάλογο Docker.
{{< gallery match="images/3/*.png" >}}
Τώρα πρέπει να κατεβάσετε το ακόλουθο αρχείο και να το αποσυμπιέσετε στον κατάλογο: https://github.com/netbox-community/netbox-docker/archive/refs/heads/release.zip. Χρησιμοποιώ την κονσόλα γι' αυτό:
{{< terminal >}}
cd /volume1/docker/netbox/
sudo wget https://github.com/netbox-community/netbox-docker/archive/refs/heads/release.zip
sudo /bin/7z x release.zip
cd netbox-docker-release
sudo mkdir netbox-media-files
sudo mkdir netbox-redis-data
sudo mkdir netbox-postgres-data

{{</ terminal >}}
Στη συνέχεια, επεξεργάζομαι το αρχείο "docker/docker-compose.yml" και καταχωρώ τις διευθύνσεις Synology στα "netbox-media-files", "netbox-postgres-data" και "netbox-redis-data":
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
Μετά από αυτό μπορώ να ξεκινήσω το αρχείο Compose:
{{< terminal >}}
sudo docker-compose up

{{</ terminal >}}
Η δημιουργία της βάσης δεδομένων μπορεί να διαρκέσει λίγο χρόνο. Η συμπεριφορά μπορεί να παρατηρηθεί μέσω των λεπτομερειών του δοχείου.
{{< gallery match="images/4/*.png" >}}
Καλώ τον διακομιστή netbox με τη διεύθυνση IP της Synology και τη θύρα του εμπορευματοκιβωτίου μου.
{{< gallery match="images/5/*.png" >}}