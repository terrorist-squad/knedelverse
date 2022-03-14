+++
date = "2021-04-18"
title = "Μεγάλα πράγματα με δοχεία: Εγκαθιστώντας το δικό σας dokuWiki στο σταθμό δίσκων της Synology"
difficulty = "level-2"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "dokuwiki", "wiki"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210418-docker-dokuWiki/index.el.md"
+++
Το DokuWiki είναι ένα συμβατό με τα πρότυπα, εύχρηστο και ταυτόχρονα εξαιρετικά ευέλικτο λογισμικό wiki ανοικτού κώδικα. Σήμερα θα σας δείξω πώς να εγκαταστήσετε μια υπηρεσία DokuWiki στο σταθμό δίσκων Synology.
## Επιλογή για επαγγελματίες
Ως έμπειρος χρήστης της Synology, μπορείτε φυσικά να συνδεθείτε με SSH και να εγκαταστήσετε ολόκληρη τη ρύθμιση μέσω του αρχείου Docker Compose.
```
version: '3'
services:
  dokuwiki:
    image:  bitnami/dokuwiki:latest
    restart: always
    ports:
      - 8080:8080
      - 8443:8443
    environment:
      TZ: 'Europe/Berlin'
      DOKUWIKI_USERNAME: 'admin'
      DOKUWIKI_FULL_NAME: 'wiki'
      DOKUWIKI_PASSWORD: 'password'
    volumes:
      - ./data:/bitnami/dokuwiki

```
Περισσότερες χρήσιμες εικόνες Docker για οικιακή χρήση μπορείτε να βρείτε στο [Dockerverse]({{< ref "dockerverse" >}} "Dockerverse").
## Βήμα 1: Προετοιμάστε το φάκελο wiki
Δημιουργώ έναν νέο κατάλογο με όνομα "wiki" στον κατάλογο Docker.
{{< gallery match="images/1/*.png" >}}

## Βήμα 2: Εγκαταστήστε το DokuWiki
Στη συνέχεια, πρέπει να δημιουργηθεί μια βάση δεδομένων. Κάνω κλικ στην καρτέλα "Registration" στο παράθυρο Synology Docker και αναζητώ το "dokuwiki". Επιλέγω την εικόνα Docker "bitnami/dokuwiki" και στη συνέχεια κάνω κλικ στην ετικέτα "latest".
{{< gallery match="images/2/*.png" >}}
Μετά τη λήψη της εικόνας, η εικόνα είναι διαθέσιμη ως εικόνα. Το Docker διακρίνει μεταξύ 2 καταστάσεων, του εμπορευματοκιβωτίου "δυναμική κατάσταση" και της εικόνας (σταθερή κατάσταση). Πριν δημιουργήσουμε ένα δοχείο από την εικόνα, πρέπει να γίνουν μερικές ρυθμίσεις. Κάνω διπλό κλικ στην εικόνα του dokuwiki.
{{< gallery match="images/3/*.png" >}}
Ορίζω σταθερές θύρες για το δοχείο "dokuwiki". Χωρίς σταθερές θύρες, θα μπορούσε ο "διακομιστής dokuwiki" να τρέχει σε διαφορετική θύρα μετά από μια επανεκκίνηση.
{{< gallery match="images/4/*.png" >}}
{{<table "table table-striped table-bordered">}}
|Όνομα μεταβλητής|Αξία|Τι είναι αυτό;|
|--- | --- |---|
|TZ	| Europe/Berlin	|Ζώνη ώρας|
|DOKUWIKI_USERNAME	| admin|Όνομα χρήστη διαχειριστή|
|DOKUWIKI_FULL_NAME |	wiki	|Όνομα WIki|
|DOKUWIKI_PASSWORD	| password	|Κωδικός πρόσβασης διαχειριστή|
{{</table>}}
Τέλος, εισάγω αυτές τις μεταβλητές περιβάλλοντος:Βλέπε:
{{< gallery match="images/5/*.png" >}}
Το εμπορευματοκιβώτιο μπορεί τώρα να ξεκινήσει. Καλώ τον διακομιστή dokuWIki με τη διεύθυνση IP του Synology και τη θύρα του εμπορευματοκιβωτίου μου.
{{< gallery match="images/6/*.png" >}}
