+++
date = "2021-03-24"
title = "Cose fantastiche con Atlassian: usare tutti gli strumenti Atlassian con LDAP"
difficulty = "level-3"
tags = ["atlassian", "bamboo", "jira", "ldap", "openldap", "linux", "test"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/march/20210321-atlassian-ldap/index.it.md"
+++
Siete fortunati se avete la vostra installazione di Atlassian. Oggi mostro come ho collegato Jira, Bamboo e Confluence al mio server LDAP.
## Passo 1: installare OpenLDAP
Ho impostato OpenLDAP con questo file Docker Compose sul mio Synology NAS.
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

## Passo 2: impostare OpenLDAP
Nel server LDAP ho creato dei gruppi per i diversi strumenti.
{{< gallery match="images/1/*.png" >}}

## Passo 3: collegare gli strumenti Atlassian
La configurazione è la stessa per tutti gli strumenti Atlassian. Inserisco l'indirizzo IP e la porta del mio server LDAP.
{{< gallery match="images/2/*.png" >}}
Per lo "schema LDAP" ho inserito solo il "DN di base". Per i certificati autofirmati, l'opzione "Secure SSL" deve essere disattivata.
{{< gallery match="images/3/*.png" >}}

## Altre caratteristiche speciali dei certificati autofirmati
Dato che uso un certificato autofirmato, entro nel mio truststore con
```
-Dcom.sun.jndi.ldap.object.disableEndpointIdentification=true -Djdk.tls.trustNameService=true -Dcom.sun.jndi.ldap.object.disableEndpointIdentification -Djavax.net.ssl.trustStore=/store/keystore.jks -Djavax.net.ssl.trustStorePassword=password

```
Vedere:
{{< gallery match="images/4/*.png" >}}

## Passo 4: schema degli utenti e dei gruppi
Ho preso le seguenti impostazioni di utenti e gruppi. Il più importante è l'impostazione del "filtro degli oggetti di gruppo". Naturalmente, questo è diverso per Bamboo, Confluence e Jira.
{{< gallery match="images/5/*.png" >}}
