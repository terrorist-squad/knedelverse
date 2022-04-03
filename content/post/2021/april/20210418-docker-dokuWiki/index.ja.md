+++
date = "2021-04-18"
title = "コンテナですごいこと：Synologyディスクステーションに自分だけのdokuWikiをインストールする"
difficulty = "level-2"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "dokuwiki", "wiki"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210418-docker-dokuWiki/index.ja.md"
+++
DokuWiki は、標準に準拠し、使いやすく、同時に非常に汎用性の高いオープンソースの wiki ソフトウェアです。今日は、Synology disk station に DokuWiki サービスをインストールする方法を紹介します。
## プロフェッショナル向けオプション
経験豊富な Synology ユーザーであれば、もちろん SSH でログインし、Docker Compose ファイルを介してセットアップ全体をインストールすることができます。
```
version: '3'
services:
  dokuwiki:
    image:  bitnami/dokuwiki:latest
    restart: always
    ports:
      - 8080:8080
      - 8443:8443
    environment:
      TZ: 'Europe/Berlin'
      DOKUWIKI_USERNAME: 'admin'
      DOKUWIKI_FULL_NAME: 'wiki'
      DOKUWIKI_PASSWORD: 'password'
    volumes:
      - ./data:/bitnami/dokuwiki

```
家庭で使える便利なDockerイメージは、[ドッカーバース]({{< ref "dockerverse" >}} "ドッカーバース").Dockerにあります。
## ステップ1：wikiフォルダの準備
Dockerディレクトリの中に「wiki」というディレクトリを新規に作成します。
{{< gallery match="images/1/*.png" >}}

## ステップ2：DokuWikiのインストール
その後、データベースを作成する必要があります。Synology Dockerウィンドウの「登録」タブをクリックし、「dokuwiki」を検索しています。Dockerイメージ「bitnami/dokuwiki」を選択し、「latest」タグをクリックしています。
{{< gallery match="images/2/*.png" >}}
画像ダウンロード後、画像として利用可能です。Dockerでは、コンテナ（動的状態）とイメージ（固定状態）の2つの状態を区別しています。イメージからコンテナを作成する前に、いくつかの設定を行う必要があります。 私は、dokuwikiイメージをダブルクリックします。
{{< gallery match="images/3/*.png" >}}
dokuwiki」コンテナには、固定ポートを割り当てています。固定ポートがないと、再起動後に「dokuwikiサーバー」が別のポートで動作している可能性があります。
{{< gallery match="images/4/*.png" >}}
{{<table "table table-striped table-bordered">}}
|変数名|価値|何ですか？|
|--- | --- |---|
|TZ	| Europe/Berlin	|タイムゾーン|
|DOKUWIKI_USERNAME	| admin|管理者ユーザー名|
|DOKUWIKI_FULL_NAME |	wiki	|WIki名|
|DOKUWIKI_PASSWORD	| password	|管理者パスワード|
{{</table>}}
最後に、これらの環境変数を入力します:See:
{{< gallery match="images/5/*.png" >}}
これで、コンテナの起動が可能になりました。Synology IPアドレスと私のコンテナポートでdokuWIkiサーバーを呼び出します。
{{< gallery match="images/6/*.png" >}}

