+++
date = "2021-04-16"
title = "コンテナで素晴らしいことを: Synology DiskStation 上の自分だけの Bookstack Wiki"
difficulty = "level-1"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "bookstack", "wiki"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210416-docker-Bookstack/index.ja.md"
+++
Bookstackは、MediaWikiやConfluenceに代わる「オープンソース」です。今日は、Synology disk stationにBookstackサービスをインストールする方法を紹介します。
## プロフェッショナル向けオプション
経験豊富な Synology ユーザーであれば、もちろん SSH でログインし、Docker Compose ファイルを介してセットアップ全体をインストールすることができます。
```
version: '3'
services:
  bookstack:
    image: solidnerd/bookstack:0.27.4-1
    restart: always
    ports:
      - 8080:8080
    links:
      - database
    environment:
      DB_HOST: database:3306
      DB_DATABASE: my_wiki
      DB_USERNAME: wikiuser
      DB_PASSWORD: my_wiki_pass
      
  database:
    image: mariadb
    restart: always
    volumes:
       - ./mysql:/var/lib/mysql
    environment:
      MYSQL_ROOT_PASSWORD: my_wiki_pass1
      MYSQL_DATABASE: my_wiki
      MYSQL_USER: wikiuser
      MYSQL_PASSWORD: my_wiki_pass

```
家庭で使える便利なDockerイメージは、[ドッカーバース]({{< ref "dockerverse" >}} "ドッカーバース").Dockerにあります。
## ステップ1：書庫フォルダの準備
Dockerディレクトリの中に「wiki」というディレクトリを新規に作成します。
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
|TZ	| Europe/Berlin |タイムゾーン|
|MYSQL_ROOT_PASSWORD	|  my_wiki_pass |データベースのマスターパスワード。|
|MYSQL_DATABASE | 	my_wiki	|これは、データベース名です。|
|MYSQL_USER	|  wikiuser	|wikiデータベースのユーザー名。|
|MYSQL_PASSWORD	|  my_wiki_pass	|wikiデータベースユーザのパスワード。|
{{</table>}}
最後に、これらの環境変数を入力します:See:
{{< gallery match="images/6/*.png" >}}
以上の設定で、Mariadbサーバーが起動できるようになります。どこでも "Apply "を押してしまう。
## ステップ3：Bookstackのインストール
Synology Dockerウィンドウの「登録」タブをクリックし、「bookstack」を検索しています。Dockerイメージ「solidnerd/bookstack」を選択し、「latest」タグをクリックしています。
{{< gallery match="images/7/*.png" >}}
Bookstackの画像をダブルクリックする。そして「詳細設定」をクリックし、ここでも「自動再起動」を有効にしています。
{{< gallery match="images/8/*.png" >}}
bookstack」コンテナには、固定ポートを割り当てています。固定ポートがないと、再起動後に「bookstackサーバ」が別のポートで動作している可能性があります。最初のコンテナポートを削除することができます。もう一つのポートは覚えておくとよいでしょう。
{{< gallery match="images/9/*.png" >}}
さらに、「mariadb」コンテナへの「リンク」もまだ作成する必要があります。リンク」タブをクリックし、データベースコンテナを選択しています。エイリアス名は、Wikiのインストール時に覚えておく必要があります。
{{< gallery match="images/10/*.png" >}}
{{<table "table table-striped table-bordered">}}
|変数名|価値|何ですか？|
|--- | --- |---|
|TZ	| Europe/Berlin |タイムゾーン|
|DB_HOST	| wiki-db:3306	|エイリアス名／コンテナリンク|
|DB_DATABASE	| my_wiki |ステップ2からのデータ|
|DB_USERNAME	| wikiuser |ステップ2からのデータ|
|DB_PASSWORD	| my_wiki_pass	|ステップ2からのデータ|
{{</table>}}
最後に、これらの環境変数を入力します:See:
{{< gallery match="images/11/*.png" >}}
これで、コンテナの起動が可能になりました。データベースの作成に時間がかかる場合があります。この挙動は、コンテナの詳細を介して観察することができます。
{{< gallery match="images/12/*.png" >}}
SynologyのIPアドレスと私のコンテナポートでBookstackサーバーを呼び出します。ログイン名は "admin@admin.com"、パスワードは "password "です。
{{< gallery match="images/13/*.png" >}}

