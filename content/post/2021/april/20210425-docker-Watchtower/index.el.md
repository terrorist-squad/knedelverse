+++
date = "2021-04-25T09:28:11+01:00"
title = "Σύντομη ιστορία: Αυτόματη ενημέρωση δοχείων με το Watchtower"
difficulty = "level-2"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "watchtower"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210425-docker-Watchtower/index.el.md"
+++
Εάν εκτελείτε κοντέινερ Docker στο σταθμό δίσκων σας, φυσικά θέλετε να είναι πάντα ενημερωμένα. Το Watchtower ενημερώνει αυτόματα τις εικόνες και τα εμπορευματοκιβώτια. Με αυτόν τον τρόπο μπορείτε να απολαμβάνετε τις πιο πρόσφατες λειτουργίες και την πιο σύγχρονη ασφάλεια δεδομένων. Σήμερα θα σας δείξω πώς να εγκαταστήσετε ένα Watchtower στο σταθμό δίσκων Synology.
## Βήμα 1: Προετοιμάστε τη Synology
Πρώτον, η σύνδεση SSH πρέπει να ενεργοποιηθεί στον DiskStation. Για να το κάνετε αυτό, μεταβείτε στον "Πίνακα Ελέγχου" > "Τερματικό
{{< gallery match="images/1/*.png" >}}
Στη συνέχεια, μπορείτε να συνδεθείτε μέσω "SSH", της καθορισμένης θύρας και του κωδικού πρόσβασης διαχειριστή (οι χρήστες των Windows χρησιμοποιούν το Putty ή το WinSCP).
{{< gallery match="images/2/*.png" >}}
Συνδέομαι μέσω Terminal, winSCP ή Putty και αφήνω αυτή την κονσόλα ανοιχτή για αργότερα.
## Βήμα 2: Εγκαταστήστε το Watchtower
Χρησιμοποιώ την κονσόλα γι' αυτό:
{{< terminal >}}
docker run --name watchtower --restart always -v /var/run/docker.sock:/var/run/docker.sock containrrr/watchtower

{{</ terminal >}}
Μετά από αυτό, το Παρατηρητήριο τρέχει πάντα στο παρασκήνιο.
{{< gallery match="images/3/*.png" >}}
