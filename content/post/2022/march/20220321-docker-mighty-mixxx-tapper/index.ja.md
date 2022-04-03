+++
date = "2022-03-21"
title = "コンテナで素敵なこと：ラジオからMP3を録音する"
difficulty = "level-1"
tags = ["diskstation", "Docker", "docker-compose", "docker-for-desktop", "radio", "mp3", "ripp", "streamripper", "radiorecorder"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2022/march/20220321-docker-mighty-mixxx-tapper/index.ja.md"
+++
Streamripperは、MP3やOGG/Vorbisのストリームを録音して、直接ハードディスクに保存することができるコマンドライン用のツールです。曲は自動的にアーティスト名を付けて個別に保存され、形式は最初に送信されたものになります（したがって実質的には.mp3または.oggという拡張子のファイルが作成されます）。私は素晴らしいradiorecorderのインターフェースを見つけ、そこからDockerイメージを構築しました。参照: https://github.com/terrorist-squad/mightyMixxxTapper/
{{< gallery match="images/1/*.png" >}}

## プロフェッショナル向けオプション
経験豊富な Synology ユーザーであれば、もちろん SSH でログインし、Docker Compose ファイルを介してセットアップ全体をインストールすることができます。
```
version: "2.0"
services:
  mealie:
    container_name: mighty-mixxx-tapper
    image: chrisknedel/mighty-mixxx-tapper:latest
    restart: always
    ports:
      - 9000:80
    environment:
      TZ: Europa/Berlin
    volumes:
      - ./ripps/:/tmp/ripps/

```

## ステップ1：Dockerイメージの検索
Synology Dockerウィンドウの「登録」タブをクリックし、「mighty-mixxx-tapper」を検索しています。Dockerイメージ「chrisknedel/mighty-mixxx-tapper」を選択し、「latest」タグをクリックしています。
{{< gallery match="images/2/*.png" >}}
画像ダウンロード後、画像として利用可能です。Dockerでは、コンテナ（動的状態）とイメージ/画像（固定状態）の2つの状態を区別しています。イメージからコンテナを作成する前に、いくつかの設定を行う必要があります。
## ステップ2：画像を運用に乗せる
私の「mighty-mixxx-tapper」画像をダブルクリックする。
{{< gallery match="images/3/*.png" >}}
そして、「詳細設定」をクリックして「自動再起動」を有効にしています。ボリューム」タブを選択し、「フォルダの追加」をクリックしています。そこで、このマウントパス「/tmp/ripps/」で新しいフォルダを作成します。
{{< gallery match="images/4/*.png" >}}
mighty-mixxx-tapper」コンテナには、固定ポートを割り当てています。固定ポートがないと、再起動後に「mighty-mixxx-tapper-server」が別のポートで動作している可能性があります。
{{< gallery match="images/5/*.png" >}}
以上の設定で、mighty-mixxx-tapper-server が起動できるようになります!その後、Synology disctationのIPアドレスと割り当てられたポート（例：http://192.168.21.23:8097）を介してmighty-mixxx-tapperを呼び出すことができます。
{{< gallery match="images/6/*.png" >}}
