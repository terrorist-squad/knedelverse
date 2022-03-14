+++
date = "2021-04-16"
title = "コンテナを使った素晴らしいこと：Synology DiskStation での独自の Bookstack Wiki"
difficulty = "level-1"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "bookstack", "wiki"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/april/20210416-docker-Bookstack/index.ja.md"
+++
Bookstackは、MediaWikiやConfluenceに代わる「オープンソース」です。今日は、SynologyのディスクステーションにBookstackのサービスをインストールする方法を紹介します。
## プロフェッショナルのためのオプション
経験豊富なSynologyユーザーであれば、もちろんSSHでログインし、Docker Composeファイルでセットアップ全体をインストールすることができます。
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
家庭での使用に便利なDockerイメージは、[Dockerverse]({{< ref "dockerverse" >}} "Dockerverse")にもあります。
## ステップ1: ブックスタックフォルダの準備
Dockerのディレクトリに「wiki」という新しいディレクトリを作ります。
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
|TZ	| Europe/Berlin |タイムゾーン|
|MYSQL_ROOT_PASSWORD	|  my_wiki_pass |データベースのマスターパスワード。|
|MYSQL_DATABASE | 	my_wiki	|これはデータベース名です。|
|MYSQL_USER	|  wikiuser	|wikiデータベースのユーザー名。|
|MYSQL_PASSWORD	|  my_wiki_pass	|wikiデータベースユーザーのパスワード。|
{{</table>}}
最後に、これらの環境変数を入力します：See:
{{< gallery match="images/6/*.png" >}}
以上の設定で、Mariadb サーバーが起動します。私はどこでも「Apply」を押します。
## ステップ3：Bookstackのインストール
Synology Dockerのウィンドウで「登録」タブをクリックし、「bookstack」を検索します。Dockerイメージ「solidnerd/bookstack」を選択し、「latest」というタグをクリックしています。
{{< gallery match="images/7/*.png" >}}
私のBookstackのイメージをダブルクリックします。そして、「詳細設定」をクリックして、ここでも「自動再起動」を有効にします。
{{< gallery match="images/8/*.png" >}}
"bookstack "コンテナに固定ポートを割り当てています。ポートが固定されていないと、再起動後に「bookstackサーバ」が別のポートで動作してしまう可能性があります。第1コンテナポートは削除可能です。もう一つのポートは覚えておいてください。
{{< gallery match="images/9/*.png" >}}
また、「mariadb」コンテナへの「リンク」を作成する必要があります。リンク "タブをクリックして、データベースコンテナを選択しました。エイリアス名は、wikiのインストールのために覚えておく必要があります。
{{< gallery match="images/10/*.png" >}}
{{<table "table table-striped table-bordered">}}
|変数名|価値|それは何ですか？|
|--- | --- |---|
|TZ	| Europe/Berlin |タイムゾーン|
|DB_HOST	| wiki-db:3306	|別名・コンテナリンク|
|DB_DATABASE	| my_wiki |ステップ2のデータ|
|DB_USERNAME	| wikiuser |ステップ2のデータ|
|DB_PASSWORD	| my_wiki_pass	|ステップ2のデータ|
{{</table>}}
最後に、これらの環境変数を入力します：See:
{{< gallery match="images/11/*.png" >}}
これで、コンテナが起動できるようになりました。データベースの作成には時間がかかる場合があります。この動作は、コンテナの詳細から確認できます。
{{< gallery match="images/12/*.png" >}}
SynologyのIPアドレスと私のコンテナポートを使ってBookstackサーバーを呼び出します。ログイン名は「admin@admin.com」、パスワードは「password」です。
{{< gallery match="images/13/*.png" >}}
