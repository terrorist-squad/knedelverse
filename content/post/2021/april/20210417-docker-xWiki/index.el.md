+++
date = "2021-04-17"
title = "Μεγάλα πράγματα με δοχεία: Εκτελώντας το δικό σας xWiki στο σταθμό δίσκων της Synology"
difficulty = "level-1"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "xwiki", "wiki",]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210417-docker-xWiki/index.el.md"
+++
Το XWiki είναι μια ελεύθερη πλατφόρμα λογισμικού wiki γραμμένη σε Java και σχεδιασμένη με γνώμονα την επεκτασιμότητα. Σήμερα θα σας δείξω πώς να εγκαταστήσετε μια υπηρεσία xWiki στον Synology DiskStation.
## Επιλογή για επαγγελματίες
Ως έμπειρος χρήστης της Synology, μπορείτε φυσικά να συνδεθείτε με SSH και να εγκαταστήσετε ολόκληρη τη ρύθμιση μέσω του αρχείου Docker Compose.
```
version: '3'
services:
  xwiki:
    image: xwiki:10-postgres-tomcat
    restart: always
    ports:
      - 8080:8080
    links:
      - db
    environment:
      DB_HOST: db
      DB_DATABASE: xwiki
      DB_DATABASE: xwiki
      DB_PASSWORD: xwiki
      TZ: 'Europe/Berlin'

  db:
    image: postgres:latest
    restart: always
    volumes:
      - ./postgresql:/var/lib/postgresql/data
    environment:
      - POSTGRES_USER=xwiki
      - POSTGRES_PASSWORD=xwiki
      - POSTGRES_DB=xwiki
      - TZ='Europe/Berlin'

```
Περισσότερες χρήσιμες εικόνες Docker για οικιακή χρήση μπορείτε να βρείτε στο [Dockerverse]({{< ref "dockerverse" >}} "Dockerverse").
## Βήμα 1: Προετοιμάστε το φάκελο wiki
Δημιουργώ έναν νέο κατάλογο με όνομα "wiki" στον κατάλογο Docker.
{{< gallery match="images/1/*.png" >}}

## Βήμα 2: Εγκατάσταση της βάσης δεδομένων
Στη συνέχεια, πρέπει να δημιουργηθεί μια βάση δεδομένων. Κάνω κλικ στην καρτέλα "Registration" στο παράθυρο Synology Docker και αναζητώ το "postgres". Επιλέγω την εικόνα Docker "postgres" και στη συνέχεια κάνω κλικ στην ετικέτα "latest".
{{< gallery match="images/2/*.png" >}}
Μετά τη λήψη της εικόνας, η εικόνα είναι διαθέσιμη ως εικόνα. Το Docker διακρίνει μεταξύ 2 καταστάσεων, του εμπορευματοκιβωτίου "δυναμική κατάσταση" και της εικόνας (σταθερή κατάσταση). Πριν δημιουργήσουμε ένα container από την εικόνα, πρέπει να γίνουν μερικές ρυθμίσεις. Κάνω διπλό κλικ στην εικόνα postgres.
{{< gallery match="images/3/*.png" >}}
Στη συνέχεια κάνω κλικ στο "Ρυθμίσεις για προχωρημένους" και ενεργοποιώ την "Αυτόματη επανεκκίνηση". Επιλέγω την καρτέλα "Τόμος" και κάνω κλικ στο "Προσθήκη φακέλου". Εκεί δημιουργώ έναν νέο φάκελο βάσης δεδομένων με τη διαδρομή προσάρτησης "/var/lib/postgresql/data".
{{< gallery match="images/4/*.png" >}}
Στην ενότητα "Ρυθμίσεις θύρας" διαγράφονται όλες οι θύρες. Αυτό σημαίνει ότι επιλέγω τη θύρα "5432" και τη διαγράφω με το κουμπί "-".
{{< gallery match="images/5/*.png" >}}
{{<table "table table-striped table-bordered">}}
|Όνομα μεταβλητής|Αξία|Τι είναι αυτό;|
|--- | --- |---|
|TZ	| Europe/Berlin	|Ζώνη ώρας|
|POSTGRES_DB	| xwiki |Αυτό είναι το όνομα της βάσης δεδομένων.|
|POSTGRES_USER	| xwiki |Όνομα χρήστη της βάσης δεδομένων του wiki.|
|POSTGRES_PASSWORD	| xwiki |Κωδικός πρόσβασης του χρήστη της βάσης δεδομένων wiki.|
{{</table>}}
Τέλος, εισάγω αυτές τις τέσσερις μεταβλητές περιβάλλοντος:Βλέπε:
{{< gallery match="images/6/*.png" >}}
Μετά από αυτές τις ρυθμίσεις, ο διακομιστής Mariadb μπορεί να ξεκινήσει! Πατάω παντού το "Apply".
## Βήμα 3: Εγκαταστήστε το xWiki
Κάνω κλικ στην καρτέλα "Registration" στο παράθυρο Synology Docker και αναζητώ το "xwiki". Επιλέγω την εικόνα Docker "xwiki" και στη συνέχεια κάνω κλικ στην ετικέτα "10-postgres-tomcat".
{{< gallery match="images/7/*.png" >}}
Κάνω διπλό κλικ στην εικόνα μου στο xwiki. Στη συνέχεια, κάνω κλικ στην επιλογή "Ρυθμίσεις για προχωρημένους" και ενεργοποιώ και εδώ την "Αυτόματη επανεκκίνηση".
{{< gallery match="images/8/*.png" >}}
Ορίζω σταθερές θύρες για το δοχείο "xwiki". Χωρίς σταθερές θύρες, θα μπορούσε ο "διακομιστής xwiki" να τρέχει σε διαφορετική θύρα μετά από επανεκκίνηση.
{{< gallery match="images/9/*.png" >}}
Επιπλέον, πρέπει να δημιουργηθεί ένας "σύνδεσμος" προς το δοχείο "postgres". Κάνω κλικ στην καρτέλα "Σύνδεσμοι" και επιλέγω το δοχείο βάσης δεδομένων. Το ψευδώνυμο θα πρέπει να διατηρηθεί για την εγκατάσταση του wiki.
{{< gallery match="images/10/*.png" >}}
{{<table "table table-striped table-bordered">}}
|Όνομα μεταβλητής|Αξία|Τι είναι αυτό;|
|--- | --- |---|
|TZ |	Europe/Berlin	|Ζώνη ώρας|
|DB_HOST	| db |Ονόματα ψευδώνυμων / σύνδεσμος δοχείου|
|DB_DATABASE	| xwiki	|Δεδομένα από το βήμα 2|
|DB_USER	| xwiki	|Δεδομένα από το βήμα 2|
|DB_PASSWORD	| xwiki |Δεδομένα από το βήμα 2|
{{</table>}}
Τέλος, εισάγω αυτές τις μεταβλητές περιβάλλοντος:Βλέπε:
{{< gallery match="images/11/*.png" >}}
Το εμπορευματοκιβώτιο μπορεί τώρα να ξεκινήσει. Καλώ τον διακομιστή xWiki με τη διεύθυνση IP του Synology και τη θύρα του εμπορευματοκιβωτίου μου.
{{< gallery match="images/12/*.png" >}}
