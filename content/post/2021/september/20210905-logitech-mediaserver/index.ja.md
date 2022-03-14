+++
date = "2021-09-05"
title = "コンテナの優れた点：Synologyディスクステーション上のLogitechメディアサーバー"
difficulty = "level-1"
tags = ["logitech", "synology", "diskstation", "nas", "sound-system", "multiroom"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/september/20210905-logitech-mediaserver/index.ja.md"
+++
このチュートリアルでは、Synology DiskStation に Logitech Media Server をインストールする方法を説明します。
{{< gallery match="images/1/*.jpg" >}}

## ステップ1：Logitech Media Serverフォルダの準備
Dockerディレクトリの中に「logitechmediaserver」という新しいディレクトリを作ります。
{{< gallery match="images/2/*.png" >}}

## ステップ2：Logitech Mediaserverイメージのインストール
Synology Dockerのウィンドウで「登録」タブをクリックし、「logitechmediaserver」を検索します。私は、Dockerイメージ「lmscommunity/logitechmediaserver」を選択し、「latest」というタグをクリックします。
{{< gallery match="images/3/*.png" >}}
私はLogitech Media Serverのイメージをダブルクリックした。そして、「詳細設定」をクリックして、ここでも「自動再起動」を有効にします。
{{< gallery match="images/4/*.png" >}}
{{<table "table table-striped table-bordered">}}
|Ordner |マウントパス|
|--- |---|
|/volume1/docker/logitechmediaserver/config |/config|
|/volume1/docker/logitechmediaserver/music |/音楽|
|/volume1/docker/logitechmediaserver/playlist |/プレイリスト|
{{</table>}}
ボリューム "タブを選択し、"フォルダの追加 "をクリックします。そこに3つのフォルダを作ります：See:
{{< gallery match="images/5/*.png" >}}
Logitechmediaserver "コンテナには固定ポートを割り当てています。ポートが固定されていないと、再起動後に「Logitechmediaserverサーバ」が別のポートで動作してしまう可能性があります。
{{< gallery match="images/6/*.png" >}}
最後に環境変数を入力します。変数 "TZ "はタイムゾーン "Europe/Berlin "を表しています。
{{< gallery match="images/7/*.png" >}}
これらの設定が終わったら、Logitechmediaserver-Serverを起動します。その後、SynologyディスプレーのIPアドレスと割り当てられたポート（例：http://192.168.21.23:9000）を介してLogitechmediaserverを呼び出すことができます。
{{< gallery match="images/8/*.png" >}}
