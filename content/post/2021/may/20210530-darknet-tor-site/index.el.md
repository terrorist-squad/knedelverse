+++
date = "2021-05-30"
title = "Δημιουργήστε τη δική σας σελίδα στο Darknet"
difficulty = "level-3"
tags = ["darknet", "tor", "website", "hosting", "hidden"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/may/20210530-darknet-tor-site/index.el.md"
+++
Η περιήγηση στο Darknet ως επισκέπτης είναι αρκετά απλή. Αλλά πώς μπορώ να φιλοξενήσω μια σελίδα Onion; Θα σας δείξω πώς να δημιουργήσετε τη δική σας σελίδα στο Darknet.
## Βήμα 1: Πώς μπορώ να σερφάρω στο Darknet;
Χρησιμοποιώ μια επιφάνεια εργασίας Ubuntu για καλύτερη απεικόνιση. Εκεί εγκαθιστώ τα ακόλουθα πακέτα:
{{< terminal >}}
sudo apt-get update
sudo apt-get install tor 

{{</ terminal >}}
Στη συνέχεια επεξεργάζομαι το αρχείο "/etc/privoxy/config" και πληκτρολογώ τα εξής ($ sudo vim /etc/privoxy/config). Μπορείτε να μάθετε την IP του υπολογιστή με την εντολή "ifconfig".
```
listen-address hier-muss-die-ip-des-rechners-rein:8118
forward-socks5 / 127.0.0.1:9050 .

```
Βλέπε:
{{< gallery match="images/1/*.png" >}}
Για να διασφαλίσουμε ότι το Tor και το Privoxy εκτελούνται επίσης κατά την εκκίνηση του συστήματος, πρέπει να τα εισάγουμε στην αυτόματη εκκίνηση:
{{< terminal >}}
sudo update-rc.d tor defaults
sudo update-rc.d privoxy defaults

{{</ terminal >}}
Τώρα οι υπηρεσίες μπορούν να ξεκινήσουν:
{{< terminal >}}
sudo service tor restart
sudo service privoxy restart

{{</ terminal >}}
Εισάγω τη διεύθυνση proxy στο Firefox, απενεργοποιώ τη "Javascript" και επισκέπτομαι τη "δοκιμαστική σελίδα Tor". Αν όλα έχουν λειτουργήσει, μπορώ τώρα να επισκέπτομαι ιστότοπους TOR/.Onion.
{{< gallery match="images/2/*.png" >}}

## Βήμα 2: Πώς μπορώ να φιλοξενήσω τον ιστότοπο Darknet;
Πρώτα, εγκαθιστώ έναν διακομιστή HTTP:
{{< terminal >}}
sudo apt-get install nginx

{{</ terminal >}}
Στη συνέχεια, αλλάζω τις ρυθμίσεις του NGINX (vim /etc/nginx/nginx.conf) και απενεργοποιώ αυτές τις λειτουργίες:
```
server_tokens off;
port_in_redirect off;
server_name_in_redirect off;

```
Βλέπε:
{{< gallery match="images/3/*.png" >}}
Ο διακομιστής NGINX πρέπει τώρα να επανεκκινηθεί ξανά:
{{< terminal >}}
sudo service nginx restart

{{</ terminal >}}
Πρέπει επίσης να γίνει μια αλλαγή στη διαμόρφωση του Tor. Σχολιάζω τις ακόλουθες γραμμές "HiddenServiceDir" και "HiddenServicePort" στο αρχείο "/etc/tor/torrc".
{{< gallery match="images/4/*.png" >}}
Μετά από αυτό, κάνω επίσης επανεκκίνηση αυτής της υπηρεσίας:
{{< terminal >}}
sudo service tor restart

{{</ terminal >}}

## Έτοιμο
Κάτω από το "/var/lib/tor/hidden_servic/hostname" βρίσκω τη διεύθυνσή μου στο Darknet/Onion. Τώρα όλα τα περιεχόμενα στο /var/www/html είναι διαθέσιμα στο Darkent.
{{< gallery match="images/5/*.png" >}}
