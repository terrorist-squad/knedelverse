+++
date = "2020-02-14"
title = "Δημιουργία επισκόπησης σελίδας PDF"
difficulty = "level-3"
tags = ["bash", "linux", "pdf", "postscript", "imagemagick"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2020/february/20200214-imagemagick-pdf-overview/index.el.md"
+++
Αν θέλετε να δημιουργήσετε μια εικόνα επισκόπησης σελίδας από ένα αρχείο PDF, τότε έχετε έρθει στο σωστό μέρος!
{{< gallery match="images/1/*.jpg" >}}

## Βήμα 1: Δημιουργία φακέλου εργασίας
Χρησιμοποιήστε αυτή την εντολή για να δημιουργήσετε έναν προσωρινό φάκελο εργασίας:
{{< terminal >}}
mkdir /tmp/bilder

{{</ terminal >}}

## Βήμα 2: Ξεχωριστή σελίδα
Η ακόλουθη εντολή δημιουργεί μια εικόνα κάθε σελίδας PDF:
{{< terminal >}}
convert 716023b632a9cbe6cad3ab368c202288.pdf /tmp/bilder/page.png

{{</ terminal >}}

## Βήμα 3: Τοποθέτηση των εικόνων
Τώρα το κολάζ πρέπει απλώς να συναρμολογηθεί:
{{< terminal >}}
montage /tmp/bilder/* -shadow -geometry '400x400+2+2>' -background '#f1f1f1' uebersich.jpg

{{</ terminal >}}

