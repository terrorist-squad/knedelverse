+++
date = "2020-02-07"
title = "Μεγάλα πράγματα με δοχεία: Αρχείο Διαδικτύου σε Docker"
difficulty = "level-3"
tags = ["bookmarks", "Docker", "Internet-Archiv", "Synology", "shiori"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2020/february/20200207-docker-shiori/index.el.md"
+++
Στο σεμινάριο που ακολουθεί, θα εγκαταστήσετε ένα ιδιωτικό "αρχείο Internet" ως δοχείο Docker. Το μόνο που χρειάζεστε είναι αυτό το αρχείο "Docker-compose":
```
version: '2'
services:
  db:
     image: radhifadlillah/shiori:latest
     container_name: bookmark-archiv-shiori
     volumes:
       - ./shiori-server:/srv/shiori
     ports:
       - "18080:8080"


```
Αφού εκκινήσετε το αρχείο yml με το Docker-Compose μέσω του "docker-compose -f your-file.yml up -d", μπορείτε να έχετε πρόσβαση στο τοπικό αρχείο διαδικτύου μέσω της καθορισμένης θύρας, για παράδειγμα http://localhost:18080 . Η προεπιλεγμένη σύνδεση μπορεί να βρεθεί στον ακόλουθο δικτυακό τόπο: https://github.com/go-shiori/shiori/wiki/Usage
```
username: shiori
password: gopher

```
Υπέροχα! Μπορείτε να χρησιμοποιήσετε το αρχείο σας στο Διαδίκτυο:
{{< gallery match="images/1/*.png" >}}
