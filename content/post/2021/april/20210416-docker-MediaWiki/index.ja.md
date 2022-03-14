+++
date = "2021-04-16"
title = "コンテナの優れた点：Synology ディスク ステーションに独自の MediaWiki をインストールする"
difficulty = "level-1"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "mediawiki", "wiki"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210416-docker-MediaWiki/index.ja.md"
+++
MediaWikiは、PHPベースのWikiシステムで、オープンソース製品として無償で提供されています。今日は、SynologyのディスクステーションにMediaWikiのサービスをインストールする方法を紹介します。
## プロフェッショナルのためのオプション
経験豊富なSynologyユーザーであれば、もちろんSSHでログインし、Docker Composeファイルでセットアップ全体をインストールすることができます。
```
version: '3'
services:
  mediawiki:
    image: mediawiki
    restart: always
    ports:
      - 8081:80
    links:
      - database
    volumes:
      - ./images:/var/www/html/images
      # After initial setup, download LocalSettings.php to the same directory as
      # this yaml and uncomment the following line and use compose to restart
      # the mediawiki service
      # - ./LocalSettings.php:/var/www/html/LocalSettings.php

  database:
    image: mariadb
    restart: always
    volumes:
       - ./mysql:/var/lib/mysql
    environment:
      # @see https://phabricator.wikimedia.org/source/mediawiki/browse/master/includes/DefaultSettings.php
      MYSQL_ROOT_PASSWORD: my_wiki_pass1
      MYSQL_DATABASE: my_wiki
      MYSQL_USER: wikiuser
      MYSQL_PASSWORD: my_wiki_pass

```
家庭での使用に便利なDockerイメージは、[Dockerverse]({{< ref "dockerverse" >}} "Dockerverse")にもあります。
## ステップ1: MediaWikiフォルダの準備
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
|TZ	| Europe/Berlin	|タイムゾーン|
|MYSQL_ROOT_PASSWORD	| my_wiki_pass	|データベースのマスターパスワード。|
|MYSQL_DATABASE |	my_wiki	|これはデータベース名です。|
|MYSQL_USER	| wikiuser |wikiデータベースのユーザー名。|
|MYSQL_PASSWORD	| my_wiki_pass |wikiデータベースユーザーのパスワード。|
{{</table>}}
最後に、これらの環境変数を入力します：See:
{{< gallery match="images/6/*.png" >}}
以上の設定で、Mariadbサーバーが起動できるようになります。私はどこでも「Apply」を押します。
## ステップ3: MediaWikiのインストール
Synology Dockerのウィンドウで「登録」タブをクリックし、「mediawiki」を検索します。Dockerイメージの「mediawiki」を選択し、「latest」というタグをクリックしています。
{{< gallery match="images/7/*.png" >}}
私はMediawikiの画像をダブルクリックします。
{{< gallery match="images/8/*.png" >}}
そして、「詳細設定」をクリックして、ここでも「自動再起動」を有効にします。ボリューム "タブを選択し、"フォルダの追加 "をクリックします。そこで、「/var/www/html/images」というマウントパスで新しいフォルダを作成します。
{{< gallery match="images/9/*.png" >}}
MediaWiki "コンテナには固定のポートを割り当てています。ポートが固定されていないと、再起動後に「MediaWikiサーバ」が別のポートで実行される可能性があります。
{{< gallery match="images/10/*.png" >}}
また、「mariadb」コンテナへの「リンク」を作成する必要があります。リンク "タブをクリックして、データベースコンテナを選択しました。エイリアス名は、wikiのインストールのために覚えておく必要があります。
{{< gallery match="images/11/*.png" >}}
最後に、環境変数「TZ」に「Europe/Berlin」という値を入力します。
{{< gallery match="images/12/*.png" >}}
これで、コンテナが起動できるようになりました。SynologyのIPアドレスと私のコンテナポートでMediawikiサーバーを呼び出します。Database server」には、データベースコンテナのエイリアス名を入力します。また、「ステップ2」で設定したデータベース名、ユーザー名、パスワードを入力します。
{{< gallery match="images/13/*.png" >}}