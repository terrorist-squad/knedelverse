+++
date = "2021-03-24"
title = "Siistejä asioita Atlassianin kanssa: Käytä kaikkia Atlassianin työkaluja LDAP:n kanssa."
difficulty = "level-3"
tags = ["atlassian", "bamboo", "jira", "ldap", "openldap", "linux", "test"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/march/20210321-atlassian-ldap/index.fi.md"
+++
Olet onnekas, jos sinulla on oma Atlassian-asennus. Tänään näytän, miten yhdistin Jiran, Bamboon ja Confluence-palvelimen LDAP-palvelimeen.
## Vaihe 1: Asenna OpenLDAP
Olen asentanut OpenLDAP:n tällä Docker Compose -tiedostolla Synology NAS:ssani.
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

## Vaihe 2: OpenLDAP:n määrittäminen
Olen luonut LDAP-palvelimessa ryhmät eri työkaluille.
{{< gallery match="images/1/*.png" >}}

## Vaihe 3: Yhdistä Atlassian-työkalut
Asetukset ovat samat kaikille Atlassian-työkaluille. Syötän LDAP-palvelimen IP-osoitteen ja portin.
{{< gallery match="images/2/*.png" >}}
LDAP-suunnitelmaa varten olen syöttänyt vain "Basic DN". Itse allekirjoitettujen varmenteiden osalta vaihtoehto "Secure SSL" on poistettava käytöstä.
{{< gallery match="images/3/*.png" >}}

## Muut itse allekirjoitettujen varmenteiden erityisominaisuudet
Koska käytän itse allekirjoitettua varmennetta, syötän truststoreen komennolla
```
-Dcom.sun.jndi.ldap.object.disableEndpointIdentification=true -Djdk.tls.trustNameService=true -Dcom.sun.jndi.ldap.object.disableEndpointIdentification -Djavax.net.ssl.trustStore=/store/keystore.jks -Djavax.net.ssl.trustStorePassword=password

```
Katso:
{{< gallery match="images/4/*.png" >}}

## Vaihe 4: Käyttäjä- ja ryhmäjärjestelmä
Olen ottanut seuraavat käyttäjä- ja ryhmäasetukset. Tärkein asia on "ryhmäkohteiden suodatin" -asetus. Tämä on tietysti erilaista Bamboon, Confluenceen ja Jiraan.
{{< gallery match="images/5/*.png" >}}