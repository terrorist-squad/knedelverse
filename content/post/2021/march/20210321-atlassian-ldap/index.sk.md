+++
date = "2021-03-24"
title = "Parádne veci s Atlassian: Používanie všetkých nástrojov Atlassian s LDAP"
difficulty = "level-3"
tags = ["atlassian", "bamboo", "jira", "ldap", "openldap", "linux", "test"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/march/20210321-atlassian-ldap/index.sk.md"
+++
Máte šťastie, ak máte vlastnú inštaláciu Atlassian. Dnes ukážem, ako som pripojil Jira, Bamboo a Confluence k serveru LDAP.
## Krok 1: Inštalácia OpenLDAP
Nastavil som OpenLDAP pomocou tohto súboru Docker Compose na svojom Synology NAS.
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

## Krok 2: Nastavenie OpenLDAP
Na serveri LDAP som vytvoril skupiny pre rôzne nástroje.
{{< gallery match="images/1/*.png" >}}

## Krok 3: Pripojenie nástrojov Atlassian
Nastavenie je rovnaké pre všetky nástroje Atlassian. Zadám IP adresu a port svojho servera LDAP.
{{< gallery match="images/2/*.png" >}}
Pre "schému LDAP" som zadal iba "Základné DN". V prípade certifikátov podpísaných vlastným podpisom je potrebné deaktivovať možnosť "Zabezpečiť SSL".
{{< gallery match="images/3/*.png" >}}

## Ďalšie špeciálne vlastnosti certifikátov s vlastným podpisom
Keďže používam certifikát s vlastným podpisom, zadávam svoj truststore pomocou
```
-Dcom.sun.jndi.ldap.object.disableEndpointIdentification=true -Djdk.tls.trustNameService=true -Dcom.sun.jndi.ldap.object.disableEndpointIdentification -Djavax.net.ssl.trustStore=/store/keystore.jks -Djavax.net.ssl.trustStorePassword=password

```
Pozri:
{{< gallery match="images/4/*.png" >}}

## Krok 4: Schéma používateľov a skupín
Prevzal som nasledujúce nastavenia používateľov a skupín. Najdôležitejšie je nastavenie "filter objektov skupiny". Samozrejme, pre Bamboo, Confluence a Jira je to iné.
{{< gallery match="images/5/*.png" >}}