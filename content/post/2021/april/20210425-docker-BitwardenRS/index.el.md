+++
date = "2021-04-25T09:28:11+01:00"
title = "BitwardenRS στον Synology DiskStation"
difficulty = "level-2"
tags = ["bitwardenrs", "Docker", "docker-compose", "password-manager", "passwort", "Synology"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/april/20210425-docker-BitwardenRS/index.el.md"
+++
Το Bitwarden είναι μια δωρεάν υπηρεσία διαχείρισης κωδικών πρόσβασης ανοικτού κώδικα που αποθηκεύει εμπιστευτικές πληροφορίες, όπως διαπιστευτήρια ιστότοπων, σε ένα κρυπτογραφημένο θησαυροφυλάκιο. Σήμερα δείχνω πώς να εγκαταστήσετε ένα BitwardenRS στον Synology DiskStation.
## Βήμα 1: Προετοιμάστε το φάκελο BitwardenRS
Δημιουργώ έναν νέο κατάλογο με όνομα "bitwarden" στον κατάλογο Docker.
{{< gallery match="images/1/*.png" >}}

## Βήμα 2: Εγκαταστήστε το BitwardenRS
Κάνω κλικ στην καρτέλα "Registration" στο παράθυρο Synology Docker και αναζητώ το "bitwarden". Επιλέγω την εικόνα Docker "bitwardenrs/server" και στη συνέχεια κάνω κλικ στην ετικέτα "latest".
{{< gallery match="images/2/*.png" >}}
Κάνω διπλό κλικ στην εικόνα του bitwardenrs μου. Στη συνέχεια, κάνω κλικ στην επιλογή "Ρυθμίσεις για προχωρημένους" και ενεργοποιώ και εδώ την "Αυτόματη επανεκκίνηση".
{{< gallery match="images/3/*.png" >}}
Επιλέγω την καρτέλα "Τόμος" και κάνω κλικ στο "Προσθήκη φακέλου". Εκεί δημιουργώ έναν νέο φάκελο με τη διαδρομή προσάρτησης "/data".
{{< gallery match="images/4/*.png" >}}
Ορίζω σταθερές θύρες για το δοχείο "bitwardenrs". Χωρίς σταθερές θύρες, θα μπορούσε ο "διακομιστής bitwardenrs" να τρέχει σε διαφορετική θύρα μετά από επανεκκίνηση. Η πρώτη θύρα εμπορευματοκιβωτίου μπορεί να διαγραφεί. Θα πρέπει να θυμόμαστε το άλλο λιμάνι.
{{< gallery match="images/5/*.png" >}}
Το εμπορευματοκιβώτιο μπορεί τώρα να ξεκινήσει. Καλώ τον διακομιστή bitwardenrs με τη διεύθυνση IP του Synology και τη θύρα 8084 του εμπορευματοκιβωτίου μου.
{{< gallery match="images/6/*.png" >}}

## Βήμα 3: Ρύθμιση HTTPS
Επιλέγω "Πίνακας ελέγχου" > "Reverse Proxy" και "Δημιουργία".
{{< gallery match="images/7/*.png" >}}
Μετά από αυτό, μπορώ να καλέσω τον διακομιστή bitwardenrs με τη διεύθυνση IP του Synology και τη θύρα 8085 του διακομιστή μεσολάβησης, κρυπτογραφημένη.
{{< gallery match="images/8/*.png" >}}