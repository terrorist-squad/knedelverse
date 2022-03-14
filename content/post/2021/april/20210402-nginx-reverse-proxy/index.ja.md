+++
date = "2021-04-02"
title = "コンテナの優れた点：LDAPとNGINXでDockerサービスの安全性を高める"
difficulty = "level-1"
tags = ["calibre", "calibre-web", "ldap", "logging", "nutzerverwaltung", "peertube", "ssl"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/april/20210402-nginx-reverse-proxy/index.ja.md"
+++
Synology Diskstation のユーザーとして、私はホームラボのネットワークで多くのサービスを実行しています。Gitlabでソフトウェアをデプロイし、Confluenceで知識を文書化し、ウェブサーバーのCalibreで技術文献を読んでいます。
{{< gallery match="images/1/*.png" >}}
すべてのネットワークサービスは、暗号化された通信を行い、中央のユーザー管理によって保護されています。 今日は、SSL暗号化、アクセスログ、LDAPアクセス制限を用いて、Calibreサービスを保護した方法を紹介します。このチュートリアルでは、"[アトラシアンの優れた点: アトラシアンのすべてのツールをLDAPで使用することができます。]({{< ref "post/2021/march/20210321-atlassian-ldap" >}} "アトラシアンの優れた点: アトラシアンのすべてのツールをLDAPで使用することができます。") "と "[コンテナで実現すること：Docker ComposeでCalibreを動かす]({{< ref "post/2020/february/20200221-docker-Calibre-pro" >}} "コンテナで実現すること：Docker ComposeでCalibreを動かす") "の予備知識が必要です。
## 私のLDAPサーバー
すでに書いたように、私はDockerコンテナの中で中央のopenLDAPサーバーを動かしています。また、いくつかのアプリケーショングループを作成しました。
{{< gallery match="images/2/*.png" >}}

## リバースプロキシを使って安全でないアプリケーションを保護する
linuxserver/calibre-web」のDockerイメージはSSL暗号化とLDAPをサポートしていないので、「calibreweb」という仮想ネットワークを作成し、Calibreサーバの前にNGINXリバースプロキシを配置します。 これが私のDocker Composeファイルの内容です。今後のアクセスログはすべてlogディレクトリに保存され、自己署名証明書はcertsディレクトリにあります。
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
家庭での使用に便利なDockerイメージは、[Dockerverse]({{< ref "dockerverse" >}} "Dockerverse")にもあります。
## Nginxの設定
default.conf "ファイルには、すべてのLDAPと暗号化の設定が含まれています。もちろん、URL、binddn、証明書、ポート、パスワードやグループの調整も必要です。
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
これで「docker-compose -f ...etc... up」でセットアップを開始すると、ログインしたユーザーのアクセスもアクセスログで確認できます。
{{< gallery match="images/3/*.png" >}}
LDAPユーザーはあくまでもゲストユーザーなので、ゲストユーザーの権限をCalibrewebで設定する必要があります。
{{< gallery match="images/4/*.png" >}}
