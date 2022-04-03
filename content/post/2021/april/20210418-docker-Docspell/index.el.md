+++
date = "2021-04-18"
title = "Μεγάλα πράγματα με δοχεία: Εκτέλεση του Docspell DMS στον Synology DiskStation"
difficulty = "level-2"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "Document-Managment-System"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210418-docker-Docspell/index.el.md"
+++
Το Docspell είναι ένα σύστημα διαχείρισης εγγράφων για τον Synology DiskStation. Μέσω του Docspell, τα έγγραφα μπορούν να ευρετηριαστούν, να αναζητηθούν και να βρεθούν πολύ ταχύτερα. Σήμερα θα σας δείξω πώς να εγκαταστήσετε μια υπηρεσία Docspell στο σταθμό δίσκων Synology.
## Βήμα 1: Προετοιμάστε τη Synology
Πρώτον, η σύνδεση SSH πρέπει να ενεργοποιηθεί στον DiskStation. Για να το κάνετε αυτό, μεταβείτε στον "Πίνακα Ελέγχου" > "Τερματικό
{{< gallery match="images/1/*.png" >}}
Στη συνέχεια, μπορείτε να συνδεθείτε μέσω "SSH", της καθορισμένης θύρας και του κωδικού πρόσβασης διαχειριστή (οι χρήστες των Windows χρησιμοποιούν το Putty ή το WinSCP).
{{< gallery match="images/2/*.png" >}}
Συνδέομαι μέσω Terminal, winSCP ή Putty και αφήνω αυτή την κονσόλα ανοιχτή για αργότερα.
## Βήμα 2: Δημιουργία φακέλου Docspel
Δημιουργώ έναν νέο κατάλογο με όνομα "docspell" στον κατάλογο Docker.
{{< gallery match="images/3/*.png" >}}
Τώρα πρέπει να κατεβάσετε το ακόλουθο αρχείο και να το αποσυμπιέσετε στον κατάλογο: https://github.com/eikek/docspell/archive/refs/heads/master.zip . Χρησιμοποιώ την κονσόλα γι' αυτό:
{{< terminal >}}
cd /volume1/docker/docspell/
mkdir docs
mkdir postgres_data
wget https://github.com/eikek/docspell/archive/refs/heads/master.zip 
/bin/7z x master.zip

{{</ terminal >}}
Στη συνέχεια, επεξεργάζομαι το αρχείο "docker/docker-compose.yml" και καταχωρώ τις διευθύνσεις Synology στα πεδία "consumedir" και "db":
{{< gallery match="images/4/*.png" >}}
Μετά από αυτό μπορώ να ξεκινήσω το αρχείο Compose:
{{< terminal >}}
cd docspell-master/docker/
docker-compose up -d

{{</ terminal >}}
Μετά από λίγα λεπτά, μπορώ να καλέσω τον διακομιστή Docspell με την IP του σταθμού δίσκου και την εκχωρημένη θύρα/7878.
{{< gallery match="images/5/*.png" >}}
Η αναζήτηση εγγράφων λειτουργεί καλά. Θεωρώ κρίμα που τα κείμενα στις εικόνες δεν ευρετηριάζονται. Με το Papermerge μπορείτε επίσης να αναζητήσετε κείμενα σε εικόνες.
