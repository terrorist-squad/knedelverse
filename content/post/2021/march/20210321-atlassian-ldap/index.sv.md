+++
date = "2021-03-24"
title = "Coola saker med Atlassian: Använd alla Atlassian-verktyg med LDAP"
difficulty = "level-3"
tags = ["atlassian", "bamboo", "jira", "ldap", "openldap", "linux", "test"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/march/20210321-atlassian-ldap/index.sv.md"
+++
Du har tur om du har en egen Atlassianinstallation. Idag visar jag hur jag kopplade Jira, Bamboo och Confluence till min LDAP-server.
## Steg 1: Installera OpenLDAP
Jag har konfigurerat OpenLDAP med denna Docker Compose-fil på min Synology NAS.
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

## Steg 2: Konfigurera OpenLDAP
På LDAP-servern har jag skapat grupper för de olika verktygen.
{{< gallery match="images/1/*.png" >}}

## Steg 3: Anslut Atlassian-verktyg
Inställningen är densamma för alla Atlassian-verktyg. Jag anger IP-adress och port för min LDAP-server.
{{< gallery match="images/2/*.png" >}}
För "LDAP scheme" har jag bara angett "Basic DN". För självsignerade certifikat måste alternativet "Secure SSL" avaktiveras.
{{< gallery match="images/3/*.png" >}}

## Andra särskilda egenskaper hos självsignerade certifikat
Eftersom jag använder ett självsignerat certifikat anger jag mitt truststore med
```
-Dcom.sun.jndi.ldap.object.disableEndpointIdentification=true -Djdk.tls.trustNameService=true -Dcom.sun.jndi.ldap.object.disableEndpointIdentification -Djavax.net.ssl.trustStore=/store/keystore.jks -Djavax.net.ssl.trustStorePassword=password

```
Se:
{{< gallery match="images/4/*.png" >}}

## Steg 4: System för användare och grupper
Jag har tagit följande användar- och gruppinställningar. Det viktigaste är inställningen för "gruppobjektfilter". Detta är naturligtvis annorlunda för Bamboo, Confluence och Jira.
{{< gallery match="images/5/*.png" >}}