+++
date = "2021-03-24"
title = "Fajne rzeczy z Atlassian: Używaj wszystkich narzędzi Atlassian z LDAP"
difficulty = "level-3"
tags = ["atlassian", "bamboo", "jira", "ldap", "openldap", "linux", "test"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/march/20210321-atlassian-ldap/index.pl.md"
+++
Masz szczęście, jeśli posiadasz własną instalację Atlassiana. Dzisiaj pokażę jak podłączyłem Jira, Bamboo i Confluence do mojego serwera LDAP.
## Krok 1: Zainstaluj OpenLDAP
Skonfigurowałem OpenLDAP z tym plikiem Docker Compose na moim Synology NAS.
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

## Krok 2: Skonfiguruj OpenLDAP
W serwerze LDAP utworzyłem grupy dla różnych narzędzi.
{{< gallery match="images/1/*.png" >}}

## Krok 3: Podłącz narzędzia Atlassian
Konfiguracja jest taka sama dla wszystkich narzędzi Atlassian. Wprowadzam adres IP i port mojego serwera LDAP.
{{< gallery match="images/2/*.png" >}}
Dla "schematu LDAP" wprowadziłem tylko "Podstawowy DN". W przypadku certyfikatów samopodpisanych należy dezaktywować opcję "Secure SSL".
{{< gallery match="images/3/*.png" >}}

## Inne cechy szczególne certyfikatów samopodpisanych
Ponieważ używam certyfikatu samopodpisanego, do truststore wpisuję
```
-Dcom.sun.jndi.ldap.object.disableEndpointIdentification=true -Djdk.tls.trustNameService=true -Dcom.sun.jndi.ldap.object.disableEndpointIdentification -Djavax.net.ssl.trustStore=/store/keystore.jks -Djavax.net.ssl.trustStorePassword=password

```
Zobacz:
{{< gallery match="images/4/*.png" >}}

## Krok 4: Schemat użytkownika i grupy
Przyjąłem następujące ustawienia użytkownika i grupy. Najważniejszym z nich jest ustawienie "filtr obiektów grupowych". Oczywiście, jest to różne dla Bamboo, Confluence i Jira.
{{< gallery match="images/5/*.png" >}}