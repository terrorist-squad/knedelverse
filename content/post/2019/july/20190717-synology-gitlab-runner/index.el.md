+++
date = "2019-07-17"
title = "Synology-Nas: Gitlab - Δρομέας σε δοχείο Docker"
difficulty = "level-4"
tags = ["Docker", "git", "gitlab", "gitlab-runner", "raspberry-pi"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2019/july/20190717-synology-gitlab-runner/index.el.md"
+++
Πώς μπορώ να εγκαταστήσω ένα Gitlab runner ως δοχείο Docker στο Synology NAS μου;
## Βήμα 1: Αναζήτηση εικόνας Docker
Κάνω κλικ στην καρτέλα "Registration" στο παράθυρο Synology Docker και αναζητώ το Gitlab. Επιλέγω την εικόνα Docker "gitlab/gitlab-runner" και στη συνέχεια επιλέγω την ετικέτα "bleeding".
{{< gallery match="images/1/*.png" >}}

## Βήμα 2: Θέστε την εικόνα σε λειτουργία:

##  Πρόβλημα οικοδεσποτών
Το synology-gitlab-insterlation μου αναγνωρίζεται πάντα μόνο με το όνομα κεντρικού υπολογιστή. Δεδομένου ότι πήρα το αρχικό πακέτο Synology Gitlab από το κέντρο πακέτων, αυτή η συμπεριφορά δεν μπορεί να αλλάξει εκ των υστέρων.  Ως λύση, μπορώ να συμπεριλάβω το δικό μου αρχείο hosts. Εδώ μπορείτε να δείτε ότι το όνομα κεντρικού υπολογιστή "peter" ανήκει στη διεύθυνση IP Nas 192.168.12.42.
```
127.0.0.1       localhost                                                       
::1     localhost ip6-localhost ip6-loopback                                    
fe00::0 ip6-localnet                                                            
ff00::0 ip6-mcastprefix                                                         
ff02::1 ip6-allnodes                                                            
ff02::2 ip6-allrouters               
192.168.12.42 peter

```
Αυτό το αρχείο αποθηκεύεται απλώς στο NAS Synology.
{{< gallery match="images/2/*.png" >}}

## Βήμα 3: Ρύθμιση του GitLab Runner
Κάνω κλικ στην εικόνα του δρομέα μου:
{{< gallery match="images/3/*.png" >}}
Ενεργοποιώ τη ρύθμιση "Ενεργοποίηση αυτόματης επανεκκίνησης":
{{< gallery match="images/4/*.png" >}}
Στη συνέχεια, κάνω κλικ στην επιλογή "Ρυθμίσεις για προχωρημένους" και επιλέγω την καρτέλα "Τόμος":
{{< gallery match="images/5/*.png" >}}
Κάνω κλικ στο Add file και συμπεριλαμβάνω το αρχείο hosts μέσω της διαδρομής "/etc/hosts". Αυτό το βήμα είναι απαραίτητο μόνο εάν τα ονόματα κεντρικών υπολογιστών δεν μπορούν να επιλυθούν.
{{< gallery match="images/6/*.png" >}}
Αποδέχομαι τις ρυθμίσεις και κάνω κλικ στο next.
{{< gallery match="images/7/*.png" >}}
Τώρα βρίσκω την αρχικοποιημένη εικόνα στο Container:
{{< gallery match="images/8/*.png" >}}
Επιλέγω το δοχείο (gitlab-gitlab-runner2 για μένα) και κάνω κλικ στο "Details". Στη συνέχεια, κάνω κλικ στην καρτέλα "Terminal" και δημιουργώ μια νέα συνεδρία bash. Εδώ πληκτρολογώ την εντολή "gitlab-runner register". Για την εγγραφή, χρειάζομαι πληροφορίες που μπορώ να βρω στην εγκατάσταση του GitLab στη διεύθυνση http://gitlab-adresse:port/admin/runners.   
{{< gallery match="images/9/*.png" >}}
Αν χρειάζεστε περισσότερα πακέτα, μπορείτε να τα εγκαταστήσετε μέσω του "apt-get update" και στη συνέχεια του "apt-get install python ...".
{{< gallery match="images/10/*.png" >}}
Μετά από αυτό μπορώ να συμπεριλάβω τον δρομέα στα έργα μου και να τον χρησιμοποιήσω:
{{< gallery match="images/11/*.png" >}}