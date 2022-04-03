+++
date = "2020-02-27"
title = "コンテナですごいこと：Synology DiskstationでYoutubeダウンローダーを動かしてみる"
difficulty = "level-1"
tags = ["Docker", "docker-compose", "download", "linux", "Synology", "video", "youtube"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2020/february/20200227-docker-youtube-dl/index.ja.md"
+++
私が「Homelab - Network」でプライベート学習用ビデオポータルを運営していることは、多くの友人が知っていることです。過去の学習ポータル会員からのビデオコースや、Youtubeの優れたチュートリアルをNASに保存し、オフラインで使えるようにしています。
{{< gallery match="images/1/*.png" >}}
これまでに8845のビデオコース、282616の個別ビデオを収集しました。合計で約2年のランニングタイムとなります。絶対におかしい！このチュートリアルでは、オフラインの目的のためにDockerダウンロードサービスを使用して、良いYoutubeチュートリアルをバックアップする方法を紹介します。
## プロフェッショナル向けオプション
経験豊富な Synology ユーザーであれば、もちろん SSH でログインし、Docker Compose ファイルを介してセットアップ全体をインストールすることができます。
```
version: "2"
services:
  youtube-dl:
    image: modenaf360/youtube-dl-nas
    container_name: youtube-dl
    environment:
      - MY_ID=admin
      - MY_PW=admin
    volumes:
      - ./YouTube:/downfolder
    ports:
      - 8080:8080
    restart: unless-stopped

```

## ステップ1
まず、ダウンロード用のフォルダを作成します。システムコントロール」→「共有フォルダ」で、「ダウンロード」というフォルダを新規に作成しました。
{{< gallery match="images/2/*.png" >}}

## ステップ2：Dockerイメージの検索
Synology Dockerウィンドウの「登録」タブをクリックし、「youtube-dl-nas」を検索しています。Dockerイメージ「modenaf360/youtube-dl-nas」を選択し、「latest」タグをクリックしています。
{{< gallery match="images/3/*.png" >}}
画像ダウンロード後、画像として利用可能です。Dockerでは、コンテナ（動的状態）とイメージ/画像（固定状態）の2つの状態を区別しています。イメージからコンテナを作成する前に、いくつかの設定を行う必要があります。
## ステップ3：画像を運用に乗せる。
自分のyoutube-dl-nasの画像をダブルクリックする。
{{< gallery match="images/4/*.png" >}}
そして、「詳細設定」をクリックして「自動再起動」を有効にしています。ボリューム」タブを選択し、「フォルダの追加」をクリックしています。そこで、マウントパス「/downfolder」で新しいデータベースフォルダを作成します。
{{< gallery match="images/5/*.png" >}}
Youtube Downloader」コンテナには、固定ポートを割り当てています。固定ポートがないと、再起動後に「Youtubeダウンローダー」が別のポートで動作してしまう可能性があります。
{{< gallery match="images/6/*.png" >}}
最後に、2つの環境変数を入力します。変数「MY_ID」は私のユーザー名で、「MY_PW」は私のパスワードです。
{{< gallery match="images/7/*.png" >}}
これらの設定が終わると、Downloaderが起動します。その後、Synology disctation の IP アドレスと割り当てられたポート（例：http://192.168.21.23:8070）を介してダウンローダーを呼び出すことができます。
{{< gallery match="images/8/*.png" >}}
認証には、MY_ID、MY_PWからユーザー名とパスワードを取ります。
## Step 4: さあ、行こう
Youtube ビデオとプレイリストの URL を「URL」フィールドに入力すると、すべてのビデオが自動的に Synology disk station のダウンロードフォルダに保存されるようになりました。
{{< gallery match="images/9/*.png" >}}
ダウンロードフォルダです。
{{< gallery match="images/10/*.png" >}}
