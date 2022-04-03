+++
date = "2021-04-02"
title = "Υπέροχα πράγματα με containers: κάνοντας τις υπηρεσίες Docker πιο ασφαλείς με LDAP και NGINX"
difficulty = "level-1"
tags = ["calibre", "calibre-web", "ldap", "logging", "nutzerverwaltung", "peertube", "ssl"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210402-nginx-reverse-proxy/index.el.md"
+++
Ως χρήστης του Synology Diskstation, τρέχω πολλές υπηρεσίες στο δίκτυο Homelab. Αναπτύσσω λογισμικό στο Gitlab, τεκμηριώνω τη γνώση στο Confluence και διαβάζω τεχνικές αναφορές μέσω του διακομιστή ιστού Calibre.
{{< gallery match="images/1/*.png" >}}
Όλες οι δικτυακές υπηρεσίες επικοινωνούν κρυπτογραφημένα και ασφαλίζονται μέσω μιας κεντρικής διαχείρισης χρηστών. Σήμερα παρουσιάζω πώς εξασφάλισα την υπηρεσία Calibre με κρυπτογράφηση SSL, καταγραφή πρόσβασης και περιορισμό πρόσβασης LDAP. Για αυτό το σεμινάριο απαιτείται προηγούμενη γνώση των "[Ωραία πράγματα με την Atlassian: Χρησιμοποιήστε όλα τα εργαλεία της Atlassian με LDAP]({{< ref "post/2021/march/20210321-atlassian-ldap" >}} "Ωραία πράγματα με την Atlassian: Χρησιμοποιήστε όλα τα εργαλεία της Atlassian με LDAP")" και "[Μεγάλα πράγματα με κοντέινερ: Εκτέλεση του Calibre με το Docker Compose]({{< ref "post/2020/february/20200221-docker-Calibre-pro" >}} "Μεγάλα πράγματα με κοντέινερ: Εκτέλεση του Calibre με το Docker Compose")".
## Ο διακομιστής LDAP μου
Όπως έχω ήδη γράψει, τρέχω έναν κεντρικό διακομιστή openLDAP στο δοχείο Docker. Έχω επίσης δημιουργήσει μερικές ομάδες εφαρμογών.
{{< gallery match="images/2/*.png" >}}

## Ασφαλής ανασφαλής εφαρμογή με αντίστροφο διακομιστή μεσολάβησης
Δεδομένου ότι η εικόνα Docker "linuxserver/calibre-web" δεν υποστηρίζει κρυπτογράφηση SSL και LDAP, δημιουργώ ένα εικονικό δίκτυο που ονομάζεται "calibreweb" και βάζω έναν αντίστροφο διακομιστή μεσολάβησης NGINX μπροστά από τον διακομιστή Calibre. Έτσι μοιάζει το αρχείο Docker Compose. Όλα τα μελλοντικά αρχεία καταγραφής πρόσβασης αποθηκεύονται στον κατάλογο log και τα αυτο-υπογεγραμμένα πιστοποιητικά μου βρίσκονται στον κατάλογο certs.
```
version: '3.7'
services:
  nginx: 
    image:  weseek/nginx-auth-ldap:1.13.9-1-alpine
    container_name: calibre-nginx
    environment:
    - 'TZ=Europe/Berlin'
    volumes:
      - ./default.conf:/etc/nginx/conf.d/default.conf
      - ./certs:/etc/certs
      - ./logs:/var/log/nginx
    ports:
      - 8443:443
    networks:
      - calibreweb
    restart: unless-stopped

  calibre-web:
    image: linuxserver/calibre-web
    container_name: calibre-web
    environment:
      - PUID=.....
      - PGID=....
      - TZ=Europe/Berlin
    volumes:
      - /volume/docker/calibre/app.db:/app/calibre-web/app.db
      - /volume/Buecher:/books
    expose:
      - 8083
    restart: unless-stopped
    networks:
      - calibreweb

networks:
  calibreweb:

```
Περισσότερες χρήσιμες εικόνες Docker για οικιακή χρήση μπορείτε να βρείτε στο [Dockerverse]({{< ref "dockerverse" >}} "Dockerverse").
## Ρύθμιση του Nginx
Το αρχείο "default.conf" περιέχει όλες τις ρυθμίσεις LDAP και κρυπτογράφησης. Φυσικά, η διεύθυνση URL, το binddn, τα πιστοποιητικά, οι θύρες, ο κωδικός πρόσβασης και η ομάδα πρέπει να προσαρμοστούν.
```
# ldap auth configuration
auth_ldap_cache_enabled on;
auth_ldap_cache_expiration_time 10000;
auth_ldap_cache_size 1000;
ldap_server ldap1 {
    url ldaps://ldap.server.local:636/dc=homelab,dc=local?uid?sub?(&(objectClass=inetorgperson));

    binddn "cn=root oder so,dc=homelab,dc=local";
    binddn_passwd "password";
    connect_timeout 5s;
    bind_timeout 5s;
    request_timeout 5s;
    ssl_check_cert: off;
    group_attribute memberUid;
    group_attribute_is_dn off;
    require group "cn=APP-Bibliothek,ou=Groups,dc=homelab,dc=local";
    require valid_user;
}

server {
    listen              443 ssl;
    server_name  localhost;

    ssl_certificate /etc/certs/fullchain.pem;
    ssl_certificate_key /etc/certs/privkey.pem;
    #weitere SSL-Einstellungen

    location / {
        auth_ldap "LDAP-ONLY";
        auth_ldap_servers ldap1;

        proxy_set_header        Host            $http_host;
        proxy_set_header        X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header        X-Scheme        $scheme;
        proxy_pass  http://calibre-web:8083; #<- docker expose port
    }
}


```
Αν τώρα ξεκινήσετε την εγκατάσταση με την εντολή "docker-compose -f ...etc... up", μπορείτε επίσης να δείτε τις προσβάσεις των συνδεδεμένων χρηστών στο αρχείο καταγραφής πρόσβασης:
{{< gallery match="images/3/*.png" >}}
Δεδομένου ότι οι χρήστες LDAP είναι μόνο φιλοξενούμενοι χρήστες, τα δικαιώματα φιλοξενούμενου χρήστη πρέπει να οριστούν στο Calibreweb:
{{< gallery match="images/4/*.png" >}}
Εκτελώ αυτή τη ρύθμιση για τις ακόλουθες υπηρεσίες:* Βιβλιοθήκη βίντεο (Peertube)* Βιβλιοθήκη (Calibreweb)* Gitlab (Το CE δεν υποστηρίζει ομάδες, οπότε πρέπει να συνδεθείτε 2 φορές)
