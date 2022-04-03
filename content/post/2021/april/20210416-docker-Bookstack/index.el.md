+++
date = "2021-04-16"
title = "Μεγάλα πράγματα με κοντέινερ: Το δικό σας Bookstack Wiki στον Synology DiskStation"
difficulty = "level-1"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "bookstack", "wiki"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210416-docker-Bookstack/index.el.md"
+++
Το Bookstack είναι μια εναλλακτική λύση "ανοιχτού κώδικα" στο MediaWiki ή το Confluence. Σήμερα θα σας δείξω πώς να εγκαταστήσετε μια υπηρεσία Bookstack στο σταθμό δίσκων της Synology.
## Επιλογή για επαγγελματίες
Ως έμπειρος χρήστης της Synology, μπορείτε φυσικά να συνδεθείτε με SSH και να εγκαταστήσετε ολόκληρη τη ρύθμιση μέσω του αρχείου Docker Compose.
```
version: '3'
services:
  bookstack:
    image: solidnerd/bookstack:0.27.4-1
    restart: always
    ports:
      - 8080:8080
    links:
      - database
    environment:
      DB_HOST: database:3306
      DB_DATABASE: my_wiki
      DB_USERNAME: wikiuser
      DB_PASSWORD: my_wiki_pass
      
  database:
    image: mariadb
    restart: always
    volumes:
       - ./mysql:/var/lib/mysql
    environment:
      MYSQL_ROOT_PASSWORD: my_wiki_pass1
      MYSQL_DATABASE: my_wiki
      MYSQL_USER: wikiuser
      MYSQL_PASSWORD: my_wiki_pass

```
Περισσότερες χρήσιμες εικόνες Docker για οικιακή χρήση μπορείτε να βρείτε στο [Dockerverse]({{< ref "dockerverse" >}} "Dockerverse").
## Βήμα 1: Προετοιμάστε το φάκελο bookstack
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
|TZ	| Europe/Berlin |Ζώνη ώρας|
|MYSQL_ROOT_PASSWORD	|  my_wiki_pass |Κύριος κωδικός πρόσβασης της βάσης δεδομένων.|
|MYSQL_DATABASE | 	my_wiki	|Αυτό είναι το όνομα της βάσης δεδομένων.|
|MYSQL_USER	|  wikiuser	|Όνομα χρήστη της βάσης δεδομένων του wiki.|
|MYSQL_PASSWORD	|  my_wiki_pass	|Κωδικός πρόσβασης του χρήστη της βάσης δεδομένων wiki.|
{{</table>}}
Τέλος, εισάγω αυτές τις μεταβλητές περιβάλλοντος:Βλέπε:
{{< gallery match="images/6/*.png" >}}
Μετά από αυτές τις ρυθμίσεις, ο διακομιστής Mariadb μπορεί να ξεκινήσει! Πατάω παντού το "Apply".
## Βήμα 3: Εγκαταστήστε το Bookstack
Κάνω κλικ στην καρτέλα "Registration" στο παράθυρο Synology Docker και αναζητώ το "bookstack". Επιλέγω την εικόνα Docker "solidnerd/bookstack" και στη συνέχεια κάνω κλικ στην ετικέτα "latest".
{{< gallery match="images/7/*.png" >}}
Κάνω διπλό κλικ στην εικόνα του Bookstack. Στη συνέχεια, κάνω κλικ στην επιλογή "Ρυθμίσεις για προχωρημένους" και ενεργοποιώ και εδώ την "Αυτόματη επανεκκίνηση".
{{< gallery match="images/8/*.png" >}}
Ορίζω σταθερές θύρες για το δοχείο "bookstack". Χωρίς σταθερές θύρες, μπορεί ο "bookstack server" να τρέχει σε διαφορετική θύρα μετά από επανεκκίνηση. Η πρώτη θύρα εμπορευματοκιβωτίου μπορεί να διαγραφεί. Θα πρέπει να θυμόμαστε το άλλο λιμάνι.
{{< gallery match="images/9/*.png" >}}
Επιπλέον, πρέπει να δημιουργηθεί ένας "σύνδεσμος" προς το δοχείο "mariadb". Κάνω κλικ στην καρτέλα "Σύνδεσμοι" και επιλέγω το δοχείο βάσης δεδομένων. Το ψευδώνυμο θα πρέπει να διατηρηθεί για την εγκατάσταση του wiki.
{{< gallery match="images/10/*.png" >}}
{{<table "table table-striped table-bordered">}}
|Όνομα μεταβλητής|Αξία|Τι είναι αυτό;|
|--- | --- |---|
|TZ	| Europe/Berlin |Ζώνη ώρας|
|DB_HOST	| wiki-db:3306	|Ονόματα ψευδώνυμων / σύνδεσμος δοχείου|
|DB_DATABASE	| my_wiki |Δεδομένα από το βήμα 2|
|DB_USERNAME	| wikiuser |Δεδομένα από το βήμα 2|
|DB_PASSWORD	| my_wiki_pass	|Δεδομένα από το βήμα 2|
{{</table>}}
Τέλος, εισάγω αυτές τις μεταβλητές περιβάλλοντος:Βλέπε:
{{< gallery match="images/11/*.png" >}}
Το εμπορευματοκιβώτιο μπορεί τώρα να ξεκινήσει. Η δημιουργία της βάσης δεδομένων μπορεί να διαρκέσει λίγο χρόνο. Η συμπεριφορά μπορεί να παρατηρηθεί μέσω των λεπτομερειών του δοχείου.
{{< gallery match="images/12/*.png" >}}
Καλώ τον διακομιστή Bookstack με τη διεύθυνση IP της Synology και τη θύρα του εμπορευματοκιβωτίου μου. Το όνομα σύνδεσης είναι "admin@admin.com" και ο κωδικός πρόσβασης είναι "password".
{{< gallery match="images/13/*.png" >}}

