+++
date = "2021-02-01"
title = "コンテナで素晴らしいことを：Synology DiskStationのPihole"
difficulty = "level-3"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "dns", "adblocker", "fritzbox"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/february/20210201-docker-pihole/index.ja.md"
+++
今日は、SynologyのディスクステーションにPiholeサービスをインストールして、Fritzboxに接続する方法を紹介します。
## ステップ1：Synologyの準備
まず、DiskStationでSSHログインを有効にする必要があります。そのためには、「コントロールパネル」→「ターミナル」で
{{< gallery match="images/1/*.png" >}}
そして、「SSH」で指定されたポートと管理者パスワードでログインします（WindowsユーザーはPuttyまたはWinSCPを使用）。
{{< gallery match="images/2/*.png" >}}
Terminal、winSCP、Puttyなどでログインして、このコンソールを後から開くようにしています。
## ステップ2：Piholeフォルダの作成
Dockerのディレクトリに「pihole」という新しいディレクトリを作ります。
{{< gallery match="images/3/*.png" >}}
そして、新しいディレクトリに移動し、「etc-pihole」と「etc-dnsmasq.d」という2つのフォルダを作成します。
{{< terminal >}}
cd /volume1/docker/
mkdir -p {etc-pihole,etc-dnsmasq.d}

{{</ terminal >}}
ここで、「pihole.yml」という名前の以下のDocker Composeファイルを、Piholeディレクトリに配置する必要があります。
```
version: "3"

services:
  pihole:
    container_name: pihole
    image: pihole/pihole:latest
    ports:
      - "53:53/tcp"
      - "53:53/udp"
      - "67:67/udp"
      - "8080:80/tcp"
    environment:
      TZ: 'Europe/Berlin'
      WEBPASSWORD: 'password'
    volumes:
      - './etc-pihole/:/etc/pihole/'
      - './etc-dnsmasq.d/:/etc/dnsmasq.d/'
    cap_add:
      - NET_ADMIN
    restart: unless-stopped

```
これで、コンテナが起動できるようになりました。
{{< terminal >}}
sudo docker-compose up -d

{{</ terminal >}}
SynologyのIPアドレスと私のコンテナポートでPiholeサーバーを呼び出し、WEBPASSWORDのパスワードでログインします。
{{< gallery match="images/4/*.png" >}}
これで、フリッツボックスの「ホームネットワーク」>「ネットワーク」>「ネットワーク設定」でDNSアドレスを変更できるようになりました。
{{< gallery match="images/5/*.png" >}}