+++
date = "2021-04-14"
title = "Uncool με την Atlassian: πώς να αντιμετωπίσετε την πολιτική της Atlassian"
difficulty = "level-3"
tags = ["atlassian", "Atlassian-Politik", "bamboo", "Docker", "confluence", "docker-compose", "jira", "lizenz", "krise", "politik"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/april/20210414-docker-Atlassian-Politik/index.el.md"
+++
Η Atlassian σταμάτησε να πουλάει τις μικρές άδειες χρήσης διακομιστή και σκεφτόμουν για πολύ καιρό πώς να το αντιμετωπίσω αυτό. Δεδομένου ότι θέλω να χρησιμοποιώ την εγκατάστασή μου για μεγάλο χρονικό διάστημα, έχω εφαρμόσει τα ακόλουθα μέτρα:
## Μέτρο 1: Χρησιμοποιώ αποκλειστικά το Docker
Εκτελώ όλα τα εργαλεία της Atlassian ως δοχεία Docker. Παλαιότερες, εγγενείς εγκαταστάσεις μπορούν επίσης να μεταφερθούν σε μια εγκατάσταση Docker μέσω εκφορτώσεων βάσεων δεδομένων. Αυτά μπορούν στη συνέχεια να εκτελούνται άνετα σε ένα intel Nuc ή ένα σταθμό δίσκων Synology στο Homelab.
{{< tabs>}}


{{< tab "Jira">}}


```
version: '2'
services:
  jira:
    image: atlassian/jira-software
    container_name: jira_application
    depends_on:
      - db
    restart: always
    environment:
      TZ: 'Europe/Berlin'
    ports:
      - 8080:8080
    volumes:
      - ./jira-data:/var/atlassian/application-data/jira
    networks:
      - jira-network
      
  db:
    restart: always
    image: postgres:latest
    container_name: jira_db
    volumes:
      - ./postgresql:/var/lib/postgresql/data
    environment:
      - POSTGRES_USER=jira
      - POSTGRES_PASSWORD=jirapass
      - POSTGRES_DB=jira
    networks:
      - jira-network

networks:
  jira-network:


```

{{< /tab >}}


{{< tab"Confluence">}}


```
version: '2'
services:
  confluence:
    container_name: confluence_server
    image: atlassian/confluence-server:latest
    restart: always
    environment:
      TZ: "Europe/Berlin"
    volumes:
      - ./confluence:/var/atlassian/application-data/confluence/
    ports:
      - 8080:8080
    networks:
      - confluence-network
    depends_on:
      - db

  db:
    image: postgres:latest
    container_name: confluence_postgres
    restart: always
    volumes:
      - /postgresql:/var/lib/postgresql/data
    environment:
      - POSTGRES_USER=confluencedb
      - POSTGRES_PASSWORD=confluence-password
      - POSTGRES_DB=confluenceUser
    networks:
      - confluence-network

networks:
  confluence-network:

```

{{< /tab >}}


{{< tab"Bamboo">}}


```
version: '2'

services:
  bamboo:
    container_name: bamboo_server
    image: atlassian/bamboo-server
    restart: always
    environment:
      TZ: "Europe/Berlin"
    volumes:
      - ./bamboo-data:/var/atlassian/application-data/bamboo
    ports:
      - 8080:8080
    networks:
      - bamboo-network
    depends_on:
      - db

  db:
    image: postgres:latest
    container_name: bamboo-postgres
    restart: always
    volumes:
      - ./postgresql:/var/lib/postgresql/data
    environment:
      - POSTGRES_USER=bamboo
      - POSTGRES_PASSWORD=bamboo
      - POSTGRES_DB=bamboo
    networks:
      - bamboo-network

networks:
  bamboo-network:


```

{{< /tab >}}


{{< /tabs >}}


## Μέτρο 2: Δημιουργία αντιγράφων ασφαλείας των βάσεων δεδομένων και των εικόνων
Φυσικά, τα καθημερινά, αποκεντρωμένα αντίγραφα ασφαλείας της βάσης δεδομένων παίζουν μεγάλο ρόλο στη στρατηγική μου για την ανάκαμψη από καταστροφές. Αλλά έκανα επίσης αντίγραφα ασφαλείας των εικόνων εγκατάστασης. Μια εικόνα Docker μπορεί να αρχειοθετηθεί με την ακόλουθη εντολή:
{{< terminal >}}
docker save -o bamboo-7.2.3-image.tar atlassian/bamboo-server

{{</ terminal >}}
Το αρχείο μπορεί να φορτωθεί στο μητρώο Docker ως εξής.
{{< terminal >}}
ocker load -i bamboo-7.2.3-image.tar

{{</ terminal >}}
Έχω επίσης αποθηκεύσει τις εικόνες του Postgres.
## Ενέργεια 3: Δημιουργία στικάκι εγκατάστασης USB
Έχω δημιουργήσει αντίγραφα ασφαλείας της τεκμηρίωσής μου, όλων των αρχείων εγκατάστασης, των καταλόγων δεδομένων του Postgres και των ρυθμίσεων σε ένα στικάκι USB. Όπως είπα, το αντίγραφο ασφαλείας της ΒΔ είναι στην πραγματικότητα το πιο σημαντικό πράγμα, επειδή η ενεργοποιημένη άδεια χρήσης βρίσκεται επίσης στη βάση δεδομένων.
{{< gallery match="images/1/*.png" >}}
