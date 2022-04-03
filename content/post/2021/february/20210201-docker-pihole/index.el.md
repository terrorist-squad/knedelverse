+++
date = "2021-02-01"
title = "Μεγάλα πράγματα με δοχεία: Pihole στον Synology DiskStation"
difficulty = "level-3"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "dns", "adblocker", "fritzbox"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/february/20210201-docker-pihole/index.el.md"
+++
Σήμερα θα σας δείξω πώς να εγκαταστήσετε μια υπηρεσία Pihole στο σταθμό δίσκων Synology και να τη συνδέσετε στο Fritzbox.
## Βήμα 1: Προετοιμάστε τη Synology
Πρώτον, η σύνδεση SSH πρέπει να ενεργοποιηθεί στον DiskStation. Για να το κάνετε αυτό, μεταβείτε στον "Πίνακα Ελέγχου" > "Τερματικό
{{< gallery match="images/1/*.png" >}}
Στη συνέχεια, μπορείτε να συνδεθείτε μέσω "SSH", της καθορισμένης θύρας και του κωδικού πρόσβασης διαχειριστή (οι χρήστες των Windows χρησιμοποιούν το Putty ή το WinSCP).
{{< gallery match="images/2/*.png" >}}
Συνδέομαι μέσω Terminal, winSCP ή Putty και αφήνω αυτή την κονσόλα ανοιχτή για αργότερα.
## Βήμα 2: Δημιουργία φακέλου Pihole
Δημιουργώ έναν νέο κατάλογο με όνομα "pihole" στον κατάλογο Docker.
{{< gallery match="images/3/*.png" >}}
Στη συνέχεια μεταβαίνω στον νέο κατάλογο και δημιουργώ δύο φακέλους "etc-pihole" και "etc-dnsmasq.d":
{{< terminal >}}
cd /volume1/docker/
mkdir -p {etc-pihole,etc-dnsmasq.d}

{{</ terminal >}}
Τώρα το ακόλουθο αρχείο Docker Compose με όνομα "pihole.yml" πρέπει να τοποθετηθεί στον κατάλογο Pihole:
```
version: "3"

services:
  pihole:
    container_name: pihole
    image: pihole/pihole:latest
    ports:
      - "53:53/tcp"
      - "53:53/udp"
      - "67:67/udp"
      - "8080:80/tcp"
    environment:
      TZ: 'Europe/Berlin'
      WEBPASSWORD: 'password'
    volumes:
      - './etc-pihole/:/etc/pihole/'
      - './etc-dnsmasq.d/:/etc/dnsmasq.d/'
    cap_add:
      - NET_ADMIN
    restart: unless-stopped

```
Το εμπορευματοκιβώτιο μπορεί τώρα να ξεκινήσει:
{{< terminal >}}
sudo docker-compose up -d

{{</ terminal >}}
Καλώ τον διακομιστή Pihole με τη διεύθυνση IP της Synology και τη θύρα του εμπορευματοκιβωτίου μου και συνδέομαι με τον κωδικό πρόσβασης WEBPASSWORD.
{{< gallery match="images/4/*.png" >}}
Τώρα μπορείτε να αλλάξετε τη διεύθυνση DNS στο Fritzbox στην ενότητα "Home Network" > "Network" > "Network Settings".
{{< gallery match="images/5/*.png" >}}
