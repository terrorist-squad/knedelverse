+++
date = "2021-03-24"
title = "Cool stuff with Atlassian: Use all Atlassian tools with LDAP"
difficulty = "level-3"
tags = ["atlassian", "bamboo", "jira", "ldap", "openldap", "linux", "test"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/march/20210321-atlassian-ldap/index.en.md"
+++
You can consider yourself lucky if you have your own Atlassian installation. Today I show how I connected Jira, Bamboo and Confluence to my LDAP server.
## Step 1: Install OpenLDAP
I have OpenLDAP set up on my Synology NAS using this Docker compose file.
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

## Step 2: Set up OpenLDAP
In the LDAP server I have created groups for the different tools.
{{< gallery match="images/1/*.png" >}}

## Step 3: Connect Atlassian tools
The setup is the same for all Atlassian tools. I specify the IP address and port of my LDAP server.
{{< gallery match="images/2/*.png" >}}
For the "LDAP Scheme" I have only entered the "Base DN". For self-signed certificates, the "Secure SSL" option must be deactivated.
{{< gallery match="images/3/*.png" >}}

## Other special features of self-signed certificates
Since I use a self-signed certificate, I specify my truststore with
```
-Dcom.sun.jndi.ldap.object.disableEndpointIdentification=true -Djdk.tls.trustNameService=true -Dcom.sun.jndi.ldap.object.disableEndpointIdentification -Djavax.net.ssl.trustStore=/store/keystore.jks -Djavax.net.ssl.trustStorePassword=password

```
See:
{{< gallery match="images/4/*.png" >}}

## Step 4: User and group scheme
I have taken the following user and group settings. The most important is the "group object filter" setting. This is of course different for Bamboo, Confluence and Jira.
{{< gallery match="images/5/*.png" >}}
