+++
date = "2021-03-24"
title = "Lucruri interesante cu Atlassian: Utilizați toate instrumentele Atlassian cu LDAP"
difficulty = "level-3"
tags = ["atlassian", "bamboo", "jira", "ldap", "openldap", "linux", "test"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/march/20210321-atlassian-ldap/index.ro.md"
+++
Sunteți norocos dacă aveți propria instalație Atlassian. Astăzi vă arăt cum am conectat Jira, Bamboo și Confluence la serverul meu LDAP.
## Pasul 1: Instalați OpenLDAP
Am configurat OpenLDAP cu acest fișier Docker Compose pe NAS-ul meu Synology.
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

## Pasul 2: Configurați OpenLDAP
În serverul LDAP am creat grupuri pentru diferitele instrumente.
{{< gallery match="images/1/*.png" >}}

## Pasul 3: Conectați instrumentele Atlassian
Configurația este aceeași pentru toate instrumentele Atlassian. Introduc adresa IP și portul serverului meu LDAP.
{{< gallery match="images/2/*.png" >}}
Pentru "Schema LDAP", am introdus doar "Basic DN". În cazul certificatelor autofirmate, opțiunea "Secure SSL" trebuie dezactivată.
{{< gallery match="images/3/*.png" >}}

## Alte caracteristici speciale ale certificatelor auto-semnate
Deoarece folosesc un certificat semnat de mine însumi, introduc truststore-ul meu cu
```
-Dcom.sun.jndi.ldap.object.disableEndpointIdentification=true -Djdk.tls.trustNameService=true -Dcom.sun.jndi.ldap.object.disableEndpointIdentification -Djavax.net.ssl.trustStore=/store/keystore.jks -Djavax.net.ssl.trustStorePassword=password

```
A se vedea:
{{< gallery match="images/4/*.png" >}}

## Pasul 4: Schema de utilizatori și grupuri
Am luat următoarele setări de utilizator și grup. Cea mai importantă este setarea "filtru obiect grup". Desigur, acest lucru este diferit pentru Bamboo, Confluence și Jira.
{{< gallery match="images/5/*.png" >}}