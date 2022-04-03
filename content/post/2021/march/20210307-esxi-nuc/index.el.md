+++
date = "2021-03-07"
title = "Εγκαταστήστε το ESXi σε μια NUC. Προετοιμάστε το στικάκι USB μέσω του MacBook."
difficulty = "level-4"
tags = ["esxi", "homelab", "hypervisor", "linux", "nuc", "vmware"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/march/20210307-esxi-nuc/index.el.md"
+++
Με το ESXi, ο "intel NUC" μπορεί να χωριστεί σε οποιονδήποτε αριθμό υπολογιστών. Σε αυτό το σεμινάριο, δείχνω πώς εγκατέστησα το VMware ESXi στο NUC μου.Μικρός πρόλογος: συνιστώ μια ενημέρωση του BIOS πριν από την εγκατάσταση του ESXi. Θα χρειαστείτε επίσης ένα στικάκι USB 32GB. Αγόρασα μια ολόκληρη δέσμη για λιγότερο από 5 ευρώ το καθένα από το Amazon.
{{< gallery match="images/1/*.jpg" >}}
Το NUC-8I7BEH έχει 2x 16GB HyperX Impact Ram, 1x 256GB Samsung 970 EVO M2 module και έναν σκληρό δίσκο WD-RED 1TB 2,5 ιντσών.
{{< gallery match="images/2/*.jpg" >}}

## Βήμα 1: Βρείτε το USB - Stick
Η ακόλουθη εντολή μου δείχνει όλες τις μονάδες δίσκου:
{{< terminal >}}
diskutil list

{{</ terminal >}}
Εδώ μπορείτε να δείτε ότι το στικάκι USB έχει το αναγνωριστικό "disk2":
{{< gallery match="images/3/*.png" >}}

## Βήμα 2: Προετοιμάστε το σύστημα αρχείων
Τώρα μπορώ να χρησιμοποιήσω την ακόλουθη εντολή για να προετοιμάσω το σύστημα αρχείων:
{{< terminal >}}
$ diskutil eraseDisk MS-DOS "ESXI" MBR disk2

{{</ terminal >}}
Μετά από αυτό, βλέπω επίσης το αναγνωριστικό στο Finder:
{{< gallery match="images/4/*.png" >}}

## Βήμα 3: Εξαγωγή στικ USB
Χρησιμοποιώ την εντολή "unmountDisk" για να βγάλω τον τόμο:
{{< terminal >}}
$ diskutil unmountDisk /dev/disk2

{{</ terminal >}}
Βλέπε:
{{< gallery match="images/5/*.png" >}}

## Βήμα 4: Κάντε το στικάκι εκκινήσιμο
Τώρα πληκτρολογούμε την εντολή "sudo fdisk -e /dev/disk2" και στη συνέχεια πληκτρολογούμε "f 1", "write" και "quit", βλ:
{{< gallery match="images/6/*.png" >}}

## Βήμα 5: Αντιγραφή δεδομένων
Τώρα πρέπει να κατεβάσω το ESXi-ISO: https://www.vmware.com/de/try-vmware.html. Μετά από αυτό μπορώ να προσαρτήσω το ESXi-ISO και να αντιγράψω τα περιεχόμενα στο στικάκι USB.
{{< gallery match="images/7/*.png" >}}
Όταν όλα έχουν αντιγραφεί, αναζητώ το αρχείο "ISOLINUX.CFG" και το μετονομάζω σε "SYSLINUX.CFG". Προσθέτω επίσης το "-p 1" στη γραμμή "APPEND -c boot.cfg".
{{< gallery match="images/8/*.png" >}}
ertig! Τώρα το ραβδί είναι χρησιμοποιήσιμο. Καλή διασκέδαση!
{{< gallery match="images/9/*.png" >}}
