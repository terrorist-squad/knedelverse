+++
date = "2021-04-16"
title = "コンテナの優れた点：Synology DiskstationへのWiki.jsのインストール"
difficulty = "level-1"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "wikijs", "wiki"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/april/20210416-docker-Wikijs/index.ja.md"
+++
Wiki.jsは強力なオープンソースのWikiソフトウェアで、そのシンプルなインターフェイスでドキュメント作成を楽しくします。今日は、Synology DiskStationにWiki.jsのサービスをインストールする方法を紹介します。
## プロフェッショナルのためのオプション
経験豊富なSynologyユーザーであれば、もちろんSSHでログインし、Docker Composeファイルでセットアップ全体をインストールすることができます。
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
自宅で使える便利なDockerイメージは、Dockerverseにもあります。
## ステップ1：wikiフォルダの準備
Dockerのディレクトリに「wiki」という新しいディレクトリを作ります。
{{< gallery match="images/1/*.png" >}}

## ステップ2：データベースのインストール
その後、データベースを作成する必要があります。Synology Dockerのウィンドウで「登録」タブをクリックし、「mysql」を検索します。私はDockerイメージの「mysql」を選択し、「latest」というタグをクリックしています。
{{< gallery match="images/2/*.png" >}}
画像のダウンロード後、画像として利用できます。Dockerでは、コンテナ（動的状態）とイメージ（固定状態）の2つの状態を区別しています。イメージからコンテナを作成する前に、いくつかの設定を行う必要があります。 私は、mysqlイメージをダブルクリックします。
{{< gallery match="images/3/*.png" >}}
そして、「詳細設定」をクリックし、「自動再起動」を有効にします。ボリューム "タブを選択し、"フォルダの追加 "をクリックします。そこで、「/var/lib/mysql」というマウントパスで新しいデータベースフォルダを作成します。
{{< gallery match="images/4/*.png" >}}
ポート設定」では、すべてのポートが削除されます。つまり、「3306」のポートを選択し、「-」ボタンで削除するのだ。
{{< gallery match="images/5/*.png" >}}
{{<table "table table-striped table-bordered">}}
|変数名|価値|それは何ですか？|
|--- | --- |---|
|TZ	| Europe/Berlin |タイムゾーン|
|MYSQL_ROOT_PASSWORD	| my_wiki_pass |データベースのマスターパスワード。|
|MYSQL_DATABASE |	my_wiki |これはデータベース名です。|
|MYSQL_USER	| wikiuser |wikiデータベースのユーザー名。|
|MYSQL_PASSWORD |	my_wiki_pass	|wikiデータベースユーザーのパスワード。|
{{</table>}}
最後に、以下の4つの環境変数を入力します：See:
{{< gallery match="images/6/*.png" >}}
以上の設定で、Mariadb サーバーが起動します。私はどこでも「Apply」を押します。
## ステップ3: Wiki.jsのインストール
Synology Dockerのウィンドウで「登録」タブをクリックし、「wiki」を検索します。requarks/wiki」というDockerイメージを選択して、「latest」というタグをクリックします。
{{< gallery match="images/7/*.png" >}}
私のWikiJSの画像をダブルクリックする。そして、「詳細設定」をクリックして、ここでも「自動再起動」を有効にします。
{{< gallery match="images/8/*.png" >}}
WikiJS "コンテナには固定のポートを割り当てています。ポートが固定されていないと、再起動後に「bookstackサーバ」が別のポートで動作してしまう可能性があります。
{{< gallery match="images/9/*.png" >}}
また、「mysql」コンテナへの「リンク」を作成する必要があります。リンク "タブをクリックして、データベースコンテナを選択しました。エイリアス名は、wikiのインストールのために覚えておく必要があります。
{{< gallery match="images/10/*.png" >}}
{{<table "table table-striped table-bordered">}}
|変数名|価値|それは何ですか？|
|--- | --- |---|
|TZ	| Europe/Berlin	|タイムゾーン|
|DB_HOST	| wiki-db	|別名・コンテナリンク|
|DB_TYPE	| mysql	||
|DB_PORT	| 3306	 ||
|DB_PASSWORD	| my_wiki	|ステップ2のデータ|
|DB_USER	| wikiuser |ステップ2のデータ|
|DB_PASS	| my_wiki_pass	|ステップ2のデータ|
{{</table>}}
最後に、これらの環境変数を入力します：See:
{{< gallery match="images/11/*.png" >}}
これで、コンテナが起動できるようになりました。SynologyのIPアドレスとコンテナのポート/3000でWiki.jsサーバーを呼び出します。
{{< gallery match="images/12/*.png" >}}