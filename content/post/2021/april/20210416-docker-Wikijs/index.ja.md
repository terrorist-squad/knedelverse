+++
date = "2021-04-16"
title = "コンテナで素晴らしいことを: Synology Diskstation への Wiki.js のインストール"
difficulty = "level-1"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "wikijs", "wiki"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210416-docker-Wikijs/index.ja.md"
+++
Wiki.jsは、シンプルなインターフェースで文書作成を楽しくする、強力なオープンソースのWikiソフトウェアです。今日は、Synology DiskStation に Wiki.js サービスをインストールする方法を紹介します。
## プロフェッショナル向けオプション
経験豊富な Synology ユーザーであれば、もちろん SSH でログインし、Docker Compose ファイルを介してセットアップ全体をインストールすることができます。
```
version: '3'
services:
  wikijs:
    image: requarks/wiki:latest
    restart: always
    ports:
      - 8082:3000
    links:
      - database
    environment:
      DB_TYPE: mysql
      DB_HOST: database
      DB_PORT: 3306
      DB_NAME: my_wiki
      DB_USER: wikiuser
      DB_PASS: my_wiki_pass
      TZ: 'Europe/Berlin'

  database:
    image: mysql
    restart: always
    expose:
      - 3306
    volumes:
       - ./mysql:/var/lib/mysql
    environment:
      MYSQL_ROOT_PASSWORD: my_wiki_pass
      MYSQL_DATABASE: my_wiki
      MYSQL_USER: wikiuser
      MYSQL_PASSWORD: my_wiki_pass

```
Dockerverseには、家庭で使える便利なDockerイメージがもっとたくさんあります。
## ステップ1：wikiフォルダの準備
Dockerディレクトリの中に「wiki」というディレクトリを新規に作成します。
{{< gallery match="images/1/*.png" >}}

## ステップ2：データベースのインストール
その後、データベースを作成する必要があります。Synology Dockerウィンドウの「登録」タブをクリックし、「mysql」を検索しています。Dockerイメージ「mysql」を選択し、「latest」というタグをクリックしています。
{{< gallery match="images/2/*.png" >}}
画像ダウンロード後、画像として利用可能です。Dockerでは、コンテナ（動的状態）とイメージ（固定状態）の2つの状態を区別しています。イメージからコンテナを作成する前に、いくつかの設定を行う必要があります。 私のmysqlイメージをダブルクリックします。
{{< gallery match="images/3/*.png" >}}
そして、「詳細設定」をクリックして「自動再起動」を有効にしています。ボリューム」タブを選択し、「フォルダの追加」をクリックしています。そこで、マウントパスを「/var/lib/mysql」として、新しいデータベースフォルダを作成します。
{{< gallery match="images/4/*.png" >}}
ポート設定」で、すべてのポートを削除します。つまり、「3306」ポートを選択し、「-」ボタンで削除するのです。
{{< gallery match="images/5/*.png" >}}
{{<table "table table-striped table-bordered">}}
|変数名|価値|何ですか？|
|--- | --- |---|
|TZ	| Europe/Berlin |タイムゾーン|
|MYSQL_ROOT_PASSWORD	| my_wiki_pass |データベースのマスターパスワード。|
|MYSQL_DATABASE |	my_wiki |これは、データベース名です。|
|MYSQL_USER	| wikiuser |wikiデータベースのユーザー名。|
|MYSQL_PASSWORD |	my_wiki_pass	|wikiデータベースユーザのパスワード。|
{{</table>}}
最後に、この4つの環境変数を入力します:See:
{{< gallery match="images/6/*.png" >}}
以上の設定で、Mariadbサーバーが起動できるようになります。どこでも "Apply "を押してしまう。
## ステップ3：Wiki.jsのインストール
Synology Dockerウィンドウの「登録」タブをクリックし、「wiki」を検索しています。Dockerイメージ「requarks/wiki」を選択し、「latest」タグをクリックしています。
{{< gallery match="images/7/*.png" >}}
自分のWikiJSの画像をダブルクリックする。そして「詳細設定」をクリックし、ここでも「自動再起動」を有効にしています。
{{< gallery match="images/8/*.png" >}}
WikiJS」コンテナには、固定ポートを割り当てています。固定ポートがないと、再起動後に「bookstackサーバ」が別のポートで動作している可能性があります。
{{< gallery match="images/9/*.png" >}}
さらに、「mysql」コンテナへの「リンク」もまだ作成する必要があります。リンク」タブをクリックし、データベースコンテナを選択しています。エイリアス名は、Wikiのインストール時に覚えておく必要があります。
{{< gallery match="images/10/*.png" >}}
{{<table "table table-striped table-bordered">}}
|変数名|価値|何ですか？|
|--- | --- |---|
|TZ	| Europe/Berlin	|タイムゾーン|
|DB_HOST	| wiki-db	|エイリアス名／コンテナリンク|
|DB_TYPE	| mysql	||
|DB_PORT	| 3306	 ||
|DB_PASSWORD	| my_wiki	|ステップ2からのデータ|
|DB_USER	| wikiuser |ステップ2からのデータ|
|DB_PASS	| my_wiki_pass	|ステップ2からのデータ|
{{</table>}}
最後に、これらの環境変数を入力します:See:
{{< gallery match="images/11/*.png" >}}
これで、コンテナの起動が可能になりました。SynologyのIPアドレスと私のコンテナポート/3000でWiki.jsサーバーを呼び出します。
{{< gallery match="images/12/*.png" >}}
