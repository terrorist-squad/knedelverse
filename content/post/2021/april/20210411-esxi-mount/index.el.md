+++
date = "2021-04-11"
title = "Σύντομη ιστορία: Σύνδεση τόμων της Synology στο ESXi."
difficulty = "level-1"
tags = ["dos", "esxi", "khk-kaufmann-v1", "nuc", "pc-kaufmann", "Synology", "vmware"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/april/20210411-esxi-mount/index.el.md"
+++

## Βήμα 1: Ενεργοποίηση της υπηρεσίας "NFS"
Πρώτον, η υπηρεσία "NFS" πρέπει να ενεργοποιηθεί στο Diskstation. Για να το κάνω αυτό, πηγαίνω στη ρύθμιση "Πίνακας ελέγχου" > "Υπηρεσίες αρχείων" και κάνω κλικ στην επιλογή "Ενεργοποίηση NFS".
{{< gallery match="images/1/*.png" >}}
Στη συνέχεια, κάνω κλικ στο "Κοινόχρηστος φάκελος" και επιλέγω έναν κατάλογο.
{{< gallery match="images/2/*.png" >}}

## Βήμα 2: Προσάρτηση καταλόγων στο ESXi
Στο ESXi, κάνω κλικ στο "Storage" > "New datastore" και καταχωρώ τα δεδομένα μου εκεί.
{{< gallery match="images/3/*.png" >}}

## Έτοιμο
Τώρα η μνήμη μπορεί να χρησιμοποιηθεί.
{{< gallery match="images/4/*.png" >}}
Για δοκιμές, εγκατέστησα μια εγκατάσταση DOS και ένα παλιό λογιστικό λογισμικό μέσω αυτού του σημείου προσάρτησης.
{{< gallery match="images/5/*.png" >}}
