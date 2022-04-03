+++
date = "2021-04-18"
title = "コンテナですごいこと：SynologyディスクステーションにWallaBagを所有する"
difficulty = "level-1"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "archiv", "wallabag"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210418-docker-WallaBag/index.ja.md"
+++
Wallabagは、面白いWebサイトや記事をアーカイブするためのプログラムです。今日は、Synology disk stationにWallabagサービスをインストールする方法を紹介します。
## プロフェッショナル向けオプション
経験豊富な Synology ユーザーであれば、もちろん SSH でログインし、Docker Compose ファイルを介してセットアップ全体をインストールすることができます。
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
家庭で使える便利なDockerイメージは、[ドッカーバース]({{< ref "dockerverse" >}} "ドッカーバース").Dockerにあります。
## ステップ1：壁掛けフォルダーを用意する
Dockerディレクトリの中に「wallabag」というディレクトリを新規に作成します。
{{< gallery match="images/1/*.png" >}}

## ステップ2：データベースのインストール
その後、データベースを作成する必要があります。Synology Dockerのウィンドウで「登録」タブをクリックし、「mariadb」を検索しています。Dockerイメージ「mariadb」を選択し、「latest」タグをクリックしています。
{{< gallery match="images/2/*.png" >}}
画像ダウンロード後、画像として利用可能です。Dockerでは、コンテナ（動的状態）とイメージ（固定状態）の2つの状態を区別しています。イメージからコンテナを作成する前に、いくつかの設定を行う必要があります。 mariadb イメージをダブルクリックします。
{{< gallery match="images/3/*.png" >}}
そして、「詳細設定」をクリックして「自動再起動」を有効にしています。ボリューム」タブを選択し、「フォルダの追加」をクリックしています。そこで、マウントパスを「/var/lib/mysql」として、新しいデータベースフォルダを作成します。
{{< gallery match="images/4/*.png" >}}
ポート設定」で、すべてのポートを削除します。つまり、「3306」ポートを選択し、「-」ボタンで削除するのです。
{{< gallery match="images/5/*.png" >}}
{{<table "table table-striped table-bordered">}}
|変数名|価値|何ですか？|
|--- | --- |---|
|TZ| Europe/Berlin	|タイムゾーン|
|MYSQL_ROOT_PASSWORD	 | wallaroot |データベースのマスターパスワード。|
{{</table>}}
最後に、これらの環境変数を入力します:See:
{{< gallery match="images/6/*.png" >}}
以上の設定で、Mariadbサーバーが起動できるようになります。どこでも "Apply "を押してしまう。
{{< gallery match="images/7/*.png" >}}

## ステップ3：Wallabagのインストール
Synology Dockerウィンドウの「登録」タブをクリックし、「wallabag」を検索しています。Dockerイメージ「wallabag/wallabag」を選択し、「latest」というタグをクリックしています。
{{< gallery match="images/8/*.png" >}}
自分の壁掛け画像をダブルクリックする。そして「詳細設定」をクリックし、ここでも「自動再起動」を有効にしています。
{{< gallery match="images/9/*.png" >}}
ボリューム」タブを選択し、「フォルダの追加」をクリックしています。そこで、マウントパス「/var/www/wallabag/web/assets/images」で新しいフォルダを作成します。
{{< gallery match="images/10/*.png" >}}
wallabag」コンテナには、固定ポートを割り当てています。固定ポートがなければ、再起動後に「wallabagサーバー」が別のポートで動作することもあり得ます。最初のコンテナポートを削除することができます。もう一つのポートは覚えておくとよいでしょう。
{{< gallery match="images/11/*.png" >}}
さらに、「mariadb」コンテナへの「リンク」もまだ作成する必要があります。リンク」タブをクリックし、データベースコンテナを選択しています。このエイリアス名は、wallabagのインストール時に記憶しておく必要があります。
{{< gallery match="images/12/*.png" >}}
{{<table "table table-striped table-bordered">}}
|Umgebungsvariable	|価値|
|--- |---|
|MYSQL_ROOT_PASSWORD	|ワラジムシ|
|SYMFONY__ENV__DATABASE_DRIVER	|pdo_mysql|
|SYMFONY__ENV__DATABASE_HOST	|デブ|
|SYMFONY__ENV__DATABASE_PORT	|3306|
|SYMFONY__ENV__DATABASE_NAME	|手提げ袋|
|SYMFONY__ENV__DATABASE_USER	|手提げ袋|
|SYMFONY__ENV__DATABASE_PASSWORD	|ワラパス|
|SYMFONY__ENV__DATABASE_CHARSET |ユーティーエフエッチフォー|
|SYMFONY__ENV__DOMAIN_NAME	|"http://synology-ip:container-port" <-変更願います|
|SYMFONY__ENV__SERVER_NAME	|"Wallabag-サーバ"|
|SYMFONY__ENV__FOSUSER_CONFIRMATION	|擬似|
|SYMFONY__ENV__TWOFACTOR_AUTH	|擬似|
{{</table>}}
最後に、これらの環境変数を入力します:See:
{{< gallery match="images/13/*.png" >}}
これで、コンテナの起動が可能になりました。データベースの作成に時間がかかる場合があります。この挙動は、コンテナの詳細を介して観察することができます。
{{< gallery match="images/14/*.png" >}}
Synology IPアドレスと私のコンテナポートでwallabagサーバーを呼び出します。
{{< gallery match="images/15/*.png" >}}
しかし、個人的にはインターネット上のアーカイブとしては、shioriの方が好きだと言わざるを得ません。
