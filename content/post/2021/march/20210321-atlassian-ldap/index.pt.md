+++
date = "2021-03-24"
title = "Coisas legais com Atlassian: Use todas as ferramentas Atlassian com LDAP"
difficulty = "level-3"
tags = ["atlassian", "bamboo", "jira", "ldap", "openldap", "linux", "test"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/march/20210321-atlassian-ldap/index.pt.md"
+++
Terá sorte se tiver a sua própria instalação Atlassian. Hoje eu mostro como eu conectei Jira, Bamboo e Confluence ao meu servidor LDAP.
## Passo 1: Instalar o OpenLDAP
Eu configurei o OpenLDAP com este arquivo Docker Compose no meu Synology NAS.
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

## Passo 2: Preparar o OpenLDAP
No servidor LDAP criei grupos para as diferentes ferramentas.
{{< gallery match="images/1/*.png" >}}

## Passo 3: Conecte as ferramentas Atlassian
A configuração é a mesma para todas as ferramentas Atlassian. Eu digito o endereço IP e a porta do meu servidor LDAP.
{{< gallery match="images/2/*.png" >}}
Para o "esquema LDAP", eu só introduzi o "DN Básico". Para certificados autoassinados, a opção "Secure SSL" deve ser desativada.
{{< gallery match="images/3/*.png" >}}

## Outras características especiais dos certificados autoassinados
Como eu uso um certificado autoassinado, eu entro na minha loja de confiança com
```
-Dcom.sun.jndi.ldap.object.disableEndpointIdentification=true -Djdk.tls.trustNameService=true -Dcom.sun.jndi.ldap.object.disableEndpointIdentification -Djavax.net.ssl.trustStore=/store/keystore.jks -Djavax.net.ssl.trustStorePassword=password

```
Veja:
{{< gallery match="images/4/*.png" >}}

## Passo 4: Esquema do usuário e do grupo
Eu tomei as seguintes configurações de usuário e grupo. O mais importante é a configuração do "filtro de objetos de grupo". Claro, isto é diferente para Bambu, Confluência e Jira.
{{< gallery match="images/5/*.png" >}}
