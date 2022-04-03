+++
date = "2020-02-21"
title = "コンテナで素晴らしいことを: Docker Compose で Calibre を実行する (Synology pro のセットアップ)"
difficulty = "level-3"
tags = ["calibre", "calibre-web", "Docker", "docker-compose", "Synology", "linux"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2020/february/20200221-docker-Calibre-pro/index.ja.md"
+++
このブログには、すでにもっと簡単なチュートリアルがあります：[Synology-Nas：Calibre Webを電子書籍ライブラリーとしてインストールする。]({{< ref "post/2020/february/20200213-synology-calibreweb" >}} "Synology-Nas：Calibre Webを電子書籍ライブラリーとしてインストールする。").このチュートリアルは、すべての Synology DS プロフェッショナルのためのものです。
## ステップ1：Synologyを準備する
まず、DiskStationでSSHログインを有効にする必要があります。そのためには、「コントロールパネル」→「ターミナル」を開きます。
{{< gallery match="images/1/*.png" >}}
そして、「SSH」、指定されたポート、管理者パスワードでログインします（WindowsユーザーはPuttyまたはWinSCPを使用します）。
{{< gallery match="images/2/*.png" >}}
ターミナル、winSCP、Puttyでログインして、このコンソールを開いたままにしておくと、後で便利です。
## ステップ2：ブックフォルダを作成する
キャリバーライブラリ用の新しいフォルダを作成します。そのために、「システムコントロール」→「共有フォルダ」を呼び出し、「Books」というフォルダを新規に作成します。Docker」フォルダがまだない場合は、このフォルダも作成する必要があります。
{{< gallery match="images/3/*.png" >}}

## ステップ3：ブックフォルダを用意する
ここで、以下のファイルをダウンロードし、解凍する必要があります。https://drive.google.com/file/d/1zfeU7Jh3FO_jFlWSuZcZQfQOGD0NvXBm/view。コンテンツ（"metadata.db"）は、新しいブックディレクトリに置く必要があります、参照。
{{< gallery match="images/4/*.png" >}}

## ステップ4：Dockerフォルダの準備
Dockerのディレクトリに「calibre」というディレクトリを新規に作成します。
{{< gallery match="images/5/*.png" >}}
そして、新しいディレクトリに移動して、「calibre.yml」というファイルを以下の内容で新規作成します。
```
version: '2'
services:
  calibre-web:
    image: linuxserver/calibre-web
    container_name: calibre-web-server
    environment:
      - PUID=1026
      - PGID=100
      - TZ=Europe/Berlin
    volumes:
      - /volume1/Buecher:/books
      - /volume1/docker/calibre:/briefkaste
    ports:
      - 8055:8083
    restart: unless-stopped

```
PUID/PGID: PUID/PGIDには、DSユーザーのユーザーIDおよびグループIDを入力する必要があります。ここでは、「手順1」のコンソールを使って、「id -u」コマンドでユーザーIDを確認しています。id -g "コマンドでグループIDを取得します。* ports: ポートは、先頭の "8055: "の部分を調整する必要があります。directoriesこのファイル内のすべてのディレクトリを修正する必要があります。正しいアドレスは、DSのプロパティウィンドウで確認することができます。(画面はイメージです)
{{< gallery match="images/6/*.png" >}}

## ステップ5：テスト開始
このステップでは、コンソールもうまく活用できるんだ。Calibreディレクトリに移動して、そこでDocker Compose経由でCalibreサーバを起動します。
{{< terminal >}}
cd /volume1/docker/calibre
sudo docker-compose -f calibre.yml up -d

{{</ terminal >}}

{{< gallery match="images/7/*.png" >}}

## ステップ6：セットアップ
そして、ディスクステーションのIPと「ステップ4」で割り当てたポートで、Calibreサーバーを呼び出すことができます。セットアップでは、私の「/books」マウントポイントを使用しています。その後、サーバーはすでに使用可能な状態になっています。
{{< gallery match="images/8/*.png" >}}

## ステップ7：セットアップの最終確認
このステップでは、コンソールも必要です。コンテナ内部のアプリケーションデータベースを保存するのに、execというコマンドを使っています。
{{< terminal >}}
sudo docker exec -it calibre-web-server cp /app/calibre-web/app.db /briefkaste/app.db

{{</ terminal >}}
その後、キャリバーディレクトリに新しい "app.db "ファイルが表示されます。
{{< gallery match="images/9/*.png" >}}
その後、Calibreサーバーを停止しています。
{{< terminal >}}
sudo docker-compose -f calibre.yml down

{{</ terminal >}}
ここで、レターボックスのパスを変更し、その上にアプリケーションデータベースを永続化します。
```
version: '2'
services:
  calibre-web:
    image: linuxserver/calibre-web
    container_name: calibre-web-server
    environment:
      - PUID=1026
      - PGID=100
      - TZ=Europe/Berlin
    volumes:
      - /volume1/Buecher:/books
      - /volume1/docker/calibre/app.db:/app/calibre-web/app.db
    ports:
      - 8055:8083
    restart: unless-stopped

```
その後、サーバーを再起動することができます。
{{< terminal >}}
sudo docker-compose -f calibre.yml up -d

{{</ terminal >}}
