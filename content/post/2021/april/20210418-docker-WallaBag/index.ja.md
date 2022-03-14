+++
date = "2021-04-18"
title = "コンテナを利用した優れた点：SynologyのディスクステーションにWallaBagを搭載する"
difficulty = "level-1"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "archiv", "wallabag"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210418-docker-WallaBag/index.ja.md"
+++
Wallabagは、興味深いウェブサイトや記事をアーカイブするためのプログラムです。今日は、SynologyのディスクステーションにWallabagサービスをインストールする方法を紹介します。
## プロフェッショナルのためのオプション
経験豊富なSynologyユーザーであれば、もちろんSSHでログインし、Docker Composeファイルでセットアップ全体をインストールすることができます。
```
version: '3'
services:
  wallabag:
    image: wallabag/wallabag
    environment:
      - MYSQL_ROOT_PASSWORD=wallaroot
      - SYMFONY__ENV__DATABASE_DRIVER=pdo_mysql
      - SYMFONY__ENV__DATABASE_HOST=db
      - SYMFONY__ENV__DATABASE_PORT=3306
      - SYMFONY__ENV__DATABASE_NAME=wallabag
      - SYMFONY__ENV__DATABASE_USER=wallabag
      - SYMFONY__ENV__DATABASE_PASSWORD=wallapass
      - SYMFONY__ENV__DATABASE_CHARSET=utf8mb4
      - SYMFONY__ENV__DOMAIN_NAME=http://192.168.178.50:8089
      - SYMFONY__ENV__SERVER_NAME="Your wallabag instance"
      - SYMFONY__ENV__FOSUSER_CONFIRMATION=false
      - SYMFONY__ENV__TWOFACTOR_AUTH=false
    ports:
      - "8089:80"
    volumes:
      - ./wallabag/images:/var/www/wallabag/web/assets/images

  db:
    image: mariadb
    environment:
      - MYSQL_ROOT_PASSWORD=wallaroot
    volumes:
      - ./mariadb:/var/lib/mysql

```
家庭での使用に便利なDockerイメージは、[Dockerverse]({{< ref "dockerverse" >}} "Dockerverse")にもあります。
## ステップ1：wallabagフォルダの準備
Dockerディレクトリに「wallabag」という新しいディレクトリを作ります。
{{< gallery match="images/1/*.png" >}}

## ステップ2：データベースのインストール
その後、データベースを作成する必要があります。Synology Dockerのウィンドウで「登録」タブをクリックし、「mariadb」を検索します。Dockerイメージの「mariadb」を選択し、タグの「latest」をクリックしています。
{{< gallery match="images/2/*.png" >}}
画像のダウンロード後、画像として利用できます。Dockerでは、コンテナ（動的状態）とイメージ（固定状態）の2つの状態を区別しています。イメージからコンテナを作成する前に、いくつかの設定を行う必要があります。 mariadbのイメージをダブルクリックします。
{{< gallery match="images/3/*.png" >}}
そして、「詳細設定」をクリックし、「自動再起動」を有効にします。ボリューム "タブを選択し、"フォルダの追加 "をクリックします。そこで、「/var/lib/mysql」というマウントパスで新しいデータベースフォルダを作成します。
{{< gallery match="images/4/*.png" >}}
ポート設定」では、すべてのポートが削除されます。つまり、「3306」のポートを選択し、「-」ボタンで削除するのだ。
{{< gallery match="images/5/*.png" >}}
{{<table "table table-striped table-bordered">}}
|変数名|価値|それは何ですか？|
|--- | --- |---|
|TZ| Europe/Berlin	|タイムゾーン|
|MYSQL_ROOT_PASSWORD	 | wallaroot |データベースのマスターパスワード。|
{{</table>}}
最後に、これらの環境変数を入力します：See:
{{< gallery match="images/6/*.png" >}}
以上の設定で、Mariadb サーバーが起動します。私はどこでも「Apply」を押します。
{{< gallery match="images/7/*.png" >}}

## ステップ3：Wallabagのインストール
Synology Dockerのウィンドウで「登録」タブをクリックし、「wallabag」を検索します。Dockerイメージ「wallabag/wallabag」を選択し、「latest」というタグをクリックしています。
{{< gallery match="images/8/*.png" >}}
私は自分のwallabagの画像をダブルクリックします。そして、「詳細設定」をクリックして、ここでも「自動再起動」を有効にします。
{{< gallery match="images/9/*.png" >}}
ボリューム "タブを選択し、"フォルダの追加 "をクリックします。そこで、「/var/www/wallabag/web/assets/images」というマウントパスで新しいフォルダを作成します。
{{< gallery match="images/10/*.png" >}}
私は「wallabag」コンテナに固定ポートを割り当てています。ポートが固定されていないと、再起動後に「wallabagサーバー」が別のポートで実行される可能性があります。第1コンテナポートは削除可能です。もう一つのポートは覚えておいてください。
{{< gallery match="images/11/*.png" >}}
また、「mariadb」コンテナへの「リンク」を作成する必要があります。リンク "タブをクリックして、データベースコンテナを選択しました。このエイリアス名は、wallabagのインストール時に記憶されるべきものです。
{{< gallery match="images/12/*.png" >}}
{{<table "table table-striped table-bordered">}}
|Umgebungsvariable	|価値|
|--- |---|
|MYSQL_ROOT_PASSWORD	|ワラルート|
|SYMFONY__ENV__DATABASE_DRIVER	|pdo_mysql|
|SYMFONY__ENV__DATABASE_HOST	|db|
|SYMFONY__ENV__DATABASE_PORT	|3306|
|SYMFONY__ENV__DATABASE_NAME	|ワラビー|
|SYMFONY__ENV__DATABASE_USER	|ワラビー|
|SYMFONY__ENV__DATABASE_PASSWORD	|ワラパス|
|SYMFONY__ENV__DATABASE_CHARSET |utf8mb4|
|SYMFONY__ENV__DOMAIN_NAME	|"http://synology-ip:container-port" <- 変更してください|
|SYMFONY__ENV__SERVER_NAME	|"Wallabag - Server"|
|SYMFONY__ENV__FOSUSER_CONFIRMATION	|偽|
|SYMFONY__ENV__TWOFACTOR_AUTH	|偽|
{{</table>}}
最後に、これらの環境変数を入力します：See:
{{< gallery match="images/13/*.png" >}}
これで、コンテナが起動できるようになりました。データベースの作成には時間がかかる場合があります。この動作は、コンテナの詳細から確認できます。
{{< gallery match="images/14/*.png" >}}
SynologyのIPアドレスと自分のコンテナポートを使ってwallabagサーバーに電話します。
{{< gallery match="images/15/*.png" >}}
