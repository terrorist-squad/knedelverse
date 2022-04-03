+++
date = "2021-04-25T09:28:11+01:00"
title = "Μεγάλα πράγματα με κοντέινερ: Το Portainer ως εναλλακτική λύση στο Synology Docker GUI"
difficulty = "level-3"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "watchtower"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210425-docker-Portainer/index.el.md"
+++

## Βήμα 1: Προετοιμάστε τη Synology
Πρώτον, η σύνδεση SSH πρέπει να ενεργοποιηθεί στον DiskStation. Για να το κάνετε αυτό, μεταβείτε στον "Πίνακα Ελέγχου" > "Τερματικό
{{< gallery match="images/1/*.png" >}}
Στη συνέχεια, μπορείτε να συνδεθείτε μέσω "SSH", της καθορισμένης θύρας και του κωδικού πρόσβασης διαχειριστή (οι χρήστες των Windows χρησιμοποιούν το Putty ή το WinSCP).
{{< gallery match="images/2/*.png" >}}
Συνδέομαι μέσω Terminal, winSCP ή Putty και αφήνω αυτή την κονσόλα ανοιχτή για αργότερα.
## Βήμα 2: Δημιουργία φακέλου portainer
Δημιουργώ έναν νέο κατάλογο με όνομα "portainer" στον κατάλογο Docker.
{{< gallery match="images/3/*.png" >}}
Στη συνέχεια, πηγαίνω στον κατάλογο portainer με την κονσόλα και δημιουργώ έναν φάκελο και ένα νέο αρχείο με όνομα "portainer.yml" εκεί.
{{< terminal >}}
cd /volume1/docker/portainer
mkdir portainer_data
vim portainer.yml

{{</ terminal >}}
Ακολουθεί το περιεχόμενο του αρχείου "portainer.yml":
```
version: '3'

services:
  portainer:
    image: portainer/portainer:latest
    container_name: portainer
    restart: always
    ports:
      - 90070:9000
      - 9090:8000
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - ./portainer_data:/data

```
Περισσότερες χρήσιμες εικόνες Docker για οικιακή χρήση μπορείτε να βρείτε στο [Dockerverse]({{< ref "dockerverse" >}} "Dockerverse").
## Βήμα 3: Εκκίνηση του δοχείου
Μπορώ επίσης να χρησιμοποιήσω την κονσόλα σε αυτό το βήμα. Εκκινώ τον διακομιστή portainer μέσω του Docker Compose.
{{< terminal >}}
sudo docker-compose -f portainer.yml up -d

{{</ terminal >}}
Στη συνέχεια, μπορώ να καλέσω τον διακομιστή Portainer με την IP του σταθμού δίσκου και την εκχωρημένη θύρα από το "Βήμα 2". Εισάγω τον κωδικό πρόσβασης διαχειριστή και επιλέγω την τοπική παραλλαγή.
{{< gallery match="images/4/*.png" >}}
Όπως μπορείτε να δείτε, όλα λειτουργούν τέλεια!
{{< gallery match="images/5/*.png" >}}
