+++
date = "2021-03-24"
title = "Ωραία πράγματα με την Atlassian: Χρησιμοποιήστε όλα τα εργαλεία της Atlassian με LDAP"
difficulty = "level-3"
tags = ["atlassian", "bamboo", "jira", "ldap", "openldap", "linux", "test"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/march/20210321-atlassian-ldap/index.el.md"
+++
Είστε τυχεροί αν έχετε τη δική σας εγκατάσταση Atlassian. Σήμερα θα δείξω πώς σύνδεσα τα Jira, Bamboo και Confluence με τον διακομιστή LDAP.
## Βήμα 1: Εγκατάσταση του OpenLDAP
Έχω ρυθμίσει το OpenLDAP με αυτό το αρχείο Docker Compose στο Synology NAS μου.
```
ersion: '2'
services:
  openldap:
    restart: always
    image: osixia/openldap
    container_name: openldap
    environment:
      LDAP_TLS: 'true'
      LDAP_TLS_CRT_FILENAME: '....pem'
      LDAP_TLS_KEY_FILENAME: '......pem'
      LDAP_TLS_CA_CRT_FILENAME: '......pem'
      LDAP_ORGANISATION: "365Layouts"
      LDAP_DOMAIN: "homelab.local"
      LDAP_BASE_DN: "dc=homelab,dc=local"
      LDAP_ADMIN_PASSWORD: "......"
      LDAP_TLS_CIPHER_SUITE: "NORMAL"
      LDAP_TLS_VERIFY_CLIENT: "allow"
      LDAP_TLS_CIPHER_SUITE: NORMAL
    tty: true
    stdin_open: true
    volumes:
      - ./ldap:/var/lib/ldap
      - ./slapdd:/etc/ldap/slapd.d
      - ./certs:/container/service/slapd/assets/certs/
      - ./memberof.ldif:/root/memberof.ldif
      - ./refint.ldif:/root/refint.ldif
    ports:
      - "389:389"
      - "636:636"
    hostname: "homelab.local"
    networks:
      - ldap

  phpldapadmin:
    restart: always
    image: osixia/phpldapadmin:latest
    container_name: phpldapadmin
    volumes:
      - ./ssl:/container/service/phpldapadmin/assets/apache2/certs
    environment:
      PHPLDAPADMIN_LDAP_HOSTS: "openldap"
      PHPLDAPADMIN_HTTPS_CRT_FILENAME: server-cert.crt
      PHPLDAPADMIN_HTTPS_KEY_FILENAME: server-cert.key
      PHPLDAPADMIN_HTTPS_CA_CRT_FILENAME: server-cert.crt
    ports:
      - "*****:443"
    depends_on:
      - openldap
    networks:
      - ldap

networks:
  ldap:

```

## Βήμα 2: Ρύθμιση του OpenLDAP
Στο διακομιστή LDAP έχω δημιουργήσει ομάδες για τα διάφορα εργαλεία.
{{< gallery match="images/1/*.png" >}}

## Βήμα 3: Συνδέστε τα εργαλεία Atlassian
Η ρύθμιση είναι η ίδια για όλα τα εργαλεία της Atlassian. Εισάγω τη διεύθυνση IP και τη θύρα του διακομιστή LDAP.
{{< gallery match="images/2/*.png" >}}
Για το "LDAP scheme", έχω εισάγει μόνο το "Basic DN". Για τα αυτο-υπογεγραμμένα πιστοποιητικά, η επιλογή "Secure SSL" πρέπει να απενεργοποιηθεί.
{{< gallery match="images/3/*.png" >}}

## Άλλα ειδικά χαρακτηριστικά των αυτο-υπογεγραμμένων πιστοποιητικών
Δεδομένου ότι χρησιμοποιώ ένα αυτο-υπογεγραμμένο πιστοποιητικό, εισάγω το truststore μου με
```
-Dcom.sun.jndi.ldap.object.disableEndpointIdentification=true -Djdk.tls.trustNameService=true -Dcom.sun.jndi.ldap.object.disableEndpointIdentification -Djavax.net.ssl.trustStore=/store/keystore.jks -Djavax.net.ssl.trustStorePassword=password

```
Βλέπε:
{{< gallery match="images/4/*.png" >}}

## Βήμα 4: Σχέδιο χρηστών και ομάδων
Έχω λάβει τις ακόλουθες ρυθμίσεις χρήστη και ομάδας. Το πιο σημαντικό πράγμα είναι η ρύθμιση "φίλτρο αντικειμένου ομάδας". Φυσικά, αυτό είναι διαφορετικό για το Bamboo, το Confluence και το Jira.
{{< gallery match="images/5/*.png" >}}