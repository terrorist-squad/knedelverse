+++
date = "2021-04-16"
title = "コンテナですごいこと：Synologyディスクステーションに自分だけのMediaWikiをインストールする"
difficulty = "level-1"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "mediawiki", "wiki"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210416-docker-MediaWiki/index.ja.md"
+++
MediaWikiは、PHPベースのWikiシステムで、オープンソース製品として無償で提供されています。今日は、Synology ディスクステーションに MediaWiki サービスをインストールする方法を紹介します。
## プロフェッショナル向けオプション
経験豊富な Synology ユーザーであれば、もちろん SSH でログインし、Docker Compose ファイルを介してセットアップ全体をインストールすることができます。
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
家庭で使える便利なDockerイメージは、[ドッカーバース]({{< ref "dockerverse" >}} "ドッカーバース").Dockerにあります。
## ステップ1：MediaWikiフォルダの準備
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
|TZ	| Europe/Berlin	|タイムゾーン|
|MYSQL_ROOT_PASSWORD	| my_wiki_pass	|データベースのマスターパスワード。|
|MYSQL_DATABASE |	my_wiki	|これは、データベース名です。|
|MYSQL_USER	| wikiuser |wikiデータベースのユーザー名。|
|MYSQL_PASSWORD	| my_wiki_pass |wikiデータベースユーザのパスワード。|
{{</table>}}
最後に、これらの環境変数を入力します:See:
{{< gallery match="images/6/*.png" >}}
以上の設定で、Mariadbサーバーが起動できるようになります。どこでも "Apply "を押してしまう。
## ステップ3：MediaWikiのインストール
Synology Dockerウィンドウの「登録」タブをクリックし、「mediawiki」を検索しています。Dockerイメージ「mediawiki」を選択し、「latest」タグをクリックしています。
{{< gallery match="images/7/*.png" >}}
自分のMediawikiの画像をダブルクリックする。
{{< gallery match="images/8/*.png" >}}
そして「詳細設定」をクリックし、ここでも「自動再起動」を有効にしています。ボリューム」タブを選択し、「フォルダの追加」をクリックしています。そこで、このマウントパス「/var/www/html/images」で新しいフォルダを作成します。
{{< gallery match="images/9/*.png" >}}
MediaWiki」コンテナには、固定ポートを割り当てています。固定ポートがなければ、再起動後に「MediaWikiサーバ」が別のポートで動作することもあり得ます。
{{< gallery match="images/10/*.png" >}}
さらに、「mariadb」コンテナへの「リンク」もまだ作成する必要があります。リンク」タブをクリックし、データベースコンテナを選択しています。エイリアス名は、Wikiのインストール時に覚えておく必要があります。
{{< gallery match="images/11/*.png" >}}
最後に、環境変数「TZ」に「Europe/Berlin」という値を入力しています。
{{< gallery match="images/12/*.png" >}}
これで、コンテナの起動が可能になりました。私はSynologyのIPアドレスと私のコンテナポートでMediawikiサーバーを呼び出します。Database serverに、データベースコンテナのエイリアス名を入力します。また、「Step2」で入力したデータベース名、ユーザー名、パスワードも入力します。
{{< gallery match="images/13/*.png" >}}
