+++
date = "2020-02-13"
title = "Synology-Nas：Calibre Webを電子書籍ライブラリーとしてインストールする。"
difficulty = "level-1"
tags = ["calbre-web", "calibre", "Docker", "ds918", "ebook", "epub", "nas", "pdf", "Synology"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2020/february/20200213-synology-calibreweb/index.ja.md"
+++
Synology NAS に Docker コンテナとして Calibre-Web をインストールするには？ 注意: このインストール方法は古く、現在の Calibre ソフトウェアと互換性がありません。この新しいチュートリアルをご覧ください：[コンテナで素晴らしいことを: Docker ComposeでCalibreを実行する]({{< ref "post/2020/february/20200221-docker-Calibre-pro" >}} "コンテナで素晴らしいことを: Docker ComposeでCalibreを実行する").このチュートリアルは、すべての Synology DS プロフェッショナルのためのものです。
## ステップ1：フォルダの作成
まず、キャリバーライブラリ用のフォルダを作成します。  システムコントロール」→「共有フォルダ」を呼び出して、「Books」というフォルダを新規に作成しました。
{{< gallery match="images/1/*.png" >}}

## ステップ2：キャリバーライブラリの作成
ここで、既存のライブラリや「[この空のサンプルライブラリ](https://drive.google.com/file/d/1zfeU7Jh3FO_jFlWSuZcZQfQOGD0NvXBm/view)」を新しいディレクトリにコピーしてみます。私自身は、デスクトップアプリケーションの既存のライブラリをコピーしています。
{{< gallery match="images/2/*.png" >}}

## ステップ3：Dockerイメージの検索
Synology Dockerウィンドウの「登録」タブをクリックし、「Calibre」を検索しています。Dockerイメージ「janeczku/calibre-web」を選択し、「latest」タグをクリックしています。
{{< gallery match="images/3/*.png" >}}
画像ダウンロード後、画像として利用可能です。Dockerでは、コンテナ（動的状態）とイメージ/画像（固定状態）の2つの状態を区別しています。イメージからコンテナを作成する前に、いくつかの設定を行う必要があります。
## ステップ4：画像を運用に乗せる。
キャリバーイメージをダブルクリックする。
{{< gallery match="images/4/*.png" >}}
そして、「詳細設定」をクリックして「自動再起動」を有効にしています。ボリューム」タブを選択し、「フォルダの追加」をクリックしています。そこで、マウントパス「/calibre」で新しいデータベースフォルダを作成します。
{{< gallery match="images/5/*.png" >}}
キャリバーコンテナには固定ポートを割り当てています。固定ポートがなければ、キャリバーが再起動後に別のポートで動作する可能性があります。
{{< gallery match="images/6/*.png" >}}
これらの設定の後、Calibreを起動することができます!
{{< gallery match="images/7/*.png" >}}
ここで、割り当てられたキャリバーポートでSynologyのIPを呼び出すと、次のような画像が表示されます。キャリバーデータベースの場所」として「/calibre」を入力しています。残りの設定は好みの問題です。
{{< gallery match="images/8/*.png" >}}
デフォルトのログインは "admin"、パスワードは "admin123 "です。
{{< gallery match="images/9/*.png" >}}
完了！もちろん、「ブックフォルダ」経由でデスクトップアプリも接続できるようになりました。アプリでライブラリを入れ替えて、Nasのフォルダを選択するんです。
{{< gallery match="images/10/*.png" >}}
こんな感じ。
{{< gallery match="images/11/*.png" >}}
現在、デスクトップアプリケーションでメタ情報を編集すると、ウェブアプリケーションでも自動的に更新されるようになっています。
{{< gallery match="images/12/*.png" >}}
