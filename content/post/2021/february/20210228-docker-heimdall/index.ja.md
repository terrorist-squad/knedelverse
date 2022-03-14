+++
date = "2021-02-28"
title = "コンテナを使った素敵なこと：Heimdallをホームページに"
difficulty = "level-3"
tags = ["dienste", "Docker", "docker-compose", "docker-for-desktop", "heimdall", "homepage", "startseite"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/february/20210228-docker-heimdall/index.ja.md"
+++
ホームラボのネットワークでは、LDAP、Gitlab、Atlassian Bamboo、Atlassian Confluence、Atlassian Jira、Jenkins、WordPress、Grafana、Graylog、ESXI/VMware、Calibreなど、多くのサービスを運用しています。すべてを見失ってしまうこともあります。
{{< gallery match="images/1/*.jpg" >}}

## ステップ1：作業フォルダの作成
このコマンドを使用して、一時的な作業フォルダを作成します。
{{< terminal >}}
mkdir /tmp/bilder

{{</ terminal >}}
Heimdallは、Dashboardでブックマークを管理できるサービスです。私はDocker for Desktopを使用しているので、このDocker Composeファイルをローカルフォルダに置くだけでいいのです。
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
このファイルはDocker Composeで起動します。
{{< terminal >}}
ocker-compose -f compose-file.yml up -d

{{</ terminal >}}

{{< gallery match="images/2/*.png" >}}
