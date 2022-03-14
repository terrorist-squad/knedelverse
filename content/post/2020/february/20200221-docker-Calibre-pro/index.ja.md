+++
date = "2020-02-21"
title = "コンテナの優れた点：Docker ComposeでCalibreを実行する（Synology proのセットアップ）"
difficulty = "level-3"
tags = ["calibre", "calibre-web", "Docker", "docker-compose", "Synology", "linux"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2020/february/20200221-docker-Calibre-pro/index.ja.md"
+++
このブログには、すでにもっと簡単なチュートリアルがあります： [Synology-Nas：電子書籍ライブラリとしてのCalibre Webのインストール]({{< ref "post/2020/february/20200213-synology-calibreweb" >}} "Synology-Nas：電子書籍ライブラリとしてのCalibre Webのインストール").このチュートリアルは、すべての Synology DS プロフェッショナルのためのものです。
## ステップ1：Synologyの準備
まず、DiskStationでSSHログインを有効にする必要があります。そのためには、「コントロールパネル」→「ターミナル」で
{{< gallery match="images/1/*.png" >}}
そして、「SSH」で指定されたポートと管理者パスワードでログインします（WindowsユーザーはPuttyまたはWinSCPを使用）。
{{< gallery match="images/2/*.png" >}}
Terminal、winSCP、Puttyなどでログインして、このコンソールを後から開くようにしています。
## Step 2: ブックフォルダの作成
Calibreのライブラリ用に新しいフォルダを作ります。そのためには、「システムコントロール」→「共有フォルダ」を呼び出して、「Books」という新しいフォルダを作ります。もし「Docker」フォルダがない場合は、これも作成する必要があります。
{{< gallery match="images/3/*.png" >}}

## ステップ3：ブックフォルダの準備
ここで、次のファイルをダウンロードして解凍する必要があります。https://drive.google.com/file/d/1zfeU7Jh3FO_jFlWSuZcZQfQOGD0NvXBm/view。コンテンツ（"metadata.db"）は、新しいブックディレクトリに配置する必要があります、参照。
{{< gallery match="images/4/*.png" >}}

## ステップ4：Dockerフォルダの準備
Dockerのディレクトリに「calibre」という新しいディレクトリを作ります。
{{< gallery match="images/5/*.png" >}}
そして、新しいディレクトリに移動し、以下の内容の「calibre.yml」というファイルを新たに作成します。
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
PUID/PGID：PUID/PGIDには、DSユーザーのユーザーIDとグループIDを入力する必要があります。ここでは、「ステップ1」のコンソールと「id -u」のコマンドを使って、ユーザーIDを確認します。id -g "コマンドでグループIDを取得します。* ports: ポートについては、前段の "8055: "を調整する必要があります。 directoriesこのファイル内のすべてのディレクトリを修正する必要があります。正しいアドレスは、DSのプロパティウィンドウで確認できます。(以下、スクリーンショット）
{{< gallery match="images/6/*.png" >}}

## ステップ5：テスト開始
また、このステップでは、コンソールをうまく利用することができます。Calibreディレクトリに移動し、そこにあるCalibreサーバーをDocker Compose経由で起動します。
{{< terminal >}}
cd /volume1/docker/calibre
sudo docker-compose -f calibre.yml up -d

{{</ terminal >}}

{{< gallery match="images/7/*.png" >}}

## ステップ6：セットアップ
そして、ディスクステーションのIPと「ステップ4」で割り当てられたポートを使って、私のCalibreサーバーを呼び出すことができます。私はセットアップで「/books」のマウントポイントを使用しています。その後、サーバーはすでに使用可能な状態になっています。
{{< gallery match="images/8/*.png" >}}

## Step 7: セットアップの最終確認
また、このステップではコンソールが必要です。私は「exec」というコマンドを使って、コンテナ内のアプリケーションデータベースを保存しています。
{{< terminal >}}
sudo docker exec -it calibre-web-server cp /app/calibre-web/app.db /briefkaste/app.db

{{</ terminal >}}
その後、Calibreのディレクトリに新しい「app.db」ファイルができました。
{{< gallery match="images/9/*.png" >}}
その後、Calibreサーバーを停止します。
{{< terminal >}}
sudo docker-compose -f calibre.yml down

{{</ terminal >}}
ここでレターボックスのパスを変更し、アプリケーションデータベースをその上に永続化します。
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