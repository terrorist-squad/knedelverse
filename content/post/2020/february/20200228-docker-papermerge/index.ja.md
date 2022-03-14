+++
date = "2020-02-28"
title = "コンテナで実現すること：Papermerge DMSをSynology NASで動かす"
difficulty = "level-3"
tags = ["archiv", "automatisch", "dms", "Docker", "Document-Managment-System", "google", "ocr", "papermerge", "Synology", "tesseract", "texterkennung"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2020/february/20200228-docker-papermerge/index.ja.md"
+++
Papermergeは、ドキュメントを自動的に割り当てて処理することができる若いドキュメント管理システム（DMS）です。このチュートリアルでは、PapermergeをSynologyのディスクステーションにインストールした方法と、DMSがどのように機能するかを紹介します。
## プロフェッショナルのためのオプション
経験豊富なSynologyユーザーであれば、もちろんSSHでログインし、Docker Composeファイルでセットアップ全体をインストールすることができます。
```
version: "2.1"
services:
  papermerge:
    image: ghcr.io/linuxserver/papermerge
    container_name: papermerge
    environment:
      - PUID=1024
      - PGID=100
      - TZ=Europe/Berlin
    volumes:
      - ./config>:/config
      - ./appdata/data>:/data
    ports:
      - 8090:8000
    restart: unless-stopped

```

## ステップ1：フォルダの作成
まず、ペーパーマージ用のフォルダを作ります。システムコントロール」→「共有フォルダ」で、「Document Archive」という新しいフォルダを作ります。
{{< gallery match="images/1/*.png" >}}
ステップ2：Dockerイメージの検索Synology Dockerウィンドウの「登録」タブをクリックし、「Papermerge」を検索します。linuxserver/papermerge」というDockerイメージを選択して、「latest」というタグをクリックしています。
{{< gallery match="images/2/*.png" >}}
画像のダウンロード後、画像として利用できます。Dockerでは、コンテナ（動的状態）とimage/イメージ（固定状態）の2つの状態を区別しています。イメージからコンテナを作成する前に、いくつかの設定を行う必要があります。
## ステップ3：イメージを形にして運用する
私は、ペーパーマージ画像をダブルクリックします。
{{< gallery match="images/3/*.png" >}}
そして、「詳細設定」をクリックし、「自動再起動」を有効にします。ボリューム "タブを選択し、"フォルダの追加 "をクリックします。そこで、「/data」というマウントパスで新しいデータベースフォルダを作成します。
{{< gallery match="images/4/*.png" >}}
また、ここには2つ目のフォルダを保存し、マウントパス「/config」に含めています。このフォルダがどこにあるかは重要ではありません。ただし、それがSynology adminユーザーに属していることが重要です。
{{< gallery match="images/5/*.png" >}}
Papermerge "コンテナには固定ポートを割り当てています。ポートが固定されていないと、再起動後に「Papermergeサーバー」が別のポートで動作してしまう可能性があります。
{{< gallery match="images/6/*.png" >}}
最後に、3つの環境変数を入力します。PUIDはユーザーID、PGIDはadminユーザーのグループIDです。PGID/PUIDは、SSHで「cat /etc/passwd | grep admin」というコマンドで調べることができます。
{{< gallery match="images/7/*.png" >}}
これらの設定が終われば、Papermergeのサーバーを起動することができます。その後、Papermergeは、Synology disctationのIPアドレスと割り当てられたポート(例：http://192.168.21.23:8095)を介して呼び出すことができます。
{{< gallery match="images/8/*.png" >}}
デフォルトのログイン名はadmin、パスワードはadminです。
## Papermergeの仕組みを教えてください。
Papermergeは、文書や画像のテキストを解析します。Papermergeでは、Goolge社が公開しているtesseractというOCR/「光学式文字認識」ライブラリを使用しています。
{{< gallery match="images/9/*.png" >}}
ドキュメントの自動割り当てをテストするために、「Everything with Lorem」というフォルダを作りました。そして、メニューの「自動化」で新しい認識パターンをまとめてクリックしました。
{{< gallery match="images/10/*.png" >}}
単語「Lorem」を含むすべての新しいドキュメントは、「Everything with Lorem」フォルダに置かれ、「has-lorem」というタグが付けられます。タグの中にコンマを入れることが重要で、そうしないとタグは設定されません。対応するドキュメントをアップロードすると、タグ付けされてソートされます。
{{< gallery match="images/11/*.png" >}}