+++
date = "2021-09-05"
title = "Μεγάλα πράγματα με δοχεία: διακομιστές πολυμέσων της Logitech στο σταθμό δίσκων της Synology"
difficulty = "level-1"
tags = ["logitech", "synology", "diskstation", "nas", "sound-system", "multiroom"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/september/20210905-logitech-mediaserver/index.el.md"
+++
Σε αυτό το σεμινάριο, θα μάθετε πώς να εγκαθιστάτε έναν διακομιστή πολυμέσων Logitech στον Synology DiskStation.
{{< gallery match="images/1/*.jpg" >}}

## Βήμα 1: Προετοιμάστε το φάκελο Logitech Media Server
Δημιουργώ έναν νέο κατάλογο με όνομα "logitechmediaserver" στον κατάλογο Docker.
{{< gallery match="images/2/*.png" >}}

## Βήμα 2: Εγκατάσταση της εικόνας Logitech Mediaserver
Κάνω κλικ στην καρτέλα "Registration" στο παράθυρο Synology Docker και αναζητώ το "logitechmediaserver". Επιλέγω την εικόνα Docker "lmscommunity/logitechmediaserver" και στη συνέχεια κάνω κλικ στην ετικέτα "latest".
{{< gallery match="images/3/*.png" >}}
Κάνω διπλό κλικ στην εικόνα του Logitech Media Server. Στη συνέχεια, κάνω κλικ στην επιλογή "Ρυθμίσεις για προχωρημένους" και ενεργοποιώ και εδώ την "Αυτόματη επανεκκίνηση".
{{< gallery match="images/4/*.png" >}}
{{<table "table table-striped table-bordered">}}
|Ordner |Mountpath|
|--- |---|
|/volume1/docker/logitechmediaserver/config |/config|
|/volume1/docker/logitechmediaserver/music |/music|
|/volume1/docker/logitechmediaserver/playlist |/playlist|
{{</table>}}
Επιλέγω την καρτέλα "Τόμος" και κάνω κλικ στην επιλογή "Προσθήκη φακέλου". Εκεί δημιουργώ τρεις φακέλους:Βλέπε:
{{< gallery match="images/5/*.png" >}}
Ορίζω σταθερές θύρες για το δοχείο "Logitechmediaserver". Χωρίς σταθερές θύρες, θα μπορούσε ο "διακομιστής Logitechmediaserver" να εκτελείται σε διαφορετική θύρα μετά από επανεκκίνηση.
{{< gallery match="images/6/*.png" >}}
Τέλος, καταχωρίζω μια μεταβλητή περιβάλλοντος. Η μεταβλητή "TZ" είναι η ζώνη ώρας "Ευρώπη/Βερολίνο".
{{< gallery match="images/7/*.png" >}}
Μετά από αυτές τις ρυθμίσεις, ο Logitechmediaserver-Server μπορεί να ξεκινήσει! Στη συνέχεια, μπορείτε να καλέσετε τον Logitechmediaserver μέσω της διεύθυνσης Ip της συσκευής Synology και της θύρας που έχει εκχωρηθεί, για παράδειγμα http://192.168.21.23:9000 .
{{< gallery match="images/8/*.png" >}}

