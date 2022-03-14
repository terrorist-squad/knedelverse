+++
date = "2021-03-24"
title = "Готини неща с Atlassian: Използвайте всички инструменти на Atlassian с LDAP"
difficulty = "level-3"
tags = ["atlassian", "bamboo", "jira", "ldap", "openldap", "linux", "test"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/march/20210321-atlassian-ldap/index.bg.md"
+++
Имате късмет, ако разполагате със собствена инсталация на Atlassian. Днес ще покажа как свързах Jira, Bamboo и Confluence с моя LDAP сървър.
## Стъпка 1: Инсталиране на OpenLDAP
Настроих OpenLDAP с този Docker Compose файл на моето Synology NAS.
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

## Стъпка 2: Настройка на OpenLDAP
В сървъра LDAP съм създал групи за различните инструменти.
{{< gallery match="images/1/*.png" >}}

## Стъпка 3: Свързване на инструментите на Atlassian
Настройката е една и съща за всички инструменти на Atlassian. Въвеждам IP адреса и порта на моя LDAP сървър.
{{< gallery match="images/2/*.png" >}}
За "LDAP схемата" съм въвел само "Basic DN". За самоподписани сертификати опцията "Secure SSL" трябва да бъде деактивирана.
{{< gallery match="images/3/*.png" >}}

## Други специални характеристики на самоподписаните сертификати
Тъй като използвам собственоръчно подписан сертификат, въвеждам хранилището на доверие с
```
-Dcom.sun.jndi.ldap.object.disableEndpointIdentification=true -Djdk.tls.trustNameService=true -Dcom.sun.jndi.ldap.object.disableEndpointIdentification -Djavax.net.ssl.trustStore=/store/keystore.jks -Djavax.net.ssl.trustStorePassword=password

```
Вижте:
{{< gallery match="images/4/*.png" >}}

## Стъпка 4: Схема на потребителите и групите
Приех следните настройки на потребителите и групите. Най-важното нещо е настройката "филтър за групови обекти". Разбира се, това е различно за Bamboo, Confluence и Jira.
{{< gallery match="images/5/*.png" >}}