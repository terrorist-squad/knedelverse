+++
date = "2020-02-21"
title = "Μεγάλα πράγματα με κοντέινερ: Εκτέλεση του Calibre με το Docker Compose (εγκατάσταση Synology pro)"
difficulty = "level-3"
tags = ["calibre", "calibre-web", "Docker", "docker-compose", "Synology", "linux"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2020/february/20200221-docker-Calibre-pro/index.el.md"
+++
Υπάρχει ήδη ένα ευκολότερο σεμινάριο σε αυτό το ιστολόγιο: [Synology-Nas: Εγκαταστήστε το Calibre Web ως βιβλιοθήκη ebook]({{< ref "post/2020/february/20200213-synology-calibreweb" >}} "Synology-Nas: Εγκαταστήστε το Calibre Web ως βιβλιοθήκη ηλεκτρονικών βιβλίων"). Αυτό το σεμινάριο απευθύνεται σε όλους τους επαγγελματίες της Synology DS.
## Βήμα 1: Προετοιμάστε τη Synology
Πρώτον, η σύνδεση SSH πρέπει να ενεργοποιηθεί στον DiskStation. Για να το κάνετε αυτό, μεταβείτε στον "Πίνακα Ελέγχου" > "Τερματικό
{{< gallery match="images/1/*.png" >}}
Στη συνέχεια, μπορείτε να συνδεθείτε μέσω "SSH", της καθορισμένης θύρας και του κωδικού πρόσβασης διαχειριστή (οι χρήστες των Windows χρησιμοποιούν το Putty ή το WinSCP).
{{< gallery match="images/2/*.png" >}}
Συνδέομαι μέσω Terminal, winSCP ή Putty και αφήνω αυτή την κονσόλα ανοιχτή για αργότερα.
## Βήμα 2: Δημιουργήστε έναν φάκελο βιβλίων
Δημιουργώ έναν νέο φάκελο για τη βιβλιοθήκη Calibre. Για να το κάνω αυτό, καλώ τον "Έλεγχο συστήματος" -> "Κοινόχρηστος φάκελος" και δημιουργώ έναν νέο φάκελο με όνομα "Βιβλία". Αν δεν υπάρχει ακόμα φάκελος "Docker", τότε πρέπει να δημιουργηθεί και αυτός.
{{< gallery match="images/3/*.png" >}}

## Βήμα 3: Προετοιμάστε το φάκελο βιβλίου
Τώρα πρέπει να κατεβάσετε και να αποσυμπιέσετε το ακόλουθο αρχείο: https://drive.google.com/file/d/1zfeU7Jh3FO_jFlWSuZcZQfQOGD0NvXBm/view. Το περιεχόμενο ("metadata.db") πρέπει να τοποθετηθεί στο νέο κατάλογο βιβλίων, βλ:
{{< gallery match="images/4/*.png" >}}

## Βήμα 4: Προετοιμάστε το φάκελο Docker
Δημιουργώ έναν νέο κατάλογο με όνομα "calibre" στον κατάλογο Docker:
{{< gallery match="images/5/*.png" >}}
Στη συνέχεια αλλάζω στο νέο κατάλογο και δημιουργώ ένα νέο αρχείο με όνομα "calibre.yml" με το ακόλουθο περιεχόμενο:
```
version: '2'
services:
  calibre-web:
    image: linuxserver/calibre-web
    container_name: calibre-web-server
    environment:
      - PUID=1026
      - PGID=100
      - TZ=Europe/Berlin
    volumes:
      - /volume1/Buecher:/books
      - /volume1/docker/calibre:/briefkaste
    ports:
      - 8055:8083
    restart: unless-stopped

```
Σε αυτό το νέο αρχείο, πρέπει να προσαρμοστούν διάφορα σημεία ως εξής:* PUID/PGID: Το αναγνωριστικό χρήστη και ομάδας του χρήστη DS πρέπει να εισαχθεί στο PUID/PGID. Εδώ χρησιμοποιώ την κονσόλα από το "Βήμα 1" και τις εντολές "id -u" για να δω το αναγνωριστικό χρήστη. Με την εντολή "id -g" λαμβάνω το αναγνωριστικό της ομάδας.* ports: Για τη θύρα, το μπροστινό μέρος "8055:" πρέπει να προσαρμοστεί.directoriesΌλοι οι κατάλογοι σε αυτό το αρχείο πρέπει να διορθωθούν. Οι σωστές διευθύνσεις φαίνονται στο παράθυρο ιδιοτήτων του DS. (Ακολουθεί στιγμιότυπο οθόνης)
{{< gallery match="images/6/*.png" >}}

## Βήμα 5: Δοκιμαστική εκκίνηση
Μπορώ επίσης να χρησιμοποιήσω την κονσόλα σε αυτό το βήμα. Αλλάζω στον κατάλογο Calibre και ξεκινάω τον διακομιστή Calibre εκεί μέσω του Docker Compose.
{{< terminal >}}
cd /volume1/docker/calibre
sudo docker-compose -f calibre.yml up -d

{{</ terminal >}}

{{< gallery match="images/7/*.png" >}}

## Βήμα 6: Ρύθμιση
Στη συνέχεια, μπορώ να καλέσω τον διακομιστή Calibre με την IP του σταθμού δίσκου και την εκχωρημένη θύρα από το "Βήμα 4". Χρησιμοποιώ το σημείο προσάρτησης "/books" στη ρύθμιση. Μετά από αυτό, ο διακομιστής είναι ήδη χρησιμοποιήσιμος.
{{< gallery match="images/8/*.png" >}}

## Βήμα 7: Οριστικοποίηση της εγκατάστασης
Η κονσόλα είναι επίσης απαραίτητη σε αυτό το βήμα. Χρησιμοποιώ την εντολή "exec" για να αποθηκεύσω τη βάση δεδομένων της εσωτερικής εφαρμογής του εμπορευματοκιβωτίου.
{{< terminal >}}
sudo docker exec -it calibre-web-server cp /app/calibre-web/app.db /briefkaste/app.db

{{</ terminal >}}
Μετά από αυτό βλέπω ένα νέο αρχείο "app.db" στον κατάλογο Calibre:
{{< gallery match="images/9/*.png" >}}
Στη συνέχεια σταματάω τον διακομιστή Calibre:
{{< terminal >}}
sudo docker-compose -f calibre.yml down

{{</ terminal >}}
Τώρα αλλάζω τη διαδρομή του letterbox και διατηρώ τη βάση δεδομένων της εφαρμογής σε αυτήν.
```
version: '2'
services:
  calibre-web:
    image: linuxserver/calibre-web
    container_name: calibre-web-server
    environment:
      - PUID=1026
      - PGID=100
      - TZ=Europe/Berlin
    volumes:
      - /volume1/Buecher:/books
      - /volume1/docker/calibre/app.db:/app/calibre-web/app.db
    ports:
      - 8055:8083
    restart: unless-stopped

```
Μετά από αυτό, ο διακομιστής μπορεί να επανεκκινηθεί:
{{< terminal >}}
sudo docker-compose -f calibre.yml up -d

{{</ terminal >}}