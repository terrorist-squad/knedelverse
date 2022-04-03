+++
date = "2022-04-02"
title = "Μεγάλα πράγματα με δοχεία: Εγκαθιστώντας το Jitsy"
difficulty = "level-5"
tags = ["Jitsi", "docker", "docker-compose", "meeting", "video", "server", "synology"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2022/april/20220402-docker-jitsi/index.el.md"
+++
Με το Jitsi μπορείτε να δημιουργήσετε και να αναπτύξετε μια ασφαλή λύση τηλεδιάσκεψης. Σήμερα δείχνω πώς να εγκαταστήσετε μια υπηρεσία Jitsi σε έναν διακομιστή, αναφορά: https://jitsi.github.io/handbook/docs/devops-guide/devops-guide-docker/ .
## Βήμα 1: Δημιουργήστε το φάκελο "jitsi"
Δημιουργώ έναν νέο κατάλογο με όνομα "jitsi" για την εγκατάσταση.
{{< terminal >}}
mkdir jitsi/
wget https://github.com/jitsi/docker-jitsi-meet/archive/refs/tags/stable-7001.zip
unzip  stable-7001.zip -d jitsi/
rm stable-7001.zip 
cd /docker/jitsi/docker-jitsi-meet-stable-7001

{{</ terminal >}}

## Βήμα 2: Διαμόρφωση
Τώρα αντιγράφω την τυπική διαμόρφωση και την προσαρμόζω.
{{< terminal >}}
cp env.example .env

{{</ terminal >}}
Βλέπε:
{{< gallery match="images/1/*.png" >}}
Για να χρησιμοποιήσετε ισχυρούς κωδικούς πρόσβασης στις επιλογές ασφαλείας του αρχείου .env, θα πρέπει να εκτελέσετε μία φορά το ακόλουθο σενάριο bash.
{{< terminal >}}
./gen-passwords.sh

{{</ terminal >}}
Τώρα θα δημιουργήσω μερικούς ακόμα φακέλους για το Jitsi.
{{< terminal >}}
mkdir -p ./jitsi-meet-cfg/{web/crontabs,web/letsencrypt,transcripts,prosody/config,prosody/prosody-plugins-custom,jicofo,jvb,jigasi,jibri}

{{</ terminal >}}
Ο διακομιστής Jitsi μπορεί στη συνέχεια να ξεκινήσει.
{{< terminal >}}
docker-compose up

{{</ terminal >}}
Μετά από αυτό μπορείτε να χρησιμοποιήσετε τον διακομιστή Jitsi!
{{< gallery match="images/2/*.png" >}}

