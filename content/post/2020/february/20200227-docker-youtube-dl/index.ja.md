+++
date = "2020-02-27"
title = "コンテナの優れた点：Synology DiskstationでのYoutubeダウンローダーの実行"
difficulty = "level-1"
tags = ["Docker", "docker-compose", "download", "linux", "Synology", "video", "youtube"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2020/february/20200227-docker-youtube-dl/index.ja.md"
+++
私の友人の多くは、私がHomelab - Networkでプライベートな学習ビデオポータルを運営していることを知っています。過去に学習ポータルの会員になっていたビデオコースや、Youtubeの優れたチュートリアルをNASに保存してオフラインで使用しています。
{{< gallery match="images/1/*.png" >}}
これまでに、8845のビデオコースと282616の個別ビデオを集めました。トータルで約2年間の使用が可能です。このチュートリアルでは、Dockerのダウンロードサービスを使って、Youtubeのチュートリアルをオフラインでバックアップする方法を紹介します。
## プロフェッショナルのためのオプション
経験豊富なSynologyユーザーであれば、もちろんSSHでログインし、Docker Composeファイルでセットアップ全体をインストールすることができます。
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
まず、ダウンロード用のフォルダを作ります。システムコントロール」→「共有フォルダ」で、「ダウンロード」という新しいフォルダを作ります。
{{< gallery match="images/2/*.png" >}}

## ステップ2：Dockerイメージの検索
Synology Dockerのウィンドウで「登録」タブをクリックし、「youtube-dl-nas」を検索します。私はDockerイメージ「modenaf360/youtube-dl-nas」を選択し、「latest」というタグをクリックしています。
{{< gallery match="images/3/*.png" >}}
画像のダウンロード後、画像として利用できます。Dockerでは、コンテナ（動的状態）とimage/イメージ（固定状態）の2つの状態を区別しています。イメージからコンテナを作成する前に、いくつかの設定を行う必要があります。
## ステップ3：イメージを形にして運用する
私のyoutube-dl-nasの画像をダブルクリックします。
{{< gallery match="images/4/*.png" >}}
そして、「詳細設定」をクリックし、「自動再起動」を有効にします。ボリューム "タブを選択し、"フォルダの追加 "をクリックします。そこで、「/downfolder」というマウントパスで新しいデータベースフォルダを作成します。
{{< gallery match="images/5/*.png" >}}
Youtube Downloader "コンテナには固定のポートを割り当てています。ポートが固定されていないと、再起動後に「Youtubeダウンローダー」が別のポートで動作してしまう可能性があります。
{{< gallery match="images/6/*.png" >}}
最後に、2つの環境変数を入力します。変数「MY_ID」は私のユーザー名、「MY_PW」は私のパスワードです。
{{< gallery match="images/7/*.png" >}}
以上の設定でDownloaderが起動します。その後、Synology disctationのIPアドレスと割り当てられたポート(例：http://192.168.21.23:8070)を介してダウンローダーに電話をかけることができます。
{{< gallery match="images/8/*.png" >}}
認証には、MY_IDとMY_PWからユーザー名とパスワードを取ります。
## Step 4: Let's go
Youtube ビデオの URL とプレイリストの URL を「URL」フィールドに入力すると、すべてのビデオが Synology ディスクステーションのダウンロードフォルダに自動的に格納されます。
{{< gallery match="images/9/*.png" >}}
ダウンロードフォルダです。
{{< gallery match="images/10/*.png" >}}