+++
date = "2021-04-05"
title = "Μεγάλα πράγματα με δοχεία: Δική σας πύλη βίντεο με το PeerTube"
difficulty = "level-1"
tags = ["diskstation", "peertube", "Synology", "video", "videoportal"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210405-docker-peertube/index.el.md"
+++
Με το Peertube μπορείτε να δημιουργήσετε τη δική σας πύλη βίντεο. Σήμερα δείχνω πώς εγκατέστησα το Peertube στο σταθμό δίσκων Synology.
## Βήμα 1: Προετοιμάστε τη Synology
Πρώτον, η σύνδεση SSH πρέπει να ενεργοποιηθεί στον DiskStation. Για να το κάνετε αυτό, μεταβείτε στον "Πίνακα Ελέγχου" > "Τερματικό
{{< gallery match="images/1/*.png" >}}
Στη συνέχεια, μπορείτε να συνδεθείτε μέσω "SSH", της καθορισμένης θύρας και του κωδικού πρόσβασης διαχειριστή.
{{< gallery match="images/2/*.png" >}}
Συνδέομαι μέσω Terminal, winSCP ή Putty και αφήνω αυτή την κονσόλα ανοιχτή για αργότερα.
## Βήμα 2: Προετοιμάστε το φάκελο Docker
Δημιουργώ έναν νέο κατάλογο με όνομα "Peertube" στον κατάλογο Docker.
{{< gallery match="images/3/*.png" >}}
Στη συνέχεια, πηγαίνω στον κατάλογο Peertube και δημιουργώ ένα νέο αρχείο με όνομα "peertube.yml" με το ακόλουθο περιεχόμενο. Για τη θύρα, το μπροστινό μέρος "9000:" μπορεί να ρυθμιστεί. Ο δεύτερος τόμος περιέχει όλα τα βίντεο, τη λίστα αναπαραγωγής, τις μικρογραφίες κ.λπ... και πρέπει επομένως να προσαρμοστεί.
```
version: "3.7"

services:
  peertube:
    image: chocobozzz/peertube:contain-buster
    container_name: peertube_peertube
    ports:
       - "9000:9000"
    volumes:
      - ./config:/config
      - ./videos:/data
    environment:
      - TZ="Europe/Berlin"
      - PT_INITIAL_ROOT_PASSWORD=password
      - PEERTUBE_WEBSERVER_HOSTNAME=ip
      - PEERTUBE_WEBSERVER_PORT=port
      - PEERTUBE_WEBSERVER_HTTPS=false
      - PEERTUBE_DB_USERNAME=peertube
      - PEERTUBE_DB_PASSWORD=peertube
      - PEERTUBE_DB_HOSTNAME=postgres
      - POSTGRES_DB=peertube
      - POSTGRES_USER=postgres
      - POSTGRES_PASSWORD=postgres
      - PEERTUBE_REDIS_HOSTNAME=redis
      - PEERTUBE_ADMIN_EMAIL=himself@christian-knedel.de
    depends_on:
      - postgres
      - redis
    restart: "always"
    networks:
      - peertube

  postgres:
    restart: always
    image: postgres:12
    container_name: peertube_postgres
    volumes:
      - ./postgresql:/var/lib/postgresql/data
    environment:
      - POSTGRES_USER=peertube
      - POSTGRES_PASSWORD=peertube
      - POSTGRES_DB=peertube
    networks:
      - peertube

  redis:
    image: redis:4-alpine
    container_name: peertube_redis
    volumes:
      - ./redis:/data
    restart: "always"
    networks:
      - peertube
    expose:
      - "6379"

networks:
  peertube:

```
Αυτό το αρχείο εκκινείται μέσω του Docker Compose:
{{< terminal >}}
sudo docker-compose -f compose-file-name.yml up -d

{{</ terminal >}}
Μετά από αυτό, μπορώ να καλέσω τον διακομιστή Peertube με την IP του σταθμού δίσκου και την εκχωρημένη θύρα από το "Βήμα 2". Υπέροχα!
{{< gallery match="images/4/*.png" >}}
Το όνομα χρήστη είναι "root" και ο κωδικός πρόσβασης είναι "password" (ή βήμα 2 / PT_INITIAL_ROOT_PASSWORD).
## Προσαρμογή θέματος
Είναι πολύ εύκολο να προσαρμόσετε την εμφάνιση του Peertube. Για να το κάνω αυτό, επιλέγω "Διαχείριση" > "Ρυθμίσεις" και "Σύνθετες ρυθμίσεις".
{{< gallery match="images/5/*.png" >}}
Εκεί έχω εισάγει τα ακόλουθα στο πεδίο CSS:
```
body#custom-css {
--mainColor: #3598dc;
--mainHoverColor: #3598dc;
--mainBackgroundColor: #FAFAFA;
--mainForegroundColor: #888888;
--menuBackgroundColor: #f5f5f5;
--menuForegroundColor: #888888;
--submenuColor: #fff;
--inputColor: #fff;
--inputPlaceholderColor: #898989;
}

```

## Επαναλαμβανόμενο API
Το PeerTube διαθέτει ένα εκτεταμένο και καλά τεκμηριωμένο API Rest: https://docs.joinpeertube.org/api-rest-reference.html.
{{< gallery match="images/6/*.png" >}}
Η αναζήτηση βίντεο είναι δυνατή με αυτή την εντολή:
{{< terminal >}}
curl -s "http://pree-tube/api/v1search/videos?search=docker&languageOneOf=de"

{{</ terminal >}}
Για παράδειγμα, απαιτείται έλεγχος ταυτότητας και ένα διακριτικό συνεδρίας για μια μεταφόρτωση:
```
#!/bin/bash
USERNAME="user"
PASSWORD="password"
API_PATH="http://peertube-adresse/api/v1"

client_id=$(curl -s "$API_PATH/oauth-clients/local" | jq -r ".client_id")
client_secret=$(curl -s "$API_PATH/oauth-clients/local" | jq -r ".client_secret")
token=$(curl -s "$API_PATH/users/token" \
  --data client_id="$client_id" \
  --data client_secret="$client_secret" \
  --data grant_type=password \
  --data response_type=code \
  --data username="$USERNAME" \
  --data password="$PASSWORD" \
  | jq -r ".access_token")

curl -s '$API_PATH/videos/upload'-H 'Authorization: Bearer $token' --max-time 11600 --form videofile=@'/scripte/output.mp4' --form name='mein upload' 

```

## Η συμβουλή μου: Διαβάστε το "Great things with containers: making Docker services more secure with LDAP and NGINX".
Τρέχω το Peertube μου με έναν αντίστροφο διακομιστή μεσολάβησης. Αυτό σημαίνει ότι μόνο οι χρήστες LDAP μπορούν να έχουν πρόσβαση σε αυτή την υπηρεσία. Έχω τεκμηριώσει αυτή τη ρύθμιση στο "[Υπέροχα πράγματα με containers: κάνοντας τις υπηρεσίες Docker πιο ασφαλείς με LDAP και NGINX]({{< ref "post/2021/april/20210402-nginx-reverse-proxy" >}} "Υπέροχα πράγματα με containers: κάνοντας τις υπηρεσίες Docker πιο ασφαλείς με LDAP και NGINX")".
