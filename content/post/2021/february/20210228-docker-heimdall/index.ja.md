+++
date = "2021-02-28"
title = "コンテナで素敵なこと：ホームページとしてのヘイムダル"
difficulty = "level-3"
tags = ["dienste", "Docker", "docker-compose", "docker-for-desktop", "heimdall", "homepage", "startseite"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/february/20210228-docker-heimdall/index.ja.md"
+++
例えば、LDAP, Gitlab, Atlassian Bamboo, Atlassian Confluence, Atlassian Jira, Jenkins, WordPress, Grafana, Graylog, ESXI/VMware, Calibre など、多くのサービスを私のホームラボネットワークで動かしているのです。何もかもがわからなくなりがちです。
{{< gallery match="images/1/*.jpg" >}}

## ステップ1：作業用フォルダの作成
このコマンドは、一時的な作業フォルダを作成するために使用します。
{{< terminal >}}
mkdir /tmp/bilder

{{</ terminal >}}
Heimdallは、Dashboardでブックマークを管理できるサービスです。私はDocker for Desktopを使っているので、このDocker Composeファイルをローカルフォルダに置くだけでいいのです。
```
version: "2.1"
services:
  heimdall:
    image: linuxserver/heimdall
    container_name: heimdall
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=Europe/Berlin
    volumes:
      - /Users/christianknedel/docker/heimdall/config:/config
    ports:
      - 80:80
      - 443:443
    restart: always

```
このファイルはDocker Compose経由で起動します。
{{< terminal >}}
ocker-compose -f compose-file.yml up -d

{{</ terminal >}}

{{< gallery match="images/2/*.png" >}}

