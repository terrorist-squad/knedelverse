+++
date = "2021-04-16"
title = "Μεγάλα πράγματα με κοντέινερ: Εγκαθιστώντας το Wiki.js στο Synology Diskstation"
difficulty = "level-1"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "wikijs", "wiki"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/april/20210416-docker-Wikijs/index.el.md"
+++
Το Wiki.js είναι ένα ισχυρό λογισμικό wiki ανοικτού κώδικα που κάνει την τεκμηρίωση μια ευχαρίστηση με το απλό περιβάλλον εργασίας του. Σήμερα δείχνω πώς να εγκαταστήσετε μια υπηρεσία Wiki.js στον Synology DiskStation.
## Επιλογή για επαγγελματίες
Ως έμπειρος χρήστης της Synology, μπορείτε φυσικά να συνδεθείτε με SSH και να εγκαταστήσετε ολόκληρη τη ρύθμιση μέσω του αρχείου Docker Compose.
```
version: '3'
services:
  wikijs:
    image: requarks/wiki:latest
    restart: always
    ports:
      - 8082:3000
    links:
      - database
    environment:
      DB_TYPE: mysql
      DB_HOST: database
      DB_PORT: 3306
      DB_NAME: my_wiki
      DB_USER: wikiuser
      DB_PASS: my_wiki_pass
      TZ: 'Europe/Berlin'

  database:
    image: mysql
    restart: always
    expose:
      - 3306
    volumes:
       - ./mysql:/var/lib/mysql
    environment:
      MYSQL_ROOT_PASSWORD: my_wiki_pass
      MYSQL_DATABASE: my_wiki
      MYSQL_USER: wikiuser
      MYSQL_PASSWORD: my_wiki_pass

```
Μπορείτε να βρείτε περισσότερες χρήσιμες εικόνες Docker για οικιακή χρήση στο Dockerverse.
## Βήμα 1: Προετοιμάστε το φάκελο wiki
Δημιουργώ έναν νέο κατάλογο με όνομα "wiki" στον κατάλογο Docker.
{{< gallery match="images/1/*.png" >}}

## Βήμα 2: Εγκατάσταση της βάσης δεδομένων
Στη συνέχεια, πρέπει να δημιουργηθεί μια βάση δεδομένων. Κάνω κλικ στην καρτέλα "Registration" στο παράθυρο Synology Docker και αναζητώ το "mysql". Επιλέγω την εικόνα Docker "mysql" και στη συνέχεια κάνω κλικ στην ετικέτα "latest".
{{< gallery match="images/2/*.png" >}}
Μετά τη λήψη της εικόνας, η εικόνα είναι διαθέσιμη ως εικόνα. Το Docker διακρίνει μεταξύ 2 καταστάσεων, του εμπορευματοκιβωτίου "δυναμική κατάσταση" και της εικόνας (σταθερή κατάσταση). Πριν δημιουργήσουμε ένα δοχείο από την εικόνα, πρέπει να γίνουν μερικές ρυθμίσεις. Κάνω διπλό κλικ στην εικόνα mysql.
{{< gallery match="images/3/*.png" >}}
Στη συνέχεια, κάνω κλικ στις "Ρυθμίσεις για προχωρημένους" και ενεργοποιώ την "Αυτόματη επανεκκίνηση". Επιλέγω την καρτέλα "Τόμος" και κάνω κλικ στο "Προσθήκη φακέλου". Εκεί δημιουργώ έναν νέο φάκελο βάσης δεδομένων με τη διαδρομή προσάρτησης "/var/lib/mysql".
{{< gallery match="images/4/*.png" >}}
Στην ενότητα "Ρυθμίσεις θύρας" διαγράφονται όλες οι θύρες. Αυτό σημαίνει ότι επιλέγω τη θύρα "3306" και τη διαγράφω με το κουμπί "-".
{{< gallery match="images/5/*.png" >}}
{{<table "table table-striped table-bordered">}}
|Όνομα μεταβλητής|Αξία|Τι είναι αυτό;|
|--- | --- |---|
|TZ	| Europe/Berlin |Ζώνη ώρας|
|MYSQL_ROOT_PASSWORD	| my_wiki_pass |Κύριος κωδικός πρόσβασης της βάσης δεδομένων.|
|MYSQL_DATABASE |	my_wiki |Αυτό είναι το όνομα της βάσης δεδομένων.|
|MYSQL_USER	| wikiuser |Όνομα χρήστη της βάσης δεδομένων του wiki.|
|MYSQL_PASSWORD |	my_wiki_pass	|Κωδικός πρόσβασης του χρήστη της βάσης δεδομένων wiki.|
{{</table>}}
Τέλος, εισάγω αυτές τις τέσσερις μεταβλητές περιβάλλοντος:Βλέπε:
{{< gallery match="images/6/*.png" >}}
Μετά από αυτές τις ρυθμίσεις, ο διακομιστής Mariadb μπορεί να ξεκινήσει! Πατάω παντού το "Apply".
## Βήμα 3: Εγκαταστήστε το Wiki.js
Κάνω κλικ στην καρτέλα "Registration" στο παράθυρο Synology Docker και αναζητώ το "wiki". Επιλέγω την εικόνα Docker "requarks/wiki" και στη συνέχεια κάνω κλικ στην ετικέτα "latest".
{{< gallery match="images/7/*.png" >}}
Κάνω διπλό κλικ στην εικόνα μου WikiJS. Στη συνέχεια, κάνω κλικ στην επιλογή "Ρυθμίσεις για προχωρημένους" και ενεργοποιώ και εδώ την "Αυτόματη επανεκκίνηση".
{{< gallery match="images/8/*.png" >}}
Ορίζω σταθερές θύρες για το δοχείο "WikiJS". Χωρίς σταθερές θύρες, μπορεί ο "bookstack server" να τρέχει σε διαφορετική θύρα μετά από επανεκκίνηση.
{{< gallery match="images/9/*.png" >}}
Επιπλέον, πρέπει να δημιουργηθεί ένας "σύνδεσμος" προς το δοχείο "mysql". Κάνω κλικ στην καρτέλα "Σύνδεσμοι" και επιλέγω το δοχείο βάσης δεδομένων. Το ψευδώνυμο θα πρέπει να διατηρηθεί για την εγκατάσταση του wiki.
{{< gallery match="images/10/*.png" >}}
{{<table "table table-striped table-bordered">}}
|Όνομα μεταβλητής|Αξία|Τι είναι αυτό;|
|--- | --- |---|
|TZ	| Europe/Berlin	|Ζώνη ώρας|
|DB_HOST	| wiki-db	|Ονόματα ψευδώνυμων / σύνδεσμος δοχείου|
|DB_TYPE	| mysql	||
|DB_PORT	| 3306	 ||
|DB_PASSWORD	| my_wiki	|Δεδομένα από το βήμα 2|
|DB_USER	| wikiuser |Δεδομένα από το βήμα 2|
|DB_PASS	| my_wiki_pass	|Δεδομένα από το βήμα 2|
{{</table>}}
Τέλος, εισάγω αυτές τις μεταβλητές περιβάλλοντος:Βλέπε:
{{< gallery match="images/11/*.png" >}}
Το εμπορευματοκιβώτιο μπορεί τώρα να ξεκινήσει. Καλώ τον διακομιστή Wiki.js με τη διεύθυνση IP του Synology και τη θύρα του εμπορευματοκιβωτίου μου/3000.
{{< gallery match="images/12/*.png" >}}