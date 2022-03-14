+++
date = "2021-04-18"
title = "コンテナの優れた点：Synology ディスクステーションに独自の dokuWiki をインストールする"
difficulty = "level-2"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "dokuwiki", "wiki"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/april/20210418-docker-dokuWiki/index.ja.md"
+++
DokuWikiは、標準に準拠した使いやすいオープンソースのWikiソフトウェアで、同時に非常に多機能です。今日は、SynologyのディスクステーションにDokuWikiのサービスをインストールする方法を紹介します。
## プロフェッショナルのためのオプション
経験豊富なSynologyユーザーであれば、もちろんSSHでログインし、Docker Composeファイルでセットアップ全体をインストールすることができます。
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
家庭での使用に便利なDockerイメージは、[Dockerverse]({{< ref "dockerverse" >}} "Dockerverse")にもあります。
## ステップ1：wikiフォルダの準備
Dockerのディレクトリに「wiki」という新しいディレクトリを作ります。
{{< gallery match="images/1/*.png" >}}

## ステップ2: DokuWikiのインストール
その後、データベースを作成する必要があります。Synology Dockerのウィンドウで「登録」タブをクリックし、「dokuwiki」を検索します。Dockerイメージ「bitnami/dokuwiki」を選択し、タグ「latest」をクリックしています。
{{< gallery match="images/2/*.png" >}}
画像のダウンロード後、画像として利用できます。Dockerでは、コンテナ（動的状態）とイメージ（固定状態）の2つの状態を区別しています。イメージからコンテナを作成する前に、いくつかの設定を行う必要があります。 私はdokuwikiイメージをダブルクリックします。
{{< gallery match="images/3/*.png" >}}
私は「dokuwiki」コンテナに固定のポートを割り当てています。ポートが固定されていないと、再起動後に「dokuwikiサーバー」が別のポートで動作してしまう可能性があります。
{{< gallery match="images/4/*.png" >}}
{{<table "table table-striped table-bordered">}}
|変数名|価値|それは何ですか？|
|--- | --- |---|
|TZ	| Europe/Berlin	|タイムゾーン|
|DOKUWIKI_USERNAME	| admin|管理者ユーザー名|
|DOKUWIKI_FULL_NAME |	wiki	|WIkiの名前|
|DOKUWIKI_PASSWORD	| password	|管理者パスワード|
{{</table>}}
最後に、これらの環境変数を入力します：See:
{{< gallery match="images/5/*.png" >}}
これで、コンテナが起動できるようになりました。SynologyのIPアドレスと自分のコンテナポートを使ってdokuWIkiサーバーを呼び出します。
{{< gallery match="images/6/*.png" >}}
