+++
date = "2020-02-28"
title = "Μεγάλα πράγματα με κοντέινερ: Εκτέλεση του Papermerge DMS σε ένα Synology NAS"
difficulty = "level-3"
tags = ["archiv", "automatisch", "dms", "Docker", "Document-Managment-System", "google", "ocr", "papermerge", "Synology", "tesseract", "texterkennung"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2020/february/20200228-docker-papermerge/index.el.md"
+++
Το Papermerge είναι ένα νεανικό σύστημα διαχείρισης εγγράφων (DMS) που μπορεί να αναθέτει και να επεξεργάζεται αυτόματα έγγραφα. Σε αυτό το σεμινάριο δείχνω πώς εγκατέστησα το Papermerge στο σταθμό δίσκων Synology και πώς λειτουργεί το DMS.
## Επιλογή για επαγγελματίες
Ως έμπειρος χρήστης της Synology, μπορείτε φυσικά να συνδεθείτε με SSH και να εγκαταστήσετε ολόκληρη τη ρύθμιση μέσω του αρχείου Docker Compose.
```
version: "2.1"
services:
  papermerge:
    image: ghcr.io/linuxserver/papermerge
    container_name: papermerge
    environment:
      - PUID=1024
      - PGID=100
      - TZ=Europe/Berlin
    volumes:
      - ./config>:/config
      - ./appdata/data>:/data
    ports:
      - 8090:8000
    restart: unless-stopped

```

## Βήμα 1: Δημιουργία φακέλου
Πρώτα δημιουργώ έναν φάκελο για τη συγχώνευση εγγράφων. Πηγαίνω στο "Έλεγχος συστήματος" -> "Κοινόχρηστος φάκελος" και δημιουργώ έναν νέο φάκελο με όνομα "Αρχείο εγγράφων".
{{< gallery match="images/1/*.png" >}}
Βήμα 2: Αναζήτηση για εικόνα DockerΚάνω κλικ στην καρτέλα "Registration" στο παράθυρο Synology Docker και αναζητώ το "Papermerge". Επιλέγω την εικόνα Docker "linuxserver/papermerge" και στη συνέχεια κάνω κλικ στην ετικέτα "latest".
{{< gallery match="images/2/*.png" >}}
Μετά τη λήψη της εικόνας, η εικόνα είναι διαθέσιμη ως εικόνα. Το Docker διακρίνει μεταξύ 2 καταστάσεων, του εμπορευματοκιβωτίου "δυναμική κατάσταση" και της εικόνας/εικόνας (σταθερή κατάσταση). Πριν μπορέσουμε να δημιουργήσουμε ένα δοχείο από την εικόνα, πρέπει να γίνουν μερικές ρυθμίσεις.
## Βήμα 3: Θέστε την εικόνα σε λειτουργία:
Κάνω διπλό κλικ στην εικόνα συγχώνευσης χαρτιού.
{{< gallery match="images/3/*.png" >}}
Στη συνέχεια κάνω κλικ στο "Ρυθμίσεις για προχωρημένους" και ενεργοποιώ την "Αυτόματη επανεκκίνηση". Επιλέγω την καρτέλα "Τόμος" και κάνω κλικ στο "Προσθήκη φακέλου". Εκεί δημιουργώ έναν νέο φάκελο βάσης δεδομένων με τη διαδρομή προσάρτησης "/data".
{{< gallery match="images/4/*.png" >}}
Αποθηκεύω επίσης έναν δεύτερο φάκελο εδώ, τον οποίο συμπεριλαμβάνω στη διαδρομή προσάρτησης "/config". Δεν έχει σημασία πού βρίσκεται αυτός ο φάκελος. Ωστόσο, είναι σημαντικό να ανήκει στον χρήστη Synology admin.
{{< gallery match="images/5/*.png" >}}
Ορίζω σταθερές θύρες για το εμπορευματοκιβώτιο "Papermerge". Χωρίς σταθερές θύρες, μπορεί ο "διακομιστής Papermerge" να εκτελείται σε διαφορετική θύρα μετά από επανεκκίνηση.
{{< gallery match="images/6/*.png" >}}
Τέλος, εισάγω τρεις μεταβλητές περιβάλλοντος. Η μεταβλητή "PUID" είναι το αναγνωριστικό χρήστη και το "PGID" είναι το αναγνωριστικό ομάδας του χρήστη διαχειριστή μου. Μπορείτε να μάθετε το PGID/PUID μέσω SSH με την εντολή "cat /etc/passwd | grep admin".
{{< gallery match="images/7/*.png" >}}
Μετά από αυτές τις ρυθμίσεις, ο διακομιστής Papermerge μπορεί να ξεκινήσει! Στη συνέχεια, το Papermerge μπορεί να κληθεί μέσω της διεύθυνσης Ip της συσκευής Synology και της θύρας που έχει εκχωρηθεί, για παράδειγμα http://192.168.21.23:8095.
{{< gallery match="images/8/*.png" >}}
Η προεπιλεγμένη σύνδεση είναι admin με κωδικό πρόσβασης admin.
## Πώς λειτουργεί το Papermerge;
Το Papermerge αναλύει το κείμενο εγγράφων και εικόνων. Το Papermerge χρησιμοποιεί μια βιβλιοθήκη OCR/"οπτικής αναγνώρισης χαρακτήρων" που ονομάζεται tesseract και δημοσιεύεται από την Goolge.
{{< gallery match="images/9/*.png" >}}
Δημιούργησα έναν φάκελο με τίτλο "Everything with Lorem" για να δοκιμάσω την αυτόματη ανάθεση εγγράφων. Στη συνέχεια, έκανα κλικ μαζί σε ένα νέο μοτίβο αναγνώρισης στο στοιχείο μενού "Αυτοματοποιήσεις".
{{< gallery match="images/10/*.png" >}}
Όλα τα νέα έγγραφα που περιέχουν τη λέξη "Lorem" τοποθετούνται στο φάκελο "Everything with Lorem" και έχουν την ετικέτα "has-lorem". Είναι σημαντικό να χρησιμοποιείτε κόμμα στις ετικέτες, διαφορετικά η ετικέτα δεν θα οριστεί. Εάν ανεβάσετε ένα έγγραφο, θα επισημανθεί και θα ταξινομηθεί.
{{< gallery match="images/11/*.png" >}}
