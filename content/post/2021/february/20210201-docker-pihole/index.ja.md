+++
date = "2021-02-01"
title = "コンテナですごいこと: Pihole on Synology Diskstation"
difficulty = "level-3"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "dns", "adblocker", "fritzbox"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/february/20210201-docker-pihole/index.ja.md"
+++
今日は、Synology disk stationにPiholeサービスをインストールし、Fritzboxに接続する方法を紹介します。
## ステップ1：Synologyを準備する
まず、DiskStationでSSHログインを有効にする必要があります。そのためには、「コントロールパネル」→「ターミナル」を開きます。
{{< gallery match="images/1/*.png" >}}
そして、「SSH」、指定されたポート、管理者パスワードでログインします（WindowsユーザーはPuttyまたはWinSCPを使用します）。
{{< gallery match="images/2/*.png" >}}
ターミナル、winSCP、Puttyでログインして、このコンソールを開いたままにしておくと、後で便利です。
## ステップ2：Piholeフォルダの作成
Dockerディレクトリの中に「pihole」というディレクトリを新規に作成します。
{{< gallery match="images/3/*.png" >}}
そして、新しいディレクトリに移動し、「etc-pihole」と「etc-dnsmasq.d」の2つのフォルダを作成します。
{{< terminal >}}
cd /volume1/docker/
mkdir -p {etc-pihole,etc-dnsmasq.d}

{{</ terminal >}}
ここで、以下のDocker Composeファイル「pihole.yml」をPiholeディレクトリに配置する必要があります。
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
これで、コンテナの起動が可能になりました。
{{< terminal >}}
sudo docker-compose up -d

{{</ terminal >}}
SynologyのIPアドレスと自分のコンテナポートでPiholeサーバーを呼び出し、WEBPASSWORDのパスワードでログインしています。
{{< gallery match="images/4/*.png" >}}
これで、Fritzboxの「ホームネットワーク」→「ネットワーク」→「ネットワーク設定」でDNSアドレスを変更できるようになりました。
{{< gallery match="images/5/*.png" >}}
