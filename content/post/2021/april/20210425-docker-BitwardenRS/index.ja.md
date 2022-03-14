+++
date = "2021-04-25T09:28:11+01:00"
title = "Synology DiskStationのBitwardenRS"
difficulty = "level-2"
tags = ["bitwardenrs", "Docker", "docker-compose", "password-manager", "passwort", "Synology"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210425-docker-BitwardenRS/index.ja.md"
+++
Bitwardenは、オープンソースの無料パスワード管理サービスで、ウェブサイトの認証情報などの機密情報を暗号化された金庫に保管します。今日は、Synology DiskStationにBitwardenRSをインストールする方法を紹介します。
## ステップ1：BitwardenRSフォルダの準備
Dockerのディレクトリに「bitwarden」という新しいディレクトリを作ります。
{{< gallery match="images/1/*.png" >}}

## Step 2: BitwardenRSのインストール
Synology Dockerのウィンドウで「登録」タブをクリックし、「bitwarden」を検索します。Dockerイメージ「bitwardenrs/server」を選択して、タグ「latest」をクリックしています。
{{< gallery match="images/2/*.png" >}}
私は自分のbitwardenrsの画像をダブルクリックします。そして、「詳細設定」をクリックして、ここでも「自動再起動」を有効にします。
{{< gallery match="images/3/*.png" >}}
ボリューム "タブを選択し、"フォルダの追加 "をクリックします。そこで、「/data」というマウントパスで新しいフォルダを作成します。
{{< gallery match="images/4/*.png" >}}
bitwardenrs "コンテナに固定ポートを割り当てています。ポートが固定されていないと、再起動後に「bitwardenrsサーバー」が別のポートで動作してしまう可能性があります。第1コンテナポートは削除可能です。もう一つのポートは覚えておいてください。
{{< gallery match="images/5/*.png" >}}
これで、コンテナが起動できるようになりました。SynologyのIPアドレスと私のコンテナポート8084を使ってbitwardenrsサーバーに電話をかけます。
{{< gallery match="images/6/*.png" >}}

## ステップ3：HTTPSの設定
コントロールパネル」→「リバースプロキシ」→「作成」をクリックしています。
{{< gallery match="images/7/*.png" >}}
その後、SynologyのIPアドレスと私のプロキシポート8085でbitwardenrsサーバーを暗号化して呼び出すことができます。
{{< gallery match="images/8/*.png" >}}