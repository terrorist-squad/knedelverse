+++
date = "2021-03-24"
title = "Skvělé věci s Atlassianem: Použití všech nástrojů Atlassian s LDAP"
difficulty = "level-3"
tags = ["atlassian", "bamboo", "jira", "ldap", "openldap", "linux", "test"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/march/20210321-atlassian-ldap/index.cs.md"
+++
Máte štěstí, pokud máte vlastní instalaci Atlassian. Dnes ukážu, jak jsem připojil Jiru, Bamboo a Confluence k serveru LDAP.
## Krok 1: Instalace protokolu OpenLDAP
Nastavil jsem OpenLDAP pomocí tohoto souboru Docker Compose na svém zařízení Synology NAS.
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

## Krok 2: Nastavení protokolu OpenLDAP
Na serveru LDAP jsem vytvořil skupiny pro různé nástroje.
{{< gallery match="images/1/*.png" >}}

## Krok 3: Připojení nástrojů Atlassian
Nastavení je stejné pro všechny nástroje Atlassian. Zadám IP adresu a port serveru LDAP.
{{< gallery match="images/2/*.png" >}}
Pro "schéma LDAP" jsem zadal pouze "základní DN". U certifikátů podepsaných vlastním podpisem je třeba deaktivovat možnost "Zabezpečit SSL".
{{< gallery match="images/3/*.png" >}}

## Další zvláštní vlastnosti certifikátů podepsaných vlastním podpisem
Protože používám certifikát podepsaný vlastním podpisem, zadávám do úložiště důvěryhodných informací příkaz
```
-Dcom.sun.jndi.ldap.object.disableEndpointIdentification=true -Djdk.tls.trustNameService=true -Dcom.sun.jndi.ldap.object.disableEndpointIdentification -Djavax.net.ssl.trustStore=/store/keystore.jks -Djavax.net.ssl.trustStorePassword=password

```
Viz:
{{< gallery match="images/4/*.png" >}}

## Krok 4: Schéma uživatelů a skupin
Přijal jsem následující nastavení uživatelů a skupin. Nejdůležitější je nastavení "filtru skupinových objektů". To se samozřejmě liší pro Bamboo, Confluence a Jiru.
{{< gallery match="images/5/*.png" >}}