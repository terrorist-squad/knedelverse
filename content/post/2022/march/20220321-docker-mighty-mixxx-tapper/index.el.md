+++
date = "2022-03-21"
title = "Μεγάλα πράγματα με δοχεία: Εγγραφή MP3 από το ραδιόφωνο"
difficulty = "level-1"
tags = ["diskstation", "Docker", "docker-compose", "docker-for-desktop", "radio", "mp3", "ripp", "streamripper", "radiorecorder"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2022/march/20220321-docker-mighty-mixxx-tapper/index.el.md"
+++
Το Streamripper είναι ένα εργαλείο για τη γραμμή εντολών που μπορεί να χρησιμοποιηθεί για την εγγραφή ροών MP3 ή OGG/Vorbis και την αποθήκευσή τους απευθείας στο σκληρό δίσκο. Τα τραγούδια ονομάζονται αυτόματα με το όνομα του καλλιτέχνη και αποθηκεύονται ξεχωριστά, ενώ η μορφή είναι αυτή που στάλθηκε αρχικά (οπότε στην πραγματικότητα δημιουργούνται αρχεία με την επέκταση .mp3 ή .ogg). Βρήκα μια εξαιρετική διεπαφή radiorecorder και έφτιαξα μια εικόνα Docker από αυτήν, δείτε: https://github.com/terrorist-squad/mightyMixxxTapper/
{{< gallery match="images/1/*.png" >}}

## Επιλογή για επαγγελματίες
Ως έμπειρος χρήστης της Synology, μπορείτε φυσικά να συνδεθείτε με SSH και να εγκαταστήσετε ολόκληρη τη ρύθμιση μέσω του αρχείου Docker Compose.
```
version: "2.0"
services:
  mealie:
    container_name: mighty-mixxx-tapper
    image: chrisknedel/mighty-mixxx-tapper:latest
    restart: always
    ports:
      - 9000:80
    environment:
      TZ: Europa/Berlin
    volumes:
      - ./ripps/:/tmp/ripps/

```

## Βήμα 1: Αναζήτηση εικόνας Docker
Κάνω κλικ στην καρτέλα "Registration" στο παράθυρο Synology Docker και αναζητώ το "mighty-mixxx-tapper". Επιλέγω την εικόνα Docker "chrisknedel/mighty-mixxx-tapper" και στη συνέχεια κάνω κλικ στην ετικέτα "latest".
{{< gallery match="images/2/*.png" >}}
Μετά τη λήψη της εικόνας, η εικόνα είναι διαθέσιμη ως εικόνα. Το Docker διακρίνει μεταξύ 2 καταστάσεων, του εμπορευματοκιβωτίου "δυναμική κατάσταση" και της εικόνας/εικόνας (σταθερή κατάσταση). Πριν μπορέσουμε να δημιουργήσουμε ένα δοχείο από την εικόνα, πρέπει να γίνουν μερικές ρυθμίσεις.
## Βήμα 2: Θέστε την εικόνα σε λειτουργία:
Κάνω διπλό κλικ στην εικόνα "mighty-mixxx-tapper".
{{< gallery match="images/3/*.png" >}}
Στη συνέχεια κάνω κλικ στο "Ρυθμίσεις για προχωρημένους" και ενεργοποιώ την "Αυτόματη επανεκκίνηση". Επιλέγω την καρτέλα "Τόμος" και κάνω κλικ στο "Προσθήκη φακέλου". Εκεί δημιουργώ έναν νέο φάκελο με τη διαδρομή προσάρτησης "/tmp/ripps/".
{{< gallery match="images/4/*.png" >}}
Ορίζω σταθερές θύρες για το δοχείο "mighty-mixxx-tapper". Χωρίς σταθερές θύρες, θα μπορούσε ο "mighty-mixxx-tapper-server" να εκτελείται σε διαφορετική θύρα μετά από επανεκκίνηση.
{{< gallery match="images/5/*.png" >}}
Μετά από αυτές τις ρυθμίσεις, ο mighty-mixxx-tapper-server μπορεί να ξεκινήσει! Στη συνέχεια, μπορείτε να καλέσετε το mighty-mixxx-tapper μέσω της διεύθυνσης Ip της συσκευής Synology και της θύρας που έχει εκχωρηθεί, για παράδειγμα http://192.168.21.23:8097.
{{< gallery match="images/6/*.png" >}}
