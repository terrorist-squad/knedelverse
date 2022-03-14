+++
date = "2021-03-24"
title = "アトラシアンの優れた点: アトラシアンのすべてのツールをLDAPで使用することができます。"
difficulty = "level-3"
tags = ["atlassian", "bamboo", "jira", "ldap", "openldap", "linux", "test"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/march/20210321-atlassian-ldap/index.ja.md"
+++
自分でAtlassianをインストールしている人はラッキーです。今日は、Jira、Bamboo、ConfluenceをLDAPサーバーに接続する方法を紹介します。
## ステップ1：OpenLDAPのインストール
このDocker Composeファイルを使って、Synology NASにOpenLDAPをセットアップしました。
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

## ステップ2：OpenLDAPの設定
LDAPサーバーでは、異なるツールのためのグループを作成しました。
{{< gallery match="images/1/*.png" >}}

## ステップ3：アトラシアンツールの接続
設定方法は、すべてのアトラシアンツールで同じです。私は、LDAPサーバーのIPアドレスとポートを入力します。
{{< gallery match="images/2/*.png" >}}
LDAPスキーム」では、「基本DN」のみを入力しています。自己署名証明書の場合は、「Secure SSL」のオプションを無効にする必要があります。
{{< gallery match="images/3/*.png" >}}

## 自己署名証明書のその他の特徴
自己署名証明書を使用しているので、トラストストアの入力には
```
-Dcom.sun.jndi.ldap.object.disableEndpointIdentification=true -Djdk.tls.trustNameService=true -Dcom.sun.jndi.ldap.object.disableEndpointIdentification -Djavax.net.ssl.trustStore=/store/keystore.jks -Djavax.net.ssl.trustStorePassword=password

```
見てください。
{{< gallery match="images/4/*.png" >}}

## ステップ4：ユーザーとグループのスキーム
以下のようなユーザーとグループの設定を取っています。最も重要なのは、「グループオブジェクトフィルタ」の設定です。もちろん、Bamboo、Confluence、Jiraでは異なります。
{{< gallery match="images/5/*.png" >}}