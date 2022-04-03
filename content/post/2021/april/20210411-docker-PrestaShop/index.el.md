+++
date = "2021-04-11"
title = "Δημιουργική έξοδος από την κρίση: επαγγελματικό webshop με PrestaShop"
difficulty = "level-4"
tags = ["corona", "Docker", "docker-compose", "kreativ", "krise", "online-shop", "presta", "shop", "shopsystem"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210411-docker-PrestaShop/index.el.md"
+++
Το PrestaShop είναι μια ευρωπαϊκή πλατφόρμα ηλεκτρονικού εμπορίου ανοικτού κώδικα με, σύμφωνα με τις δικές της πληροφορίες, σήμερα πάνω από 300.000 εγκαταστάσεις. Σήμερα εγκαθιστώ αυτό το λογισμικό PHP στον διακομιστή μου. Για αυτό το σεμινάριο απαιτούνται κάποιες γνώσεις Linux, Docker και Docker Compose.
## Βήμα 1: Εγκαταστήστε το PrestaShop
Δημιουργώ έναν νέο κατάλογο με όνομα "prestashop" στον διακομιστή μου:
{{< terminal >}}
mkdir prestashop
cd prestashop

{{</ terminal >}}
Στη συνέχεια, πηγαίνω στον κατάλογο prestashop και δημιουργώ ένα νέο αρχείο με όνομα "prestashop.yml" με το ακόλουθο περιεχόμενο.
```
version: '2'

services:
  mariadb:
    image: mysql:5.7
    environment:
      - MYSQL_ROOT_PASSWORD=admin
      - MYSQL_DATABASE=prestashop
      - MYSQL_USER=prestashop
      - MYSQL_PASSWORD=prestashop
    volumes:
      - ./mysql:/var/lib/mysql
    expose:
      - 3306
    networks:
      - shop-network
    restart: always

  prestashop:
    image: prestashop/prestashop:1.7.7.2
    ports:
      - 8090:80
    depends_on:
      - mariadb
    volumes:
      - ./prestadata:/var/www/html
      - ./prestadata/modules:/var/www/html/modules
      - ./prestadata/themes:/var/www/html/themes
      - ./prestadata/override:/var/www/html/override
    environment:
      - PS_INSTALL_AUTO=0
    networks:
      - shop-network
    restart: always

networks:
  shop-network:

```
Δυστυχώς, η τρέχουσα τελευταία έκδοση δεν δούλευε για μένα, οπότε εγκατέστησα την έκδοση "1.7.7.2". Αυτό το αρχείο εκκινείται μέσω του Docker Compose:
{{< terminal >}}
docker-compose -f prestashop.yml up

{{</ terminal >}}
Είναι προτιμότερο να πάρετε φρέσκο καφέ, επειδή η διαδικασία διαρκεί πολύ. Η διεπαφή μπορεί να χρησιμοποιηθεί μόνο όταν εμφανίζεται το ακόλουθο κείμενο.
{{< gallery match="images/1/*.png" >}}
Στη συνέχεια, μπορώ να καλέσω τον διακομιστή PrestaShop και να συνεχίσω την εγκατάσταση μέσω της διεπαφής.
{{< gallery match="images/2/*.png" >}}
Τελειώνω το Docker-Compose με το "Ctrl C" και καλώ τον υποφάκελο "prestadata" ("cd prestadata"). Εκεί, ο φάκελος "install" πρέπει να διαγραφεί με την εντολή "rm -r install".
{{< gallery match="images/3/*.png" >}}
Επιπλέον, υπάρχει ένας φάκελος "Admin" εκεί, στην περίπτωσή μου "admin697vqoryt". Θυμάμαι αυτή τη συντομογραφία για αργότερα και ξεκινάω ξανά τον διακομιστή μέσω του Docker Compose:
{{< terminal >}}
docker-compose -f prestashop.yml up -d

{{</ terminal >}}

## Βήμα 2: Δοκιμάστε το κατάστημα
Μετά την επανεκκίνηση, δοκιμάζω την εγκατάσταση του καταστήματός μου Presta και καλώ επίσης τη διεπαφή διαχείρισης στο "shop-url/admin shortcuts".
{{< gallery match="images/4/*.png" >}}
