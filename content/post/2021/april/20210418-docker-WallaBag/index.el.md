+++
date = "2021-04-18"
title = "Μεγάλα πράγματα με δοχεία: Το δικό σας WallaBag στο σταθμό δίσκων της Synology"
difficulty = "level-1"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "archiv", "wallabag"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/april/20210418-docker-WallaBag/index.el.md"
+++
Το Wallabag είναι ένα πρόγραμμα για την αρχειοθέτηση ενδιαφερουσών ιστοσελίδων ή άρθρων. Σήμερα θα σας δείξω πώς να εγκαταστήσετε μια υπηρεσία Wallabag στο σταθμό δίσκων της Synology.
## Επιλογή για επαγγελματίες
Ως έμπειρος χρήστης της Synology, μπορείτε φυσικά να συνδεθείτε με SSH και να εγκαταστήσετε ολόκληρη τη ρύθμιση μέσω του αρχείου Docker Compose.
```
version: '3'
services:
  wallabag:
    image: wallabag/wallabag
    environment:
      - MYSQL_ROOT_PASSWORD=wallaroot
      - SYMFONY__ENV__DATABASE_DRIVER=pdo_mysql
      - SYMFONY__ENV__DATABASE_HOST=db
      - SYMFONY__ENV__DATABASE_PORT=3306
      - SYMFONY__ENV__DATABASE_NAME=wallabag
      - SYMFONY__ENV__DATABASE_USER=wallabag
      - SYMFONY__ENV__DATABASE_PASSWORD=wallapass
      - SYMFONY__ENV__DATABASE_CHARSET=utf8mb4
      - SYMFONY__ENV__DOMAIN_NAME=http://192.168.178.50:8089
      - SYMFONY__ENV__SERVER_NAME="Your wallabag instance"
      - SYMFONY__ENV__FOSUSER_CONFIRMATION=false
      - SYMFONY__ENV__TWOFACTOR_AUTH=false
    ports:
      - "8089:80"
    volumes:
      - ./wallabag/images:/var/www/wallabag/web/assets/images

  db:
    image: mariadb
    environment:
      - MYSQL_ROOT_PASSWORD=wallaroot
    volumes:
      - ./mariadb:/var/lib/mysql

```
Περισσότερες χρήσιμες εικόνες Docker για οικιακή χρήση μπορείτε να βρείτε στο [Dockerverse]({{< ref "dockerverse" >}} "Dockerverse").
## Βήμα 1: Προετοιμάστε το φάκελο wallabag
Δημιουργώ έναν νέο κατάλογο με όνομα "wallabag" στον κατάλογο Docker.
{{< gallery match="images/1/*.png" >}}

## Βήμα 2: Εγκατάσταση της βάσης δεδομένων
Στη συνέχεια, πρέπει να δημιουργηθεί μια βάση δεδομένων. Κάνω κλικ στην καρτέλα "Registration" στο παράθυρο Synology Docker και αναζητώ το "mariadb". Επιλέγω την εικόνα Docker "mariadb" και στη συνέχεια κάνω κλικ στην ετικέτα "latest".
{{< gallery match="images/2/*.png" >}}
Μετά τη λήψη της εικόνας, η εικόνα είναι διαθέσιμη ως εικόνα. Το Docker διακρίνει μεταξύ 2 καταστάσεων, του εμπορευματοκιβωτίου "δυναμική κατάσταση" και της εικόνας (σταθερή κατάσταση). Πριν δημιουργήσουμε ένα δοχείο από την εικόνα, πρέπει να γίνουν μερικές ρυθμίσεις. Κάνω διπλό κλικ στην εικόνα mariadb.
{{< gallery match="images/3/*.png" >}}
Στη συνέχεια, κάνω κλικ στις "Ρυθμίσεις για προχωρημένους" και ενεργοποιώ την "Αυτόματη επανεκκίνηση". Επιλέγω την καρτέλα "Τόμος" και κάνω κλικ στο "Προσθήκη φακέλου". Εκεί δημιουργώ έναν νέο φάκελο βάσης δεδομένων με τη διαδρομή προσάρτησης "/var/lib/mysql".
{{< gallery match="images/4/*.png" >}}
Στην ενότητα "Ρυθμίσεις θύρας" διαγράφονται όλες οι θύρες. Αυτό σημαίνει ότι επιλέγω τη θύρα "3306" και τη διαγράφω με το κουμπί "-".
{{< gallery match="images/5/*.png" >}}
{{<table "table table-striped table-bordered">}}
|Όνομα μεταβλητής|Αξία|Τι είναι αυτό;|
|--- | --- |---|
|TZ| Europe/Berlin	|Ζώνη ώρας|
|MYSQL_ROOT_PASSWORD	 | wallaroot |Κύριος κωδικός πρόσβασης της βάσης δεδομένων.|
{{</table>}}
Τέλος, εισάγω αυτές τις μεταβλητές περιβάλλοντος:Βλέπε:
{{< gallery match="images/6/*.png" >}}
Μετά από αυτές τις ρυθμίσεις, ο διακομιστής Mariadb μπορεί να ξεκινήσει! Πατάω παντού το "Apply".
{{< gallery match="images/7/*.png" >}}

## Βήμα 3: Εγκαταστήστε το Wallabag
Κάνω κλικ στην καρτέλα "Registration" στο παράθυρο Synology Docker και αναζητώ το "wallabag". Επιλέγω την εικόνα Docker "wallabag/wallabag" και στη συνέχεια κάνω κλικ στην ετικέτα "latest".
{{< gallery match="images/8/*.png" >}}
Κάνω διπλό κλικ στην εικόνα του wallabag μου. Στη συνέχεια, κάνω κλικ στην επιλογή "Ρυθμίσεις για προχωρημένους" και ενεργοποιώ και εδώ την "Αυτόματη επανεκκίνηση".
{{< gallery match="images/9/*.png" >}}
Επιλέγω την καρτέλα "Τόμος" και κάνω κλικ στην επιλογή "Προσθήκη φακέλου". Εκεί δημιουργώ έναν νέο φάκελο με τη διαδρομή προσάρτησης "/var/www/wallabag/web/assets/images".
{{< gallery match="images/10/*.png" >}}
Ορίζω σταθερές θύρες για το δοχείο "wallabag". Χωρίς σταθερές θύρες, μπορεί ο "διακομιστής wallabag" να εκτελείται σε διαφορετική θύρα μετά από επανεκκίνηση. Η πρώτη θύρα εμπορευματοκιβωτίου μπορεί να διαγραφεί. Θα πρέπει να θυμόμαστε το άλλο λιμάνι.
{{< gallery match="images/11/*.png" >}}
Επιπλέον, πρέπει να δημιουργηθεί ένας "σύνδεσμος" προς το δοχείο "mariadb". Κάνω κλικ στην καρτέλα "Σύνδεσμοι" και επιλέγω το δοχείο βάσης δεδομένων. Το όνομα ψευδώνυμο θα πρέπει να το θυμάστε για την εγκατάσταση του wallabag.
{{< gallery match="images/12/*.png" >}}
{{<table "table table-striped table-bordered">}}
|Umgebungsvariable	|Αξία|
|--- |---|
|MYSQL_ROOT_PASSWORD	|wallaroot|
|SYMFONY__ENV__DATABASE_DRIVER	|pdo_mysql|
|SYMFONY__ENV__DATABASE_HOST	|db|
|SYMFONY__ENV__DATABASE_PORT	|3306|
|SYMFONY__ENV__DATABASE_NAME	|wallabag|
|SYMFONY__ENV__DATABASE_USER	|wallabag|
|SYMFONY__ENV__DATABASE_PASSWORD	|wallapass|
|SYMFONY__ENV__DATABASE_CHARSET |utf8mb4|
|SYMFONY__ENV__DOMAIN_NAME	|"http://synology-ip:container-port" <- Παρακαλώ αλλάξτε|
|SYMFONY__ENV__SERVER_NAME	|"Wallabag - Διακομιστής"|
|SYMFONY__ENV__FOSUSER_CONFIRMATION	|false|
|SYMFONY__ENV__TWOFACTOR_AUTH	|false|
{{</table>}}
Τέλος, εισάγω αυτές τις μεταβλητές περιβάλλοντος:Βλέπε:
{{< gallery match="images/13/*.png" >}}
Το εμπορευματοκιβώτιο μπορεί τώρα να ξεκινήσει. Η δημιουργία της βάσης δεδομένων μπορεί να διαρκέσει λίγο χρόνο. Η συμπεριφορά μπορεί να παρατηρηθεί μέσω των λεπτομερειών του δοχείου.
{{< gallery match="images/14/*.png" >}}
Καλώ τον διακομιστή wallabag με τη διεύθυνση IP της Synology και τη θύρα του εμπορευματοκιβωτίου μου.
{{< gallery match="images/15/*.png" >}}
