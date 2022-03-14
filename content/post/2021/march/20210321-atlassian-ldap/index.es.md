+++
date = "2021-03-24"
title = "Cosas geniales con Atlassian: Utilizar todas las herramientas de Atlassian con LDAP"
difficulty = "level-3"
tags = ["atlassian", "bamboo", "jira", "ldap", "openldap", "linux", "test"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/march/20210321-atlassian-ldap/index.es.md"
+++
Tienes suerte si tienes tu propia instalación de Atlassian. Hoy muestro cómo he conectado Jira, Bamboo y Confluence a mi servidor LDAP.
## Paso 1: Instalar OpenLDAP
He configurado OpenLDAP con este archivo Docker Compose en mi NAS de Synology.
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

## Paso 2: Configurar OpenLDAP
En el servidor LDAP he creado grupos para las diferentes herramientas.
{{< gallery match="images/1/*.png" >}}

## Paso 3: Conectar las herramientas de Atlassian
La configuración es la misma para todas las herramientas de Atlassian. Introduzco la dirección IP y el puerto de mi servidor LDAP.
{{< gallery match="images/2/*.png" >}}
Para el "esquema LDAP", sólo he introducido el "DN básico". Para los certificados autofirmados, la opción "SSL seguro" debe estar desactivada.
{{< gallery match="images/3/*.png" >}}

## Otras características especiales de los certificados autofirmados
Como utilizo un certificado autofirmado, introduzco mi trusttore con
```
-Dcom.sun.jndi.ldap.object.disableEndpointIdentification=true -Djdk.tls.trustNameService=true -Dcom.sun.jndi.ldap.object.disableEndpointIdentification -Djavax.net.ssl.trustStore=/store/keystore.jks -Djavax.net.ssl.trustStorePassword=password

```
Ver:
{{< gallery match="images/4/*.png" >}}

## Paso 4: Esquema de usuarios y grupos
He tomado las siguientes configuraciones de usuario y grupo. Lo más importante es la configuración del "filtro de objetos de grupo". Por supuesto, esto es diferente para Bamboo, Confluence y Jira.
{{< gallery match="images/5/*.png" >}}