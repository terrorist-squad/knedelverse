+++
date = "2021-04-18"
title = "コンテナの優れた点：Synology DiskStationでのDocspell DMSの実行"
difficulty = "level-2"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "Document-Managment-System"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/april/20210418-docker-Docspell/index.ja.md"
+++
Docspellは、Synology DiskStation用のドキュメント管理システムです。Docspellを使うことで、文書の索引付け、検索、発見が格段に早くなります。今日は、SynologyのディスクステーションにDocspellサービスをインストールする方法を紹介します。
## ステップ1：Synologyの準備
まず、DiskStationでSSHログインを有効にする必要があります。そのためには、「コントロールパネル」→「ターミナル」で
{{< gallery match="images/1/*.png" >}}
そして、「SSH」で指定されたポートと管理者パスワードでログインします（WindowsユーザーはPuttyまたはWinSCPを使用）。
{{< gallery match="images/2/*.png" >}}
Terminal、winSCP、Puttyなどでログインして、このコンソールを後から開くようにしています。
## ステップ2：Docspelフォルダの作成
Dockerのディレクトリに「docspell」という新しいディレクトリを作ります。
{{< gallery match="images/3/*.png" >}}
ここで、次のファイルをダウンロードし、ディレクトリに解凍する必要があります。https://github.com/eikek/docspell/archive/refs/heads/master.zip .これにはコンソールを使います。
{{< terminal >}}
cd /volume1/docker/docspell/
mkdir docs
mkdir postgres_data
wget https://github.com/eikek/docspell/archive/refs/heads/master.zip 
/bin/7z x master.zip

{{</ terminal >}}
そして、「docker/docker-compose.yml」ファイルを編集し、「consumedir」と「db」にSynologyのアドレスを入力します。
{{< gallery match="images/4/*.png" >}}
その後、Composeファイルを起動します。
{{< terminal >}}
cd docspell-master/docker/
docker-compose up -d

{{</ terminal >}}
数分後、ディスクステーションのIPと割り当てられたポート/7878を使って、Docspellサーバを呼び出すことができます。
{{< gallery match="images/5/*.png" >}}
