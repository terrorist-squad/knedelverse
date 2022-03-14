+++
date = "2021-02-28"
title = "Μεγάλα πράγματα με δοχεία: Heimdall ως αρχική σελίδα"
difficulty = "level-3"
tags = ["dienste", "Docker", "docker-compose", "docker-for-desktop", "heimdall", "homepage", "startseite"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/february/20210228-docker-heimdall/index.el.md"
+++
Εκτελώ πολλές υπηρεσίες στο δίκτυο Homelab, για παράδειγμα LDAP, Gitlab, Atlassian Bamboo, Atlassian Confluence, Atlassian Jira, Jenkins, WordPress, Grafana, Graylog ,ESXI/VMware, Calibre και πολλά άλλα. Είναι εύκολο να χάσετε την αίσθηση των πάντων.
{{< gallery match="images/1/*.jpg" >}}

## Βήμα 1: Δημιουργία φακέλου εργασίας
Χρησιμοποιήστε αυτήν την εντολή για να δημιουργήσετε έναν προσωρινό φάκελο εργασίας:
{{< terminal >}}
mkdir /tmp/bilder

{{</ terminal >}}
Το Heimdall είναι μια υπηρεσία που σας επιτρέπει να διαχειρίζεστε σελιδοδείκτες μέσω του Dashboard. Δεδομένου ότι χρησιμοποιώ το Docker for Desktop, χρειάζεται μόνο να τοποθετήσω αυτό το αρχείο Docker Compose σε έναν τοπικό φάκελο:
```
version: "2.1"
services:
  heimdall:
    image: linuxserver/heimdall
    container_name: heimdall
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=Europe/Berlin
    volumes:
      - /Users/christianknedel/docker/heimdall/config:/config
    ports:
      - 80:80
      - 443:443
    restart: always

```
Αυτό το αρχείο εκκινείται μέσω του Docker Compose:
{{< terminal >}}
ocker-compose -f compose-file.yml up -d

{{</ terminal >}}

{{< gallery match="images/2/*.png" >}}
