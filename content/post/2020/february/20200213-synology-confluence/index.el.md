+++
date = "2020-02-13"
title = "Synology-Nas: Το Confluence ως σύστημα wiki"
difficulty = "level-4"
tags = ["atlassian", "confluence", "Docker", "ds918", "Synology", "wiki", "nas"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2020/february/20200213-synology-confluence/index.el.md"
+++
Αν θέλετε να εγκαταστήσετε το Atlassian Confluence σε ένα NAS της Synology, τότε βρίσκεστε στο σωστό μέρος.
## Βήμα 1
Αρχικά, ανοίγω την εφαρμογή Docker στο περιβάλλον εργασίας της Synology και στη συνέχεια πηγαίνω στο υπο-σημείο "Registration". Εκεί αναζητώ το "Confluence" και κάνω κλικ στην πρώτη εικόνα "Atlassian Confluence".
{{< gallery match="images/1/*.png" >}}

## Βήμα 2
Μετά τη λήψη της εικόνας, η εικόνα είναι διαθέσιμη ως εικόνα. Το Docker διακρίνει μεταξύ 2 καταστάσεων, του εμπορευματοκιβωτίου "δυναμική κατάσταση" και της εικόνας/εικόνας (σταθερή κατάσταση). Πριν μπορέσουμε να δημιουργήσουμε ένα δοχείο από την εικόνα, πρέπει να γίνουν μερικές ρυθμίσεις.
## Αυτόματη επανεκκίνηση
Κάνω διπλό κλικ στην εικόνα του Confluence.
{{< gallery match="images/2/*.png" >}}
Στη συνέχεια, κάνω κλικ στις "Ρυθμίσεις για προχωρημένους" και ενεργοποιώ την "Αυτόματη επανεκκίνηση".
{{< gallery match="images/3/*.png" >}}

## Λιμένες
Ορίζω σταθερές θύρες για το κοντέινερ Confluence. Χωρίς σταθερές θύρες, το Confluence ενδέχεται να εκτελείται σε διαφορετική θύρα μετά από επανεκκίνηση.
{{< gallery match="images/4/*.png" >}}

## Μνήμη
Δημιουργώ έναν φυσικό φάκελο και τον προσαρτώ στο δοχείο (/var/atlassian/application-data/confluence/). Αυτή η ρύθμιση διευκολύνει τη δημιουργία αντιγράφων ασφαλείας και την επαναφορά δεδομένων.
{{< gallery match="images/5/*.png" >}}
Μετά από αυτές τις ρυθμίσεις, το Confluence μπορεί να ξεκινήσει!
{{< gallery match="images/6/*.png" >}}