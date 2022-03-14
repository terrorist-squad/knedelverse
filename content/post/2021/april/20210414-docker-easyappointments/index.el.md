+++
date = "2021-04-16"
title = "Δημιουργική έξοδος από την κρίση: κράτηση υπηρεσίας με easyappointments"
difficulty = "level-3"
tags = ["buchung", "buchungstool", "click-and-meet", "corona", "Docker", "docker-compose", "easyappointments", "krise", "einzelhandel", "geschaefte"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210414-docker-easyappointments/index.el.md"
+++
Η κρίση της Corona πλήττει σκληρά τους παρόχους υπηρεσιών στη Γερμανία. Τα ψηφιακά εργαλεία και λύσεις μπορούν να βοηθήσουν να ξεπεράσετε την πανδημία Corona με τη μεγαλύτερη δυνατή ασφάλεια. Σε αυτή τη σειρά σεμιναρίων "Δημιουργική έξοδος από την κρίση" παρουσιάζω τεχνολογίες ή εργαλεία που μπορούν να είναι χρήσιμα για μικρές επιχειρήσεις.Σήμερα παρουσιάζω το "Easyappointments", ένα εργαλείο κρατήσεων "κλικ και συνάντηση" για υπηρεσίες, για παράδειγμα κομμωτήρια ή καταστήματα. Το Easyappointments αποτελείται από δύο τομείς:
## Περιοχή 1: Backend
Ένα "backend" για τη διαχείριση υπηρεσιών και ραντεβού.
{{< gallery match="images/1/*.png" >}}

## Περιοχή 2: Frontend
Ένα εργαλείο τελικού χρήστη για την κράτηση ραντεβού. Όλα τα ήδη κλεισμένα ραντεβού μπλοκάρονται και δεν μπορούν να κλειστούν δύο φορές.
{{< gallery match="images/2/*.png" >}}

## Εγκατάσταση
Έχω ήδη εγκαταστήσει το Easyappointments αρκετές φορές με το Docker-Compose και μπορώ να συστήσω ανεπιφύλακτα αυτή τη μέθοδο εγκατάστασης. Δημιουργώ έναν νέο κατάλογο με όνομα "easyappointments" στον διακομιστή μου:
{{< terminal >}}
mkdir easyappointments
cd easyappointments

{{</ terminal >}}
Στη συνέχεια, πηγαίνω στον κατάλογο easyappointments και δημιουργώ ένα νέο αρχείο με όνομα "easyappointments.yml" με το ακόλουθο περιεχόμενο:
```
version: '2'
services:
  db:
    image: mysql
    environment:
      - MYSQL_ROOT_PASSWORD=root
      - MYSQL_DATABASE=easyappointments
      - MYSQL_USER=easyappointments
      - MYSQL_PASSWORD=easyappointments
    command: mysqld --default-authentication-plugin=mysql_native_password
    volumes:
      - ./easy-appointments-data:/var/lib/mysql
    expose:
      - 3306
    networks:
      - easyappointments-network
    restart: always

  application:
    image: jamrizzi/easyappointments
    volumes:
      - ./easy-appointments:/app/www
    depends_on:
      - db
    ports:
      - 8089:8888
    environment:
      - DB_HOST=db
      - DB_USERNAME=easyappointments
      - DB_NAME=easyappointments
      - DB_PASSWORD=easyappointments
      - TZ=Europe/Berlin
      - BASE_URL=http://192.168.178.50:8089 
    networks:
      - easyappointments-network
    restart: always

networks:
  easyappointments-network:

```
Αυτό το αρχείο εκκινείται μέσω του Docker Compose. Στη συνέχεια, η εγκατάσταση είναι προσβάσιμη από τον προβλεπόμενο τομέα/θυρίδα.
{{< terminal >}}
docker-compose -f easyappointments.yml up

{{</ terminal >}}

## Δημιουργία υπηρεσίας
Οι υπηρεσίες μπορούν να δημιουργηθούν στην ενότητα "Υπηρεσίες". Κάθε νέα υπηρεσία πρέπει στη συνέχεια να αντιστοιχιστεί σε έναν πάροχο/χρήστη υπηρεσιών. Αυτό σημαίνει ότι μπορώ να κλείσω εξειδικευμένους υπαλλήλους ή παρόχους υπηρεσιών.
{{< gallery match="images/3/*.png" >}}
Ο τελικός καταναλωτής μπορεί επίσης να επιλέξει την υπηρεσία και τον προτιμώμενο πάροχο υπηρεσιών.
{{< gallery match="images/4/*.png" >}}

## Ώρες εργασίας και διαλείμματα
Οι γενικές ώρες λειτουργίας μπορούν να οριστούν στο "Settings" > "Business Logic". Ωστόσο, οι ώρες εργασίας των παρόχων υπηρεσιών/χρηστών μπορούν επίσης να αλλάξουν στο "Σχέδιο εργασίας" του χρήστη.
{{< gallery match="images/5/*.png" >}}

## Επισκόπηση κρατήσεων και ημερολόγιο
Το ημερολόγιο ραντεβού καθιστά ορατές όλες τις κρατήσεις. Φυσικά, οι κρατήσεις μπορούν επίσης να δημιουργηθούν ή να επεξεργαστούν εκεί.
{{< gallery match="images/6/*.png" >}}

## Χρωματικές ή λογικές προσαρμογές
Αν αντιγράψετε τον κατάλογο "/app/www" και τον συμπεριλάβετε ως "τόμο", τότε μπορείτε να προσαρμόσετε τα φύλλα στυλ και τη λογική όπως επιθυμείτε.
{{< gallery match="images/7/*.png" >}}