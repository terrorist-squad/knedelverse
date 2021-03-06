+++
date = "2020-02-27"
title = "Μεγάλα πράγματα με δοχεία: Εκτέλεση του προγράμματος λήψης Youtube στο Synology Diskstation"
difficulty = "level-1"
tags = ["Docker", "docker-compose", "download", "linux", "Synology", "video", "youtube"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2020/february/20200227-docker-youtube-dl/index.el.md"
+++
Πολλοί από τους φίλους μου γνωρίζουν ότι διαχειρίζομαι μια ιδιωτική πύλη βίντεο εκμάθησης στο Homelab - Network. Έχω αποθηκεύσει μαθήματα βίντεο από προηγούμενες συνδρομές σε εκπαιδευτικές πύλες και καλά σεμινάρια στο Youtube για χρήση εκτός σύνδεσης στο NAS μου.
{{< gallery match="images/1/*.png" >}}
Με την πάροδο του χρόνου έχω συλλέξει 8845 μαθήματα βίντεο με 282616 μεμονωμένα βίντεο. Ο συνολικός χρόνος λειτουργίας είναι περίπου 2 χρόνια. Σε αυτό το σεμινάριο δείχνω πώς να δημιουργήσετε αντίγραφα ασφαλείας καλών σεμιναρίων στο Youtube με μια υπηρεσία λήψης Docker για offline σκοπούς.
## Επιλογή για επαγγελματίες
Ως έμπειρος χρήστης της Synology, μπορείτε φυσικά να συνδεθείτε με SSH και να εγκαταστήσετε ολόκληρη τη ρύθμιση μέσω του αρχείου Docker Compose.
```
version: "2"
services:
  youtube-dl:
    image: modenaf360/youtube-dl-nas
    container_name: youtube-dl
    environment:
      - MY_ID=admin
      - MY_PW=admin
    volumes:
      - ./YouTube:/downfolder
    ports:
      - 8080:8080
    restart: unless-stopped

```

## Βήμα 1
Πρώτα δημιουργώ έναν φάκελο για τις λήψεις. Πηγαίνω στο "Έλεγχος συστήματος" -> "Κοινόχρηστος φάκελος" και δημιουργώ έναν νέο φάκελο με όνομα "Λήψεις".
{{< gallery match="images/2/*.png" >}}

## Βήμα 2: Αναζήτηση για εικόνα Docker
Κάνω κλικ στην καρτέλα "Registration" στο παράθυρο Synology Docker και αναζητώ το "youtube-dl-nas". Επιλέγω την εικόνα Docker "modenaf360/youtube-dl-nas" και στη συνέχεια κάνω κλικ στην ετικέτα "latest".
{{< gallery match="images/3/*.png" >}}
Μετά τη λήψη της εικόνας, η εικόνα είναι διαθέσιμη ως εικόνα. Το Docker διακρίνει μεταξύ 2 καταστάσεων, του εμπορευματοκιβωτίου "δυναμική κατάσταση" και της εικόνας/εικόνας (σταθερή κατάσταση). Πριν μπορέσουμε να δημιουργήσουμε ένα δοχείο από την εικόνα, πρέπει να γίνουν μερικές ρυθμίσεις.
## Βήμα 3: Θέστε την εικόνα σε λειτουργία:
Κάνω διπλό κλικ στην εικόνα μου youtube-dl-nas.
{{< gallery match="images/4/*.png" >}}
Στη συνέχεια κάνω κλικ στο "Ρυθμίσεις για προχωρημένους" και ενεργοποιώ την "Αυτόματη επανεκκίνηση". Επιλέγω την καρτέλα "Τόμος" και κάνω κλικ στο "Προσθήκη φακέλου". Εκεί δημιουργώ έναν νέο φάκελο βάσης δεδομένων με τη διαδρομή προσάρτησης "/downfolder".
{{< gallery match="images/5/*.png" >}}
Ορίζω σταθερές θύρες για το δοχείο "Youtube Downloader". Χωρίς σταθερές θύρες, θα μπορούσε το "Youtube Downloader" να εκτελείται σε διαφορετική θύρα μετά από επανεκκίνηση.
{{< gallery match="images/6/*.png" >}}
Τέλος, εισάγω δύο μεταβλητές περιβάλλοντος. Η μεταβλητή "MY_ID" είναι το όνομα χρήστη μου και "MY_PW" είναι ο κωδικός μου.
{{< gallery match="images/7/*.png" >}}
Μετά από αυτές τις ρυθμίσεις, ο Downloader μπορεί να ξεκινήσει! Στη συνέχεια, μπορείτε να καλέσετε το πρόγραμμα λήψης μέσω της διεύθυνσης Ip της συσκευής Synology και της θύρας που έχει εκχωρηθεί, για παράδειγμα http://192.168.21.23:8070 .
{{< gallery match="images/8/*.png" >}}
Για τον έλεγχο ταυτότητας, πάρτε το όνομα χρήστη και τον κωδικό πρόσβασης από τα MY_ID και MY_PW.
## Βήμα 4: Πάμε
Τώρα μπορείτε να εισαγάγετε στο πεδίο "URL" τα urls βίντεο του Youtube και τα urls λίστας αναπαραγωγής και όλα τα βίντεο θα καταλήγουν αυτόματα στο φάκελο λήψης του σταθμού δίσκου Synology.
{{< gallery match="images/9/*.png" >}}
Κατεβάστε το φάκελο:
{{< gallery match="images/10/*.png" >}}
