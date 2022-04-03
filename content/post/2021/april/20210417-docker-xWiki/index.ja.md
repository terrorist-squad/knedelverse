+++
date = "2021-04-17"
title = "コンテナですごいこと：Synologyディスクステーションで自分だけのxWikiを動かす"
difficulty = "level-1"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "xwiki", "wiki",]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210417-docker-xWiki/index.ja.md"
+++
XWikiは、Javaで書かれたフリーのWikiソフトウェアプラットフォームで、拡張性を念頭に置いて設計されています。今日は、Synology DiskStation に xWiki サービスをインストールする方法を紹介します。
## プロフェッショナル向けオプション
経験豊富な Synology ユーザーであれば、もちろん SSH でログインし、Docker Compose ファイルを介してセットアップ全体をインストールすることができます。
```
version: '3'
services:
  xwiki:
    image: xwiki:10-postgres-tomcat
    restart: always
    ports:
      - 8080:8080
    links:
      - db
    environment:
      DB_HOST: db
      DB_DATABASE: xwiki
      DB_DATABASE: xwiki
      DB_PASSWORD: xwiki
      TZ: 'Europe/Berlin'

  db:
    image: postgres:latest
    restart: always
    volumes:
      - ./postgresql:/var/lib/postgresql/data
    environment:
      - POSTGRES_USER=xwiki
      - POSTGRES_PASSWORD=xwiki
      - POSTGRES_DB=xwiki
      - TZ='Europe/Berlin'

```
家庭で使える便利なDockerイメージは、[ドッカーバース]({{< ref "dockerverse" >}} "ドッカーバース").Dockerにあります。
## ステップ1：wikiフォルダの準備
Dockerディレクトリの中に「wiki」というディレクトリを新規に作成します。
{{< gallery match="images/1/*.png" >}}

## ステップ2：データベースのインストール
その後、データベースを作成する必要があります。Synology Dockerウィンドウの「登録」タブをクリックし、「postgres」を検索しています。Dockerイメージの「postgres」を選択し、「latest」というタグをクリックしています。
{{< gallery match="images/2/*.png" >}}
画像ダウンロード後、画像として利用可能です。Dockerでは、コンテナ（動的状態）とイメージ（固定状態）の2つの状態を区別しています。イメージからコンテナを作成する前に、いくつかの設定を行う必要があります。 私は、postgresイメージをダブルクリックします。
{{< gallery match="images/3/*.png" >}}
そして、「詳細設定」をクリックして「自動再起動」を有効にしています。ボリューム」タブを選択し、「フォルダの追加」をクリックしています。そこで、マウントパスを「/var/lib/postgresql/data」として、新しいデータベースフォルダを作成します。
{{< gallery match="images/4/*.png" >}}
ポート設定」で、すべてのポートを削除します。つまり、「5432」ポートを選択し、「-」ボタンで削除するのです。
{{< gallery match="images/5/*.png" >}}
{{<table "table table-striped table-bordered">}}
|変数名|価値|何ですか？|
|--- | --- |---|
|TZ	| Europe/Berlin	|タイムゾーン|
|POSTGRES_DB	| xwiki |これは、データベース名です。|
|POSTGRES_USER	| xwiki |wikiデータベースのユーザー名。|
|POSTGRES_PASSWORD	| xwiki |wikiデータベースユーザのパスワード。|
{{</table>}}
最後に、この4つの環境変数を入力します:See:
{{< gallery match="images/6/*.png" >}}
以上の設定で、Mariadbサーバーが起動できるようになります。どこでも "Apply "を押してしまう。
## ステップ3：xWikiのインストール
Synology Dockerウィンドウの「登録」タブをクリックし、「xwiki」を検索しています。Dockerイメージ「xwiki」を選択し、「10-postgres-tomcat」というタグをクリックしています。
{{< gallery match="images/7/*.png" >}}
私は自分のxwiki画像をダブルクリックします。そして「詳細設定」をクリックし、ここでも「自動再起動」を有効にしています。
{{< gallery match="images/8/*.png" >}}
xwiki」コンテナには、固定ポートを割り当てています。固定ポートがないと、再起動後に「xwikiサーバ」が別のポートで動作してしまう可能性があります。
{{< gallery match="images/9/*.png" >}}
さらに、「postgres」コンテナへの「リンク」を作成する必要があります。リンク」タブをクリックし、データベースコンテナを選択しています。エイリアス名は、Wikiのインストール時に覚えておく必要があります。
{{< gallery match="images/10/*.png" >}}
{{<table "table table-striped table-bordered">}}
|変数名|価値|何ですか？|
|--- | --- |---|
|TZ |	Europe/Berlin	|タイムゾーン|
|DB_HOST	| db |エイリアス名／コンテナリンク|
|DB_DATABASE	| xwiki	|ステップ2からのデータ|
|DB_USER	| xwiki	|ステップ2からのデータ|
|DB_PASSWORD	| xwiki |ステップ2からのデータ|
{{</table>}}
最後に、これらの環境変数を入力します:See:
{{< gallery match="images/11/*.png" >}}
これで、コンテナの起動が可能になりました。私はSynologyのIPアドレスと私のコンテナポートでxWikiサーバーを呼び出します。
{{< gallery match="images/12/*.png" >}}
