+++
date = "2021-03-24"
title = "Leuke dingen met Atlassian: Gebruik alle Atlassian tools met LDAP"
difficulty = "level-3"
tags = ["atlassian", "bamboo", "jira", "ldap", "openldap", "linux", "test"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/march/20210321-atlassian-ldap/index.nl.md"
+++
Je hebt geluk als je een eigen Atlassian installatie hebt. Vandaag laat ik zien hoe ik Jira, Bamboo en Confluence aan mijn LDAP server heb gekoppeld.
## Stap 1: Installeer OpenLDAP
Ik heb OpenLDAP ingesteld met dit Docker Compose bestand op mijn Synology NAS.
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

## Stap 2: OpenLDAP instellen
In de LDAP server heb ik groepen aangemaakt voor de verschillende gereedschappen.
{{< gallery match="images/1/*.png" >}}

## Stap 3: Atlassian tools verbinden
De setup is hetzelfde voor alle Atlassian tools. Ik voer het IP adres en de poort van mijn LDAP server in.
{{< gallery match="images/2/*.png" >}}
Voor het "LDAP-schema" heb ik alleen de "Basis DN" ingevoerd. Voor zelfondertekende certificaten moet de optie "Secure SSL" gedeactiveerd worden.
{{< gallery match="images/3/*.png" >}}

## Andere speciale kenmerken van zelfondertekende certificaten
Aangezien ik een zelf-ondertekend certificaat gebruik, voer ik mijn vertrouwenswinkel in met
```
-Dcom.sun.jndi.ldap.object.disableEndpointIdentification=true -Djdk.tls.trustNameService=true -Dcom.sun.jndi.ldap.object.disableEndpointIdentification -Djavax.net.ssl.trustStore=/store/keystore.jks -Djavax.net.ssl.trustStorePassword=password

```
Zie:
{{< gallery match="images/4/*.png" >}}

## Stap 4: Gebruikers- en groepsschema
Ik heb de volgende gebruikers- en groepsinstellingen genomen. Het belangrijkste is de "groep object filter" instelling. Dit is natuurlijk anders voor Bamboo, Confluence en Jira.
{{< gallery match="images/5/*.png" >}}