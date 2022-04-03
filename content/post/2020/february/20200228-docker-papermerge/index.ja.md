+++
date = "2020-02-28"
title = "コンテナで素晴らしいものを：Synology NAS 上での Papermerge DMS の実行"
difficulty = "level-3"
tags = ["archiv", "automatisch", "dms", "Docker", "Document-Managment-System", "google", "ocr", "papermerge", "Synology", "tesseract", "texterkennung"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2020/february/20200228-docker-papermerge/index.ja.md"
+++
Papermergeは、文書を自動的に割り当てて処理することができる若い文書管理システム（DMS）です。このチュートリアルでは、Synology disk stationにPapermergeをインストールする方法と、DMSがどのように機能するかを紹介します。
## プロフェッショナル向けオプション
経験豊富な Synology ユーザーであれば、もちろん SSH でログインし、Docker Compose ファイルを介してセットアップ全体をインストールすることができます。
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
まず、ペーパーマージ用のフォルダを作成します。システムコントロール」→「共有フォルダ」で、「ドキュメントアーカイブ」というフォルダを新規に作成しました。
{{< gallery match="images/1/*.png" >}}
ステップ 2: Docker イメージの検索Synology Docker ウィンドウの「登録」タブをクリックし、「Papermerge」を検索してください。Dockerイメージ「linuxserver/papermerge」を選択し、「latest」タグをクリックしています。
{{< gallery match="images/2/*.png" >}}
画像ダウンロード後、画像として利用可能です。Dockerでは、コンテナ（動的状態）とイメージ/画像（固定状態）の2つの状態を区別しています。イメージからコンテナを作成する前に、いくつかの設定を行う必要があります。
## ステップ3：画像を運用に乗せる。
ペーパーマージ画像をダブルクリックする。
{{< gallery match="images/3/*.png" >}}
そして、「詳細設定」をクリックして「自動再起動」を有効にしています。ボリューム」タブを選択し、「フォルダの追加」をクリックしています。そこで、このマウントパス「/data」で新しいデータベースフォルダを作成します。
{{< gallery match="images/4/*.png" >}}
また、マウントパス「/config」に含まれる2つ目のフォルダもここに保存しています。このフォルダがどこにあるかは、あまり重要ではありません。ただし、Synology管理者ユーザーに属していることが重要です。
{{< gallery match="images/5/*.png" >}}
Papermerge」コンテナには、固定ポートを割り当てています。固定ポートがないと、再起動後に「Papermergeサーバー」が別のポートで動作している可能性があります。
{{< gallery match="images/6/*.png" >}}
最後に、3つの環境変数を入力する。変数 "PUID "は私の管理ユーザーのユーザーID、"PGID "はグループIDです。PGID/PUID は、SSH 経由で「cat /etc/passwd | grep admin」コマンドで調べることができます。
{{< gallery match="images/7/*.png" >}}
これらの設定後、Papermergeサーバーを起動することができます!その後、Papermerge は Synology disctation の Ip アドレスと割り当てられたポート（例：http://192.168.21.23:8095）を介して呼び出すことができます。
{{< gallery match="images/8/*.png" >}}
デフォルトのログインはadmin、パスワードはadminです。
## Papermergeの仕組みは？
Papermergeは、文書や画像のテキストを解析します。Papermergeは、Goolge社が公開しているtesseractというOCR/「光学式文字認識」ライブラリを使用しています。
{{< gallery match="images/9/*.png" >}}
ドキュメントの自動割り当てをテストするために、「Everything with Lorem」というフォルダを作りました。そして、メニューの「自動化」で新しい認識パターンを一緒にクリックしました。
{{< gallery match="images/10/*.png" >}}
Lorem "という単語を含むすべての新しい文書は、"Everything with Lorem "というフォルダーに入れられ、"has-lorem "というタグが付けられます。タグにカンマを使用することが重要で、そうしないとタグが設定されません。ドキュメントをアップロードすると、タグ付けされ、ソートされます。
{{< gallery match="images/11/*.png" >}}
