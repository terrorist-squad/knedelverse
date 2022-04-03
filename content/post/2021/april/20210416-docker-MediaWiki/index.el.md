+++
date = "2021-04-16"
title = "Μεγάλα πράγματα με δοχεία: Εγκαθιστώντας το δικό σας MediaWiki στο σταθμό δίσκων της Synology"
difficulty = "level-1"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "mediawiki", "wiki"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210416-docker-MediaWiki/index.el.md"
+++
Το MediaWiki είναι ένα σύστημα wiki βασισμένο σε PHP που διατίθεται δωρεάν ως προϊόν ανοικτού κώδικα. Σήμερα θα σας δείξω πώς να εγκαταστήσετε μια υπηρεσία MediaWiki στο σταθμό δίσκων Synology.
## Επιλογή για επαγγελματίες
Ως έμπειρος χρήστης της Synology, μπορείτε φυσικά να συνδεθείτε με SSH και να εγκαταστήσετε ολόκληρη τη ρύθμιση μέσω του αρχείου Docker Compose.
```
version: '3'
services:
  mediawiki:
    image: mediawiki
    restart: always
    ports:
      - 8081:80
    links:
      - database
    volumes:
      - ./images:/var/www/html/images
      # After initial setup, download LocalSettings.php to the same directory as
      # this yaml and uncomment the following line and use compose to restart
      # the mediawiki service
      # - ./LocalSettings.php:/var/www/html/LocalSettings.php

  database:
    image: mariadb
    restart: always
    volumes:
       - ./mysql:/var/lib/mysql
    environment:
      # @see https://phabricator.wikimedia.org/source/mediawiki/browse/master/includes/DefaultSettings.php
      MYSQL_ROOT_PASSWORD: my_wiki_pass1
      MYSQL_DATABASE: my_wiki
      MYSQL_USER: wikiuser
      MYSQL_PASSWORD: my_wiki_pass

```
Περισσότερες χρήσιμες εικόνες Docker για οικιακή χρήση μπορείτε να βρείτε στο [Dockerverse]({{< ref "dockerverse" >}} "Dockerverse").
## Βήμα 1: Προετοιμάστε το φάκελο MediaWiki
Δημιουργώ έναν νέο κατάλογο με όνομα "wiki" στον κατάλογο Docker.
{{< gallery match="images/1/*.png" >}}

## Βήμα 2: Εγκατάσταση της βάσης δεδομένων
Στη συνέχεια, πρέπει να δημιουργηθεί μια βάση δεδομένων. Κάνω κλικ στην καρτέλα "Registration" στο παράθυρο Synology Docker και αναζητώ το "mariadb". Επιλέγω την εικόνα Docker "mariadb" και στη συνέχεια κάνω κλικ στην ετικέτα "latest".
{{< gallery match="images/2/*.png" >}}
Μετά τη λήψη της εικόνας, η εικόνα είναι διαθέσιμη ως εικόνα. Το Docker διακρίνει μεταξύ 2 καταστάσεων, του εμπορευματοκιβωτίου "δυναμική κατάσταση" και της εικόνας (σταθερή κατάσταση). Πριν δημιουργήσουμε ένα δοχείο από την εικόνα, πρέπει να γίνουν μερικές ρυθμίσεις. Κάνω διπλό κλικ στην εικόνα mariadb.
{{< gallery match="images/3/*.png" >}}
Στη συνέχεια, κάνω κλικ στην επιλογή "Ρυθμίσεις για προχωρημένους" και ενεργοποιώ την "Αυτόματη επανεκκίνηση". Επιλέγω την καρτέλα "Τόμος" και κάνω κλικ στο "Προσθήκη φακέλου". Εκεί δημιουργώ έναν νέο φάκελο βάσης δεδομένων με τη διαδρομή προσάρτησης "/var/lib/mysql".
{{< gallery match="images/4/*.png" >}}
Στην ενότητα "Ρυθμίσεις θύρας" διαγράφονται όλες οι θύρες. Αυτό σημαίνει ότι επιλέγω τη θύρα "3306" και τη διαγράφω με το κουμπί "-".
{{< gallery match="images/5/*.png" >}}
{{<table "table table-striped table-bordered">}}
|Όνομα μεταβλητής|Αξία|Τι είναι αυτό;|
|--- | --- |---|
|TZ	| Europe/Berlin	|Ζώνη ώρας|
|MYSQL_ROOT_PASSWORD	| my_wiki_pass	|Κύριος κωδικός πρόσβασης της βάσης δεδομένων.|
|MYSQL_DATABASE |	my_wiki	|Αυτό είναι το όνομα της βάσης δεδομένων.|
|MYSQL_USER	| wikiuser |Όνομα χρήστη της βάσης δεδομένων του wiki.|
|MYSQL_PASSWORD	| my_wiki_pass |Κωδικός πρόσβασης του χρήστη της βάσης δεδομένων wiki.|
{{</table>}}
Τέλος, εισάγω αυτές τις μεταβλητές περιβάλλοντος:Βλέπε:
{{< gallery match="images/6/*.png" >}}
Μετά από αυτές τις ρυθμίσεις, ο διακομιστής Mariadb μπορεί να ξεκινήσει! Πατάω παντού το "Apply".
## Βήμα 3: Εγκαταστήστε το MediaWiki
Κάνω κλικ στην καρτέλα "Registration" στο παράθυρο Synology Docker και αναζητώ το "mediawiki". Επιλέγω την εικόνα Docker "mediawiki" και στη συνέχεια κάνω κλικ στην ετικέτα "latest".
{{< gallery match="images/7/*.png" >}}
Κάνω διπλό κλικ στην εικόνα μου στο Mediawiki.
{{< gallery match="images/8/*.png" >}}
Στη συνέχεια, κάνω κλικ στην επιλογή "Ρυθμίσεις για προχωρημένους" και ενεργοποιώ και εδώ την "Αυτόματη επανεκκίνηση". Επιλέγω την καρτέλα "Τόμος" και κάνω κλικ στο "Προσθήκη φακέλου". Εκεί δημιουργώ έναν νέο φάκελο με τη διαδρομή προσάρτησης "/var/www/html/images".
{{< gallery match="images/9/*.png" >}}
Ορίζω σταθερές θύρες για το δοχείο "MediaWiki". Χωρίς σταθερές θύρες, θα μπορούσε ο "διακομιστής MediaWiki" να τρέχει σε διαφορετική θύρα μετά από μια επανεκκίνηση.
{{< gallery match="images/10/*.png" >}}
Επιπλέον, πρέπει να δημιουργηθεί ένας "σύνδεσμος" προς το δοχείο "mariadb". Κάνω κλικ στην καρτέλα "Σύνδεσμοι" και επιλέγω το δοχείο βάσης δεδομένων. Το ψευδώνυμο θα πρέπει να διατηρηθεί για την εγκατάσταση του wiki.
{{< gallery match="images/11/*.png" >}}
Τέλος, εισάγω μια μεταβλητή περιβάλλοντος "TZ" με τιμή "Europe/Berlin".
{{< gallery match="images/12/*.png" >}}
Το εμπορευματοκιβώτιο μπορεί τώρα να ξεκινήσει. Καλώ τον διακομιστή Mediawiki με τη διεύθυνση IP του Synology και τη θύρα του εμπορευματοκιβωτίου μου. Στην περιοχή Διακομιστής βάσης δεδομένων πληκτρολογώ το ψευδώνυμο του δοχείου βάσης δεδομένων. Εισάγω επίσης το όνομα της βάσης δεδομένων, το όνομα χρήστη και τον κωδικό πρόσβασης από το "Βήμα 2".
{{< gallery match="images/13/*.png" >}}
