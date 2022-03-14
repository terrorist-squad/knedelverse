+++
date = "2021-07-25"
title = "コンテナを使った素晴らしいこと：Grocyによる冷蔵庫の管理"
difficulty = "level-1"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "kühlschrank", "erp", "mhd", "Speispläne", "cms", "Cafe", "Bistro"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/july/20210725-docker-grocy/index.ja.md"
+++
Grocyでは、家庭全体、レストラン、カフェ、ビストロ、フードマーケットを管理することができます。冷蔵庫、メニュー、タスク、買い物リスト、食品の賞味期限などを管理することができます。
{{< gallery match="images/1/*.png" >}}
今日は、SynologyのディスクステーションにGrocyサービスをインストールする方法を紹介します。
## プロフェッショナルのためのオプション
経験豊富なSynologyユーザーであれば、もちろんSSHでログインし、Docker Composeファイルでセットアップ全体をインストールすることができます。
```
version: "2.1"
services:
  grocy:
    image: ghcr.io/linuxserver/grocy
    container_name: grocy
    environment:
      - PUID=1024
      - PGID=100
      - TZ=Europe/Berlin
    volumes:
      - ./data:/config
    ports:
      - 9283:80
    restart: unless-stopped

```
家庭での使用に便利なDockerイメージは、[Dockerverse]({{< ref "dockerverse" >}} "Dockerverse")にもあります。
## ステップ1：Grocyフォルダの準備
Dockerのディレクトリに「grocy」という新しいディレクトリを作ります。
{{< gallery match="images/2/*.png" >}}

## ステップ2：Grocyのインストール
Synology Dockerのウィンドウで「登録」タブをクリックし、「Grocy」を検索します。linuxserver/grocy:latest」というDockerイメージを選択して、「latest」というタグをクリックしています。
{{< gallery match="images/3/*.png" >}}
私はGrocyの画像をダブルクリックします。
{{< gallery match="images/4/*.png" >}}
そして、「詳細設定」をクリックして、ここでも「自動再起動」を有効にします。ボリューム "タブを選択し、"フォルダの追加 "をクリックします。そこで、「/config」というマウントパスで新しいフォルダを作成します。
{{< gallery match="images/5/*.png" >}}
Grocy "コンテナには固定ポートを割り当てています。ポートが固定されていないと、再起動後に「Grocyサーバー」が別のポートで動作してしまう可能性があります。
{{< gallery match="images/6/*.png" >}}
{{<table "table table-striped table-bordered">}}
|変数名|価値|それは何ですか？|
|--- | --- |---|
|TZ | Europe/Berlin |タイムゾーン|
|PUID | 1024 |Synology Admin UserからのユーザーID|
|PGID |	100 |Synology Admin UserからのグループID|
{{</table>}}
最後に、これらの環境変数を入力します：See:
{{< gallery match="images/7/*.png" >}}
これで、コンテナが起動できるようになりました。SynologyのIPアドレスと私のコンテナポートでGrocyサーバーを呼び出し、ユーザー名「admin」とパスワード「admin」でログインします。
{{< gallery match="images/8/*.png" >}}
