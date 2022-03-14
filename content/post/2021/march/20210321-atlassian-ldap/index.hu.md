+++
date = "2021-03-24"
title = "Király dolgok az Atlassiannal: Használja az összes Atlassian eszközt LDAP-pal"
difficulty = "level-3"
tags = ["atlassian", "bamboo", "jira", "ldap", "openldap", "linux", "test"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/march/20210321-atlassian-ldap/index.hu.md"
+++
Ön szerencsés, ha saját Atlassian telepítéssel rendelkezik. Ma megmutatom, hogyan csatlakoztattam a Jira-t, a Bamboo-t és a Confluence-t az LDAP-kiszolgálómhoz.
## 1. lépés: Az OpenLDAP telepítése
Beállítottam az OpenLDAP-ot ezzel a Docker Compose-fájllal a Synology NAS-on.
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

## 2. lépés: Az OpenLDAP beállítása
Az LDAP-kiszolgálóban létrehoztam csoportokat a különböző eszközökhöz.
{{< gallery match="images/1/*.png" >}}

## 3. lépés: Atlassian eszközök csatlakoztatása
A beállítás az összes Atlassian eszköz esetében ugyanaz. Megadom az LDAP-kiszolgáló IP-címét és portját.
{{< gallery match="images/2/*.png" >}}
Az "LDAP séma" esetében csak az "Alapvető DN" értéket adtam meg. A saját aláírású tanúsítványok esetében a "Biztonságos SSL" opciót ki kell kapcsolni.
{{< gallery match="images/3/*.png" >}}

## Az önaláírt tanúsítványok egyéb különleges jellemzői
Mivel saját aláírt tanúsítványt használok, a truststore-ba a következővel lépek be
```
-Dcom.sun.jndi.ldap.object.disableEndpointIdentification=true -Djdk.tls.trustNameService=true -Dcom.sun.jndi.ldap.object.disableEndpointIdentification -Djavax.net.ssl.trustStore=/store/keystore.jks -Djavax.net.ssl.trustStorePassword=password

```
Lásd:
{{< gallery match="images/4/*.png" >}}

## 4. lépés: Felhasználói és csoportos séma
A következő felhasználói és csoportbeállításokat vettem fel. A legfontosabb dolog a "csoportos objektumszűrő" beállítás. Természetesen ez a Bamboo, a Confluence és a Jira esetében más és más.
{{< gallery match="images/5/*.png" >}}