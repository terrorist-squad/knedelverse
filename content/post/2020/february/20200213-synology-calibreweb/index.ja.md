+++
date = "2020-02-13"
title = "Synology-Nas：電子書籍ライブラリとしてのCalibre Webのインストール"
difficulty = "level-1"
tags = ["calbre-web", "calibre", "Docker", "ds918", "ebook", "epub", "nas", "pdf", "Synology"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2020/february/20200213-synology-calibreweb/index.ja.md"
+++
Calibre-WebをDockerコンテナとしてSynology NASにインストールする方法を教えてください。 注意：このインストール方法は古く、現在のCalibreソフトウェアとは互換性がありません。この新しいチュートリアルを見てください。このチュートリアルは、すべての Synology DS プロフェッショナルのためのものです。
## ステップ1：フォルダの作成
まず、Calibreのライブラリ用のフォルダを作ります。  システムコントロール」→「共有フォルダ」を呼び出して、「Books」という新しいフォルダを作ります。
{{< gallery match="images/1/*.png" >}}

## Step 2: Calibreライブラリの作成
ここで、既存のライブラリや「[この空のサンプルライブラリ](https://drive.google.com/file/d/1zfeU7Jh3FO_jFlWSuZcZQfQOGD0NvXBm/view)」を新しいディレクトリにコピーします。私自身は、デスクトップアプリケーションの既存のライブラリをコピーしました。
{{< gallery match="images/2/*.png" >}}

## ステップ3：Dockerイメージの検索
Synology Dockerのウィンドウで「登録」タブをクリックし、「Calibre」を検索します。Dockerイメージ「janeczku/calibre-web」を選択して、「latest」というタグをクリックしています。
{{< gallery match="images/3/*.png" >}}
画像のダウンロード後、画像として利用できます。Dockerでは、コンテナ（動的状態）とimage/イメージ（固定状態）の2つの状態を区別しています。イメージからコンテナを作成する前に、いくつかの設定を行う必要があります。
## ステップ4：イメージを形にして運用する
Calibreの画像をダブルクリックします。
{{< gallery match="images/4/*.png" >}}
そして、「詳細設定」をクリックし、「自動再起動」を有効にします。ボリューム "タブを選択し、"フォルダの追加 "をクリックします。そこで、「/calibre」というマウントパスで新しいデータベースフォルダを作成します。
{{< gallery match="images/5/*.png" >}}
Calibreコンテナには固定ポートを割り当てています。ポートが固定されていないと、再起動後にCalibreが別のポートで動作してしまう可能性があります。
{{< gallery match="images/6/*.png" >}}
これらの設定が終わると、Calibreを起動することができます。
{{< gallery match="images/7/*.png" >}}
Calibreポートが割り当てられたSynology IPを呼び出すと、次のような画像が表示されます。Calibreデータベースの場所」として「/calibre」を入力します。残りの設定は、好みの問題です。
{{< gallery match="images/8/*.png" >}}
デフォルトのログイン名は "admin "で、パスワードは "admin123 "です。
{{< gallery match="images/9/*.png" >}}
できました。もちろん、「ブックフォルダ」経由でデスクトップアプリにも接続できるようになりました。自分のアプリでライブラリを入れ替えて、Nasフォルダを選択しています。
{{< gallery match="images/10/*.png" >}}
こんな感じです。
{{< gallery match="images/11/*.png" >}}
デスクトップアプリケーションでメタ・インフォを編集すると、ウェブアプリケーションでもメタ・インフォが自動的に更新されます。
{{< gallery match="images/12/*.png" >}}