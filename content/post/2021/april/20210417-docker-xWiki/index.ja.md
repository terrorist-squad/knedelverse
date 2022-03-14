+++
date = "2021-04-17"
title = "コンテナの優れた点：Synology ディスクステーションで独自の xWiki を実行する"
difficulty = "level-1"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "xwiki", "wiki",]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210417-docker-xWiki/index.ja.md"
+++
XWikiは、Javaで書かれたフリーのWikiソフトウェアプラットフォームで、拡張性を考慮して設計されています。今日は、Synology DiskStationにxWikiサービスをインストールする方法を紹介します。
## プロフェッショナルのためのオプション
経験豊富なSynologyユーザーであれば、もちろんSSHでログインし、Docker Composeファイルでセットアップ全体をインストールすることができます。
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
家庭での使用に便利なDockerイメージは、[Dockerverse]({{< ref "dockerverse" >}} "Dockerverse")にもあります。
## ステップ1：wikiフォルダの準備
Dockerのディレクトリに「wiki」という新しいディレクトリを作ります。
{{< gallery match="images/1/*.png" >}}

## ステップ2：データベースのインストール
その後、データベースを作成する必要があります。Synology Dockerのウィンドウで「登録」タブをクリックし、「postgres」を検索します。私はDockerイメージの「postgres」を選択し、タグの「latest」をクリックします。
{{< gallery match="images/2/*.png" >}}
画像のダウンロード後、画像として利用できます。Dockerでは、コンテナ（動的状態）とイメージ（固定状態）の2つの状態を区別しています。イメージからコンテナを作成する前に、いくつかの設定を行う必要があります。 私はpostgresイメージをダブルクリックしました。
{{< gallery match="images/3/*.png" >}}
そして、「詳細設定」をクリックし、「自動再起動」を有効にします。ボリューム "タブを選択し、"フォルダの追加 "をクリックします。そこで、「/var/lib/postgresql/data」というマウントパスで新しいデータベースフォルダを作成します。
{{< gallery match="images/4/*.png" >}}
ポート設定」では、すべてのポートが削除されます。つまり、「5432」のポートを選択し、「-」ボタンで削除するのです。
{{< gallery match="images/5/*.png" >}}
{{<table "table table-striped table-bordered">}}
|変数名|価値|それは何ですか？|
|--- | --- |---|
|TZ	| Europe/Berlin	|タイムゾーン|
|POSTGRES_DB	| xwiki |これはデータベース名です。|
|POSTGRES_USER	| xwiki |wikiデータベースのユーザー名。|
|POSTGRES_PASSWORD	| xwiki |wikiデータベースユーザーのパスワード。|
{{</table>}}
最後に、以下の4つの環境変数を入力します：See:
{{< gallery match="images/6/*.png" >}}
以上の設定で、Mariadbサーバーが起動できるようになります。私はどこでも「Apply」を押します。
## ステップ3: xWikiのインストール
Synology Dockerのウィンドウで「登録」タブをクリックし、「xwiki」を検索します。Dockerイメージ「xwiki」を選択して、タグ「10-postgres-tomcat」をクリックします。
{{< gallery match="images/7/*.png" >}}
私のxwiki画像をダブルクリックします。そして、「詳細設定」をクリックして、ここでも「自動再起動」を有効にします。
{{< gallery match="images/8/*.png" >}}
xwiki "コンテナには固定のポートを割り当てています。ポートが固定されていないと、再起動後に「xwikiサーバー」が別のポートで動作してしまう可能性があります。
{{< gallery match="images/9/*.png" >}}
また、「postgres」コンテナへの「リンク」を作成する必要があります。リンク "タブをクリックして、データベースコンテナを選択しました。エイリアス名は、wikiのインストールのために覚えておく必要があります。
{{< gallery match="images/10/*.png" >}}
{{<table "table table-striped table-bordered">}}
|変数名|価値|それは何ですか？|
|--- | --- |---|
|TZ |	Europe/Berlin	|タイムゾーン|
|DB_HOST	| db |別名・コンテナリンク|
|DB_DATABASE	| xwiki	|ステップ2のデータ|
|DB_USER	| xwiki	|ステップ2のデータ|
|DB_PASSWORD	| xwiki |ステップ2のデータ|
{{</table>}}
最後に、これらの環境変数を入力します：See:
{{< gallery match="images/11/*.png" >}}
これで、コンテナが起動できるようになりました。Synology の IP アドレスと私のコンテナ ポートを使って xWiki サーバーを呼び出します。
{{< gallery match="images/12/*.png" >}}