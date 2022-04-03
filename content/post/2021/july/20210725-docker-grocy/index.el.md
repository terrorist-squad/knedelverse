+++
date = "2021-07-25"
title = "Μεγάλα πράγματα με δοχεία: διαχείριση ψυγείου με το Grocy"
difficulty = "level-1"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "kühlschrank", "erp", "mhd", "Speispläne", "cms", "Cafe", "Bistro"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/july/20210725-docker-grocy/index.el.md"
+++
Με το Grocy μπορείτε να διαχειριστείτε ένα ολόκληρο νοικοκυριό, εστιατόριο, καφετέρια, μπιστρό ή αγορά τροφίμων. Μπορείτε να διαχειρίζεστε ψυγεία, μενού, εργασίες, λίστες αγορών και τη διάρκεια ζωής των τροφίμων.
{{< gallery match="images/1/*.png" >}}
Σήμερα θα σας δείξω πώς να εγκαταστήσετε μια υπηρεσία Grocy στο σταθμό δίσκων Synology.
## Επιλογή για επαγγελματίες
Ως έμπειρος χρήστης της Synology, μπορείτε φυσικά να συνδεθείτε με SSH και να εγκαταστήσετε ολόκληρη τη ρύθμιση μέσω του αρχείου Docker Compose.
```
version: "2.1"
services:
  grocy:
    image: ghcr.io/linuxserver/grocy
    container_name: grocy
    environment:
      - PUID=1024
      - PGID=100
      - TZ=Europe/Berlin
    volumes:
      - ./data:/config
    ports:
      - 9283:80
    restart: unless-stopped

```
Περισσότερες χρήσιμες εικόνες Docker για οικιακή χρήση μπορείτε να βρείτε στο [Dockerverse]({{< ref "dockerverse" >}} "Dockerverse").
## Βήμα 1: Προετοιμάστε το φάκελο Grocy
Δημιουργώ έναν νέο κατάλογο με όνομα "grocy" στον κατάλογο Docker.
{{< gallery match="images/2/*.png" >}}

## Βήμα 2: Εγκαταστήστε το Grocy
Κάνω κλικ στην καρτέλα "Registration" στο παράθυρο Synology Docker και αναζητώ το "Grocy". Επιλέγω την εικόνα Docker "linuxserver/grocy:latest" και στη συνέχεια κάνω κλικ στην ετικέτα "latest".
{{< gallery match="images/3/*.png" >}}
Κάνω διπλό κλικ στην εικόνα του Grocy.
{{< gallery match="images/4/*.png" >}}
Στη συνέχεια, κάνω κλικ στην επιλογή "Ρυθμίσεις για προχωρημένους" και ενεργοποιώ και εδώ την "Αυτόματη επανεκκίνηση". Επιλέγω την καρτέλα "Τόμος" και κάνω κλικ στο "Προσθήκη φακέλου". Εκεί δημιουργώ έναν νέο φάκελο με τη διαδρομή προσάρτησης "/config".
{{< gallery match="images/5/*.png" >}}
Ορίζω σταθερές θύρες για το εμπορευματοκιβώτιο "Grocy". Χωρίς σταθερές θύρες, μπορεί ο "διακομιστής Grocy" να εκτελείται σε διαφορετική θύρα μετά από επανεκκίνηση.
{{< gallery match="images/6/*.png" >}}
{{<table "table table-striped table-bordered">}}
|Όνομα μεταβλητής|Αξία|Τι είναι αυτό;|
|--- | --- |---|
|TZ | Europe/Berlin |Ζώνη ώρας|
|PUID | 1024 |Αναγνωριστικό χρήστη από το Synology Admin User|
|PGID |	100 |Αναγνωριστικό ομάδας από τον χρήστη Synology Admin|
{{</table>}}
Τέλος, εισάγω αυτές τις μεταβλητές περιβάλλοντος:Βλέπε:
{{< gallery match="images/7/*.png" >}}
Το εμπορευματοκιβώτιο μπορεί τώρα να ξεκινήσει. Καλώ τον διακομιστή Grocy με τη διεύθυνση IP της Synology και τη θύρα του εμπορευματοκιβωτίου μου και συνδέομαι με το όνομα χρήστη "admin" και τον κωδικό πρόσβασης "admin".
{{< gallery match="images/8/*.png" >}}

