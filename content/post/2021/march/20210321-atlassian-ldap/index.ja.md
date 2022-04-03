+++
date = "2021-03-24"
title = "アトラシアンでのクールな使い方: LDAP ですべてのアトラシアンツールを使用する"
difficulty = "level-3"
tags = ["atlassian", "bamboo", "jira", "ldap", "openldap", "linux", "test"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/march/20210321-atlassian-ldap/index.ja.md"
+++
Atlassianのインストールを自分で行っている人はラッキーです。今日は、Jira、Bamboo、Confluence を LDAP サーバーに接続する方法を紹介します。
## ステップ1：OpenLDAPのインストール
このDocker ComposeファイルでOpenLDAPをSynologyのNASにセットアップしました。
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

## ステップ2：OpenLDAPのセットアップ
LDAPサーバーに、さまざまなツールのグループを作成しました。
{{< gallery match="images/1/*.png" >}}

## ステップ 3: Atlassian ツールの接続
設定は、すべてのアトラシアンツールで同じです。LDAPサーバーのIPアドレスとポートを入力しています。
{{< gallery match="images/2/*.png" >}}
LDAPスキーム」は「Basic DN」のみを入力しました。自己署名証明書の場合は、「セキュアSSL」オプションをオフにする必要があります。
{{< gallery match="images/3/*.png" >}}

## 自己署名証明書のその他の特徴
自己署名証明書を使っているので、トラストストアに入るのは
```
-Dcom.sun.jndi.ldap.object.disableEndpointIdentification=true -Djdk.tls.trustNameService=true -Dcom.sun.jndi.ldap.object.disableEndpointIdentification -Djavax.net.ssl.trustStore=/store/keystore.jks -Djavax.net.ssl.trustStorePassword=password

```
ご覧ください。
{{< gallery match="images/4/*.png" >}}

## ステップ4：ユーザーとグループのスキーム
私は以下のユーザーとグループの設定を取りました。最も重要なのは、「グループオブジェクトフィルター」の設定です。もちろん、Bamboo、Confluence、Jiraでは異なります。
{{< gallery match="images/5/*.png" >}}
