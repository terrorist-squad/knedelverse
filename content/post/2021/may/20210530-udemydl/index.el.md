+++
date = "2021-05-30"
title = "Udemy Downloader στον Synology DiskStation"
difficulty = "level-2"
tags = ["udemy", "download", "synology", "diskstation", "udemydl"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/may/20210530-udemydl/index.el.md"
+++
Σε αυτό το σεμινάριο θα μάθετε πώς να κατεβάζετε μαθήματα "udemy" για χρήση εκτός σύνδεσης.
## Βήμα 1: Προετοιμάστε το φάκελο Udemy
Δημιουργώ έναν νέο κατάλογο με όνομα "udemy" στον κατάλογο Docker.
{{< gallery match="images/1/*.png" >}}

## Βήμα 2: Εγκατάσταση της εικόνας Ubuntu
Κάνω κλικ στην καρτέλα "Registration" στο παράθυρο Synology Docker και αναζητώ το "ubunutu". Επιλέγω την εικόνα Docker "ubunutu" και στη συνέχεια κάνω κλικ στην ετικέτα "latest".
{{< gallery match="images/2/*.png" >}}
Κάνω διπλό κλικ στην εικόνα του Ubuntu. Στη συνέχεια, κάνω κλικ στην επιλογή "Ρυθμίσεις για προχωρημένους" και ενεργοποιώ και εδώ την "Αυτόματη επανεκκίνηση".
{{< gallery match="images/3/*.png" >}}
Επιλέγω την καρτέλα "Τόμος" και κάνω κλικ στην επιλογή "Προσθήκη φακέλου". Εκεί δημιουργώ έναν νέο φάκελο με τη διαδρομή προσάρτησης "/download".
{{< gallery match="images/4/*.png" >}}
Τώρα το δοχείο μπορεί να ξεκινήσει
{{< gallery match="images/5/*.png" >}}

## Βήμα 4: Εγκαταστήστε το Udemy Downloader
Κάνω κλικ στο "Container" στο παράθυρο Synology Docker και κάνω διπλό κλικ στο "Udemy container". Στη συνέχεια, κάνω κλικ στην καρτέλα "Terminal" και πληκτρολογώ τις ακόλουθες εντολές.
{{< gallery match="images/6/*.png" >}}

##  Εντολές:

{{< terminal >}}
apt-get update
apt-get install python3 python3-pip wget unzip
cd /download
wget https://github.com/r0oth3x49/udemy-dl/archive/refs/heads/master.zip
unzip master.zip
cd udemy-dl-master
pip3 pip install -r requirements.txt

{{</ terminal >}}
Στιγμιότυπα:
{{< gallery match="images/7/*.png" >}}

## Βήμα 4: Θέτοντας σε λειτουργία τον downloader του Udemy
Τώρα χρειάζομαι ένα "διακριτικό πρόσβασης". Επισκέπτομαι το Udemy με το πρόγραμμα περιήγησης Firefox και ανοίγω το Firebug. Κάνω κλικ στην καρτέλα "Web storage" και αντιγράφω το "Access token".
{{< gallery match="images/8/*.png" >}}
Δημιουργώ ένα νέο αρχείο στο δοχείο μου:
{{< terminal >}}
echo "access_token=859wjuhV7PMLsZu15GOWias9A0iFnRjkL9pJXOv2" > /download/cookie.txt

{{</ terminal >}}
Μετά από αυτό μπορώ να κατεβάσω τα μαθήματα που έχω ήδη αγοράσει:
{{< terminal >}}
cd /download
python3 udemy-dl-master/udemy-dl.py -k /download/cookie.txt https://www.udemy.com/course/ansible-grundlagen/learn/

{{</ terminal >}}
Βλέπε:
{{< gallery match="images/9/*.png" >}}

