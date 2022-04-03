+++
date = "2021-07-25"
title = "コンテナで素敵なこと：Grocyで冷蔵庫管理"
difficulty = "level-1"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "kühlschrank", "erp", "mhd", "Speispläne", "cms", "Cafe", "Bistro"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/july/20210725-docker-grocy/index.ja.md"
+++
Grocyを使えば、家庭、レストラン、カフェ、ビストロ、フードマーケットをまるごと管理することができます。冷蔵庫、メニュー、タスク、買い物リスト、食品の賞味期限を管理することができます。
{{< gallery match="images/1/*.png" >}}
今日は、Synology disk station に Grocy サービスをインストールする方法を紹介します。
## プロフェッショナル向けオプション
経験豊富な Synology ユーザーであれば、もちろん SSH でログインし、Docker Compose ファイルを介してセットアップ全体をインストールすることができます。
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
家庭で使える便利なDockerイメージは、[ドッカーバース]({{< ref "dockerverse" >}} "ドッカーバース").Dockerにあります。
## ステップ1：Grocyフォルダの準備
Dockerのディレクトリに「grocy」というディレクトリを新規に作成します。
{{< gallery match="images/2/*.png" >}}

## ステップ2：Grocyのインストール
Synology Dockerウィンドウの「登録」タブをクリックし、「Grocy」を検索しています。Dockerイメージ「linuxserver/grocy:latest」を選択し、「latest」タグをクリックしています。
{{< gallery match="images/3/*.png" >}}
自分のグロシー画像をダブルクリックする。
{{< gallery match="images/4/*.png" >}}
そして「詳細設定」をクリックし、ここでも「自動再起動」を有効にしています。ボリューム」タブを選択し、「フォルダの追加」をクリックしています。そこで、このマウントパス「/config」で新しいフォルダを作成します。
{{< gallery match="images/5/*.png" >}}
Grocy」コンテナには、固定ポートを割り当てています。固定ポートがないと、再起動後に「Grocyサーバー」が別のポートで動作している可能性があります。
{{< gallery match="images/6/*.png" >}}
{{<table "table table-striped table-bordered">}}
|変数名|価値|何ですか？|
|--- | --- |---|
|TZ | Europe/Berlin |タイムゾーン|
|PUID | 1024 |Synology管理ユーザーからのユーザーID|
|PGID |	100 |Synology管理ユーザーからのグループID|
{{</table>}}
最後に、これらの環境変数を入力します:See:
{{< gallery match="images/7/*.png" >}}
これで、コンテナの起動が可能になりました。Synology の IP アドレスと私のコンテナ ポートで Grocy サーバーを呼び出し、ユーザー名 "admin" とパスワード "admin" でログインしています。
{{< gallery match="images/8/*.png" >}}

