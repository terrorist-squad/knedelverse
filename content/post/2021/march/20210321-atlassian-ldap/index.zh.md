+++
date = "2021-03-24"
title = "阿特拉斯公司的酷事：用LDAP使用所有阿特拉斯工具"
difficulty = "level-3"
tags = ["atlassian", "bamboo", "jira", "ldap", "openldap", "linux", "test"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/march/20210321-atlassian-ldap/index.zh.md"
+++
如果你有自己的Atlassian安装，你是幸运的。今天我展示了我如何将Jira、Bamboo和Confluence连接到我的LDAP服务器。
## 第1步：安装OpenLDAP
我已经在我的Synology NAS上用这个Docker Compose文件设置了OpenLDAP。
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

## 第2步：设置OpenLDAP
在LDAP服务器中，我已经为不同的工具创建了组。
{{< gallery match="images/1/*.png" >}}

## 第3步：连接Atlassian工具
所有Atlassian工具的设置都是一样的。我输入我的LDAP服务器的IP地址和端口。
{{< gallery match="images/2/*.png" >}}
对于 "LDAP方案"，我只输入了 "基本DN"。对于自签的证书，"安全SSL "选项必须被停用。
{{< gallery match="images/3/*.png" >}}

## 自签名证书的其他特殊功能
由于我使用的是自签名的证书，所以我在进入我的truststore时使用了
```
-Dcom.sun.jndi.ldap.object.disableEndpointIdentification=true -Djdk.tls.trustNameService=true -Dcom.sun.jndi.ldap.object.disableEndpointIdentification -Djavax.net.ssl.trustStore=/store/keystore.jks -Djavax.net.ssl.trustStorePassword=password

```
见。
{{< gallery match="images/4/*.png" >}}

## 第4步：用户和组计划
我采取了以下用户和组的设置。最重要的是 "分组对象过滤器 "的设置。当然，这对于Bamboo、Confluence和Jira是不同的。
{{< gallery match="images/5/*.png" >}}