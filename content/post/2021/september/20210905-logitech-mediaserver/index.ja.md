+++
date = "2021-09-05"
title = "コンテナですごいこと：Synology ディスクステーションにロジテックメディアサーバー"
difficulty = "level-1"
tags = ["logitech", "synology", "diskstation", "nas", "sound-system", "multiroom"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/september/20210905-logitech-mediaserver/index.ja.md"
+++
このチュートリアルでは、Synology DiskStation に Logitech Media Server をインストールする方法について説明します。
{{< gallery match="images/1/*.jpg" >}}

## ステップ1：Logitech Media Serverフォルダの準備
Dockerディレクトリに「logitechmediaserver」というディレクトリを新規に作成します。
{{< gallery match="images/2/*.png" >}}

## ステップ2：Logitech Mediaserverイメージのインストール
Synology Dockerウィンドウの「登録」タブをクリックし、「logitechmediaserver」を検索しています。Dockerイメージ「lmscommunity/logitechmediaserver」を選択し、「latest」タグをクリックしています。
{{< gallery match="images/3/*.png" >}}
ロジテックメディアサーバーのイメージをダブルクリックする。そして「詳細設定」をクリックし、ここでも「自動再起動」を有効にしています。
{{< gallery match="images/4/*.png" >}}
{{<table "table table-striped table-bordered">}}
|Ordner |マウントパス|
|--- |---|
|/volume1/docker/logitechmediaserver/config |/config|
|/volume1/docker/logitechmediaserver/music |/音楽|
|/volume1/docker/logitechmediaserver/playlist |/プレイリスト|
{{</table>}}
ボリューム」タブを選択し、「フォルダの追加」をクリックしています。そこに3つのフォルダーを作成します。
{{< gallery match="images/5/*.png" >}}
Logitechmediaserver」コンテナには、固定ポートを割り当てています。固定ポートがなければ、再起動後に「Logitechmediaserverサーバー」が別のポートで動作している可能性があります。
{{< gallery match="images/6/*.png" >}}
最後に、環境変数を入力する。変数 "TZ "はタイムゾーン "Europe/Berlin "である。
{{< gallery match="images/7/*.png" >}}
これらの設定後、Logitechmediaserver-Server を起動することができます!その後、Synology disctation の IP アドレスと割り当てられたポート（例：http://192.168.21.23:9000）を介して Logitechmediaserver を呼び出すことができます。
{{< gallery match="images/8/*.png" >}}

