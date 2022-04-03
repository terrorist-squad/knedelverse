+++
date = "2021-04-02"
title = "コンテナですごいこと：LDAPとNGINXでDockerサービスをよりセキュアにする"
difficulty = "level-1"
tags = ["calibre", "calibre-web", "ldap", "logging", "nutzerverwaltung", "peertube", "ssl"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210402-nginx-reverse-proxy/index.ja.md"
+++
Synology Diskstation ユーザーとして、私はホームラボのネットワークで多くのサービスを実行しています。Gitlabでソフトウェアをデプロイし、Confluenceで知識を文書化し、Calibreウェブサーバーで技術文献を読んでいます。
{{< gallery match="images/1/*.png" >}}
すべてのネットワークサービスは暗号化されて通信し、中央のユーザー管理によって保護されています。 今日は、SSL暗号化、アクセスログ、LDAPアクセス制限によって私のCalibreサービスを保護する方法を紹介します。このチュートリアルでは、"[アトラシアンでのクールな使い方: LDAP ですべてのアトラシアンツールを使用する]({{< ref "post/2021/march/20210321-atlassian-ldap" >}} "アトラシアンでのクールな使い方: LDAP ですべてのアトラシアンツールを使用する") "と "[コンテナで素晴らしいことを: Docker ComposeでCalibreを実行する]({{< ref "post/2020/february/20200221-docker-Calibre-pro" >}} "コンテナで素晴らしいことを: Docker ComposeでCalibreを実行する") "からの予備知識が必要です。
## 私のLDAPサーバー
すでに書いたように、私はDockerコンテナで中央のopenLDAPサーバーを動かしています。また、いくつかのアプリケーショングループを作成しました。
{{< gallery match="images/2/*.png" >}}

## リバースプロキシで安全でないアプリケーションを保護
linuxserver/calibre-web」のDockerイメージはSSL暗号化とLDAPをサポートしていないので、「calibreweb」という仮想ネットワークを作り、NGINXリバースプロクシをCalibreサーバの前に置く。 Docker Composeファイルはこんな感じです。今後のアクセスログはすべてlogディレクトリに、自己署名証明書はcertsディレクトリに保存されます。
```
version: '3.7'
services:
  nginx: 
    image:  weseek/nginx-auth-ldap:1.13.9-1-alpine
    container_name: calibre-nginx
    environment:
    - 'TZ=Europe/Berlin'
    volumes:
      - ./default.conf:/etc/nginx/conf.d/default.conf
      - ./certs:/etc/certs
      - ./logs:/var/log/nginx
    ports:
      - 8443:443
    networks:
      - calibreweb
    restart: unless-stopped

  calibre-web:
    image: linuxserver/calibre-web
    container_name: calibre-web
    environment:
      - PUID=.....
      - PGID=....
      - TZ=Europe/Berlin
    volumes:
      - /volume/docker/calibre/app.db:/app/calibre-web/app.db
      - /volume/Buecher:/books
    expose:
      - 8083
    restart: unless-stopped
    networks:
      - calibreweb

networks:
  calibreweb:

```
家庭で使える便利なDockerイメージは、[ドッカーバース]({{< ref "dockerverse" >}} "ドッカーバース").Dockerにあります。
## Nginxの設定
default.conf」ファイルには、すべてのLDAPと暗号化の設定が含まれています。もちろん、URL、binddn、証明書、ポート、パスワードやグループも調整する必要があります。
```
# ldap auth configuration
auth_ldap_cache_enabled on;
auth_ldap_cache_expiration_time 10000;
auth_ldap_cache_size 1000;
ldap_server ldap1 {
    url ldaps://ldap.server.local:636/dc=homelab,dc=local?uid?sub?(&(objectClass=inetorgperson));

    binddn "cn=root oder so,dc=homelab,dc=local";
    binddn_passwd "password";
    connect_timeout 5s;
    bind_timeout 5s;
    request_timeout 5s;
    ssl_check_cert: off;
    group_attribute memberUid;
    group_attribute_is_dn off;
    require group "cn=APP-Bibliothek,ou=Groups,dc=homelab,dc=local";
    require valid_user;
}

server {
    listen              443 ssl;
    server_name  localhost;

    ssl_certificate /etc/certs/fullchain.pem;
    ssl_certificate_key /etc/certs/privkey.pem;
    #weitere SSL-Einstellungen

    location / {
        auth_ldap "LDAP-ONLY";
        auth_ldap_servers ldap1;

        proxy_set_header        Host            $http_host;
        proxy_set_header        X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header        X-Scheme        $scheme;
        proxy_pass  http://calibre-web:8083; #<- docker expose port
    }
}


```
ここで「docker-compose -f ...etc... up」で設定を開始すると、アクセスログでログインしたユーザーのアクセスも確認できる。
{{< gallery match="images/3/*.png" >}}
LDAPユーザーはあくまでゲストユーザーなので、キャリバーウェブでゲストユーザー権限を設定する必要があります。
{{< gallery match="images/4/*.png" >}}
私はこの設定を以下のサービスに対して行っています：* ビデオライブラリー (Peertube)* ライブラリー (Calibreweb)* Gitlab (CE はグループをサポートしていないので、2回ログインする必要があります)。
