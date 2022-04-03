+++
date = "2021-04-25T09:28:11+01:00"
title = "Synology DiskStation の BitwardenRS"
difficulty = "level-2"
tags = ["bitwardenrs", "Docker", "docker-compose", "password-manager", "passwort", "Synology"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210425-docker-BitwardenRS/index.ja.md"
+++
Bitwardenは、オープンソースの無料パスワード管理サービスで、ウェブサイトの認証情報などの機密情報を暗号化された保管庫に保存します。今日は、Synology DiskStationにBitwardenRSをインストールする方法を紹介します。
## ステップ1：BitwardenRSフォルダの準備
Dockerディレクトリの中に「bitwarden」というディレクトリを新規に作成します。
{{< gallery match="images/1/*.png" >}}

## ステップ2：BitwardenRSのインストール
Synology Dockerのウィンドウで「登録」タブをクリックし、「bitwarden」を検索しています。Dockerイメージ「bitwardenrs/server」を選択し、「latest」タグをクリックしています。
{{< gallery match="images/2/*.png" >}}
自分のbitwardenrsの画像をダブルクリックする。そして「詳細設定」をクリックし、ここでも「自動再起動」を有効にしています。
{{< gallery match="images/3/*.png" >}}
ボリューム」タブを選択し、「フォルダの追加」をクリックしています。そこで、このマウントパス「/data」で新しいフォルダを作成します。
{{< gallery match="images/4/*.png" >}}
bitwardenrs」コンテナには、固定ポートを割り当てています。固定ポートがないと、再起動後に「bitwardenrsサーバー」が別のポートで動作している可能性があります。最初のコンテナポートを削除することができます。もう一つのポートは覚えておくとよいでしょう。
{{< gallery match="images/5/*.png" >}}
これで、コンテナの起動が可能になりました。SynologyのIPアドレスと私のコンテナポート8084でbitwardenrsサーバーを呼び出します。
{{< gallery match="images/6/*.png" >}}

## ステップ3: HTTPSの設定
コントロールパネル」→「リバースプロキシ」→「作成」をクリックしています。
{{< gallery match="images/7/*.png" >}}
その後、SynologyのIPアドレスと私のプロキシポート8085でbitwardenrsサーバーを暗号化して呼び出すことができます。
{{< gallery match="images/8/*.png" >}}
