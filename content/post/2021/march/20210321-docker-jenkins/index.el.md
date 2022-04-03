+++
date = "2021-03-21"
title = "Μεγάλα πράγματα με κοντέινερ: Εκτέλεση του Jenkins στο Synology DS"
difficulty = "level-3"
tags = ["build", "devops", "diskstation", "java", "javascript", "Jenkins", "nas", "Synology"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/march/20210321-docker-jenkins/index.el.md"
+++

## Βήμα 1: Προετοιμάστε τη Synology
Πρώτον, η σύνδεση SSH πρέπει να ενεργοποιηθεί στον DiskStation. Για να το κάνετε αυτό, μεταβείτε στον "Πίνακα Ελέγχου" > "Τερματικό
{{< gallery match="images/1/*.png" >}}
Στη συνέχεια, μπορείτε να συνδεθείτε μέσω "SSH", της καθορισμένης θύρας και του κωδικού πρόσβασης διαχειριστή (οι χρήστες των Windows χρησιμοποιούν το Putty ή το WinSCP).
{{< gallery match="images/2/*.png" >}}
Συνδέομαι μέσω Terminal, winSCP ή Putty και αφήνω αυτή την κονσόλα ανοιχτή για αργότερα.
## Βήμα 2: Προετοιμάστε το φάκελο Docker
Δημιουργώ έναν νέο κατάλογο με όνομα "jenkins" στον κατάλογο Docker.
{{< gallery match="images/3/*.png" >}}
Στη συνέχεια αλλάζω στο νέο κατάλογο και δημιουργώ ένα νέο φάκελο "data":
{{< terminal >}}
sudo mkdir data

{{</ terminal >}}
Δημιουργώ επίσης ένα αρχείο με όνομα "jenkins.yml" με το ακόλουθο περιεχόμενο. Το μπροστινό μέρος της θύρας "8081:" μπορεί να ρυθμιστεί.
```
version: '2.0'
services:
  jenkins:
    restart: always
    image: jenkins/jenkins:lts
    privileged: true
    user: root
    ports:
      - 8081:8080
    container_name: jenkins
    volumes:
      - ./data:/var/jenkins_home
      - /var/run/docker.sock:/var/run/docker.sock
      - /usr/local/bin/docker:/usr/local/bin/docker

```

## Βήμα 3: Έναρξη
Μπορώ επίσης να χρησιμοποιήσω την κονσόλα σε αυτό το βήμα. Εκκινώ τον διακομιστή Jenkins μέσω του Docker Compose.
{{< terminal >}}
sudo docker-compose -f jenkins.yml up -d

{{</ terminal >}}
Μετά από αυτό, μπορώ να καλέσω τον διακομιστή Jenkins με την IP του σταθμού δίσκου και την εκχωρημένη θύρα από το "Βήμα 2".
{{< gallery match="images/4/*.png" >}}

## Βήμα 4: Ρύθμιση

{{< gallery match="images/5/*.png" >}}
Και πάλι, χρησιμοποιώ την κονσόλα για να διαβάσω τον αρχικό κωδικό πρόσβασης:
{{< terminal >}}
cat data/secrets/initialAdminPassword

{{</ terminal >}}
Βλέπε:
{{< gallery match="images/6/*.png" >}}
Έχω επιλέξει τη "Συνιστώμενη εγκατάσταση".
{{< gallery match="images/7/*.png" >}}

## Βήμα 5: Η πρώτη μου δουλειά
Συνδέομαι και δημιουργώ την εργασία Docker.
{{< gallery match="images/8/*.png" >}}
Όπως μπορείτε να δείτε, όλα λειτουργούν τέλεια!
{{< gallery match="images/9/*.png" >}}
