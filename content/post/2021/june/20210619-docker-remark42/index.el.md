+++
date = "2021-06-19"
title = "Μεγάλα πράγματα με δοχεία: Το Remark42 είναι η λύση για τα σχόλιά μου"
difficulty = "level-1"
tags = ["microservice", "docker", "vertical", "kommentare"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/june/20210619-docker-remark42/index.el.md"
+++
Αν το ιστολόγιό σας είναι στατικός ιστότοπος, ίσως να θέλετε μια μικροεξυπηρέτηση/vertical που να παρέχει μια δυναμική λειτουργία σχολίων. Αυτό το ιστολόγιο, για παράδειγμα, έχει υλοποιηθεί στο HUGO, μια "γεννήτρια ιστοσελίδων" γραμμένη σε GO για περιεχόμενο Markdown.Στην περίπτωσή μου, προσάρμοσα αυτό το αρχείο Docker Compose για μένα και το ξεκίνησα με το "docker-compose -f compose.yml up -d". Έχω αποθηκεύσει κλειδιά API για έλεγχο ταυτότητας με το Google και το Facebook. Εισήγαγα επίσης τις ρυθμίσεις του διακομιστή αλληλογραφίας για αλληλεπίδραση με τους αναγνώστες.
```
version: '2'

services:
    remark:

        image: umputun/remark42:latest
        container_name: "remark42"
        restart: always

        logging:
          driver: json-file
          options:
              max-size: "10m"
              max-file: "5"

        ports:
          - "8050:8080"   

        environment:
            - REMARK_URL=https://www.christian-knedel.de/comments/ 
            - "SECRET=secret"          
            - SITE=www.adresse.de 
            - STORE_BOLT_PATH=/srv/var/db
            - BACKUP_PATH=/srv/var/backup

        volumes:
            - ./data:/srv/var

```
Μετά τη διαμόρφωση, η υπηρεσία είναι έτοιμη για χρήση και μπορεί να ενσωματωθεί στον ιστότοπο:
```
<script>
  var remark_config = {
    host: "https://www.christian-knedel.de/comments", 
    site_id: 'www.christian-knedel.de',
    components: ['embed'], 
    max_shown_comments: 10,
    theme: 'dark',
    locale: 'de',
    show_email_subscription: false
  };
</script>
<script>
  (function(c) {
    for(var i = 0; i < c.length; i++){
      var d = document, s = d.createElement('script');
      s.src = remark_config.host + '/web/' +c[i] +'.js';
      s.defer = true;
      (d.head || d.body).appendChild(s);
    }
  })(remark_config.components || ['embed']);
</script>

<br>
<hr>
<br>
<div id="remark42"></div>

```
Και κάπως έτσι μοιάζει το Remark42:
{{< gallery match="images/1/*.png" >}}
