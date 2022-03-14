+++
date = "2021-03-24"
title = "Cooles avec Atlassian : utiliser tous les outils Atlassian avec LDAP"
difficulty = "level-3"
tags = ["atlassian", "bamboo", "jira", "ldap", "openldap", "linux", "test"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/march/20210321-atlassian-ldap/index.fr.md"
+++
On peut s'estimer heureux si l'on possède sa propre installation Atlassian. Aujourd'hui, je montre comment j'ai connecté Jira, Bamboo et Confluence à mon serveur LDAP.
## Étape 1 : Installer OpenLDAP
J'ai installé OpenLDAP sur mon NAS Synology à l'aide de ce fichier composite Docker.
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

## Étape 2 : Configurer OpenLDAP
Dans le serveur LDAP, j'ai créé des groupes pour les différents outils.
{{< gallery match="images/1/*.png" >}}

## Étape 3 : Connecter les outils Atlassian
La configuration est la même pour tous les outils Atlassian. J'indique l'adresse IP et le port de mon serveur LDAP.
{{< gallery match="images/2/*.png" >}}
Pour le "schéma LDAP", je n'ai inscrit que le "DN de base". Pour les certificats auto-signés, l'option "Secure SSL" doit être désactivée.
{{< gallery match="images/3/*.png" >}}

## Autres particularités des certificats auto-signés
Comme j'utilise un certificat auto-signé, je spécifie mon truststore avec
```
-Dcom.sun.jndi.ldap.object.disableEndpointIdentification=true -Djdk.tls.trustNameService=true -Dcom.sun.jndi.ldap.object.disableEndpointIdentification -Djavax.net.ssl.trustStore=/store/keystore.jks -Djavax.net.ssl.trustStorePassword=password

```
Voir
{{< gallery match="images/4/*.png" >}}

## Étape 4 : Schéma d'utilisateurs et de groupes
J'ai pris les paramètres d'utilisateur et de groupe suivants. Le plus important est le paramètre "filtre d'objet de groupe". Celui-ci est bien sûr différent pour Bamboo, Confluence et Jira.
{{< gallery match="images/5/*.png" >}}