+++
date = "2021-03-24"
title = "Fede ting med Atlassian: Brug alle Atlassian-værktøjer med LDAP"
difficulty = "level-3"
tags = ["atlassian", "bamboo", "jira", "ldap", "openldap", "linux", "test"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/march/20210321-atlassian-ldap/index.da.md"
+++
Du er heldig, hvis du har din egen Atlassian installation. I dag viser jeg, hvordan jeg forbandt Jira, Bamboo og Confluence til min LDAP-server.
## Trin 1: Installer OpenLDAP
Jeg har konfigureret OpenLDAP med denne Docker Compose-fil på min Synology NAS.
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

## Trin 2: Opsætning af OpenLDAP
I LDAP-serveren har jeg oprettet grupper til de forskellige værktøjer.
{{< gallery match="images/1/*.png" >}}

## Trin 3: Tilslut Atlassian værktøjer
Opsætningen er den samme for alle Atlassian værktøjer. Jeg indtaster IP-adressen og porten på min LDAP-server.
{{< gallery match="images/2/*.png" >}}
For "LDAP scheme" har jeg kun indtastet "Basic DN". For selv-signerede certifikater skal indstillingen "Secure SSL" være deaktiveret.
{{< gallery match="images/3/*.png" >}}

## Andre særlige egenskaber ved selvsignerede certifikater
Da jeg bruger et selvsigneret certifikat, indtaster jeg min truststore med
```
-Dcom.sun.jndi.ldap.object.disableEndpointIdentification=true -Djdk.tls.trustNameService=true -Dcom.sun.jndi.ldap.object.disableEndpointIdentification -Djavax.net.ssl.trustStore=/store/keystore.jks -Djavax.net.ssl.trustStorePassword=password

```
Se:
{{< gallery match="images/4/*.png" >}}

## Trin 4: Bruger- og gruppeordning
Jeg har taget følgende bruger- og gruppeindstillinger. Den vigtigste er indstillingen "gruppeobjektfilter". Dette er naturligvis forskelligt for Bamboo, Confluence og Jira.
{{< gallery match="images/5/*.png" >}}
