+++
date = "2021-03-24"
title = "Крутые вещи с Atlassian: используйте все инструменты Atlassian с помощью LDAP"
difficulty = "level-3"
tags = ["atlassian", "bamboo", "jira", "ldap", "openldap", "linux", "test"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/march/20210321-atlassian-ldap/index.ru.md"
+++
Вам повезло, если у вас есть собственная установка Atlassian. Сегодня я покажу, как я подключил Jira, Bamboo и Confluence к моему серверу LDAP.
## Шаг 1: Установите OpenLDAP
Я установил OpenLDAP с помощью этого файла Docker Compose на NAS Synology.
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

## Шаг 2: Настройка OpenLDAP
На сервере LDAP я создал группы для различных инструментов.
{{< gallery match="images/1/*.png" >}}

## Шаг 3: Подключите инструменты Atlassian
Настройка одинакова для всех инструментов Atlassian. Я ввожу IP-адрес и порт моего сервера LDAP.
{{< gallery match="images/2/*.png" >}}
Для "схемы LDAP" я ввел только "Основной DN". Для самоподписанных сертификатов опция "Secure SSL" должна быть деактивирована.
{{< gallery match="images/3/*.png" >}}

## Другие особенности самоподписанных сертификатов
Так как я использую самоподписанный сертификат, я ввожу свое хранилище доверия со словами
```
-Dcom.sun.jndi.ldap.object.disableEndpointIdentification=true -Djdk.tls.trustNameService=true -Dcom.sun.jndi.ldap.object.disableEndpointIdentification -Djavax.net.ssl.trustStore=/store/keystore.jks -Djavax.net.ssl.trustStorePassword=password

```
См:
{{< gallery match="images/4/*.png" >}}

## Шаг 4: Схема пользователей и групп
Я принял следующие настройки пользователей и групп. Наиболее важным является параметр "фильтр групповых объектов". Конечно, это отличается для Bamboo, Confluence и Jira.
{{< gallery match="images/5/*.png" >}}
