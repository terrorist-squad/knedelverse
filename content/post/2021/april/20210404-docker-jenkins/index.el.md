+++
date = "2021-04-04"
title = "Σύντομη ιστορία: Jenkins και openLDAP"
difficulty = "level-1"
tags = ["development", "devops", "Jenkins", "ldap", "linux", "openldap"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/april/20210404-docker-jenkins/index.el.md"
+++
Αυτό το σεμινάριο βασίζεται στην προηγούμενη γνώση του "[Μεγάλα πράγματα με κοντέινερ: Εκτέλεση του Jenkins στο Synology DS]({{< ref "post/2021/march/20210321-docker-jenkins" >}} "Μεγάλα πράγματα με κοντέινερ: Εκτέλεση του Jenkins στο Synology DS")". Αν έχετε ήδη LDAP στην αρχή, το μόνο που χρειάζεται είναι να δημιουργήσετε μια κατάλληλη ομάδα εφαρμογών:
{{< gallery match="images/1/*.png" >}}
Στη συνέχεια, πρέπει να εισαγάγετε τις ρυθμίσεις στο Jenkins. Κάνω κλικ στο "Manage Jenkins" > "Configure Global Security".
{{< gallery match="images/2/*.png" >}}
Σημαντικό: Για τα αυτο-υπογεγραμμένα πιστοποιητικά, το κατάστημα εμπιστοσύνης πρέπει να παρέχεται από το Java-Opts του διακομιστή Jenkins. Δεδομένου ότι ο διακομιστής Jenkins δημιουργήθηκε μέσω ενός αρχείου Docker Compose, μοιάζει κάπως έτσι για μένα:
```
version: '2.0'
services:
  jenkins:
    restart: always
    image: jenkins/jenkins:lts
    privileged: true
    user: root
    ports:
      - port:8443
      - port:50001
    container_name: jenkins
    environment:
      JENKINS_SLAVE_AGENT_PORT: 50001
      TZ: 'Europe/Berlin'
      JAVA_OPTS: '-Dcom.sun.jndi.ldap.object.disableEndpointIdentification=true -Djdk.tls.trustNameService=true -Djavax.net.ssl.trustStore=/store/keystore.jks -Djavax.net.ssl.trustStorePassword=pass'
      JENKINS_OPTS: "--httpsKeyStore='/store/keystore.jks' --httpsKeyStorePassword='pass' --httpPort=-1 --httpsPort=8443"
    volumes:
      - ./data:/var/jenkins_home
      - /var/run/docker.sock:/var/run/docker.sock
      - /usr/local/bin/docker:/usr/local/bin/docker
      - ./keystore.jks:/store/keystore.jks
      - ./certs:/certs
    logging:
   ..... usw

   ```