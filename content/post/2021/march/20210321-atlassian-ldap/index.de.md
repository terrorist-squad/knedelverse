+++
date = "2021-03-24"
title = "Cooles mit Atlassian: Alle Atlassian – Tools mit LDAP nutzen"
difficulty = "level-3"
tags = ["atlassian", "bamboo", "jira", "ldap", "openldap", "linux", "test"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/march/20210321-atlassian-ldap/index.de.md"
+++

Man kann sich glücklich schätzen, wenn man eine eigene Atlassian-Installation besitzt. Heute zeige ich, wie ich Jira, Bamboo und Confluence mit meinem LDAP-Server verbunden habe.

## Schritt 1: OpenLDAP installieren
Ich habe OpenLDAP mit dieser Docker-Compose-Datei auf meinem Synology-NAS eingerichtet.
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

## Schritt 2: OpenLDAP einrichten
Im LDAP-Server habe ich Gruppen für die verschiedenen Tools angelegt.
{{< gallery match="images/1/*.png" >}}

## Schritt 3: Atlassian-Tools verbinden
Das Setup ist bei allen Atlassian-Tools gleich. Ich gebe die IP-Adresse und Port meines LDAP-Servers an.
{{< gallery match="images/2/*.png" >}}

Beim „LDAP-Schema“ habe ich nur die „Basis-DN“ eingetragen. Bei selbstsignierten Zertifikaten muss die Option „Secure SSL“ deaktiviert werden.
{{< gallery match="images/3/*.png" >}}

## Sonstige Besonderheiten bei selbstsignierten Zertifikaten
Da ich ein selbstsigniertes Zertifikat verwende, gebe ich meinen truststore mit 
```
-Dcom.sun.jndi.ldap.object.disableEndpointIdentification=true -Djdk.tls.trustNameService=true -Dcom.sun.jndi.ldap.object.disableEndpointIdentification -Djavax.net.ssl.trustStore=/store/keystore.jks -Djavax.net.ssl.trustStorePassword=password
```

Siehe:
{{< gallery match="images/4/*.png" >}}

## Schritt 4: Benutzer- und Gruppen-Schema
Ich habe folgende Benutzer- und Gruppen-Einstellungen genommen. Das wichtigste ist die „Gruppenobjektfilter“-Einstellung. Die ist natürlich bei Bamboo, Confluence und Jira unterschiedlich.
{{< gallery match="images/5/*.png" >}}