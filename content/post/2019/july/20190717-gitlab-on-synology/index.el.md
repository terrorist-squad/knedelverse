+++
date = "2019-07-17"
title = "Synology Nas: Εγκαταστήστε το Gitlab;"
difficulty = "level-1"
tags = ["git", "gitlab", "gitlab-runner", "nas", "Synology"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2019/july/20190717-gitlab-on-synology/index.el.md"
+++
Εδώ παρουσιάζω πώς εγκατέστησα το Gitlab και ένα Gitlab runner στο Synology NAS μου. Πρώτον, η εφαρμογή GitLab πρέπει να εγκατασταθεί ως πακέτο Synology. Αναζητήστε το "Gitlab" στο "Κέντρο Πακέτων" και κάντε κλικ στο "Εγκατάσταση".   
{{< gallery match="images/1/*.*" >}}
Η υπηρεσία ακούει τη θύρα "30000" για μένα. Όταν όλα έχουν δουλέψει, καλώ το Gitlab μου με το http://SynologyHostName:30000 και βλέπω αυτή την εικόνα:
{{< gallery match="images/2/*.*" >}}
Όταν συνδέομαι για πρώτη φορά, μου ζητείται ο μελλοντικός κωδικός πρόσβασης "admin". Αυτό ήταν! Τώρα μπορώ να οργανώσω έργα. Τώρα μπορείτε να εγκαταστήσετε έναν εκτελεστή του Gitlab.  
{{< gallery match="images/3/*.*" >}}

