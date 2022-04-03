+++
date = "2021-04-18"
title = "コンテナで素晴らしいものを：Synology DiskStation で Docspell DMS を実行する"
difficulty = "level-2"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "Document-Managment-System"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210418-docker-Docspell/index.ja.md"
+++
Docspell は、Synology DiskStation 用の文書管理システムです。Docspellを通じて、ドキュメントの索引付け、検索、発見をより迅速に行うことができます。今日は、Synology disk station に Docspell サービスをインストールする方法を紹介します。
## ステップ1：Synologyを準備する
まず、DiskStationでSSHログインを有効にする必要があります。そのためには、「コントロールパネル」→「ターミナル」を開きます。
{{< gallery match="images/1/*.png" >}}
そして、「SSH」、指定されたポート、管理者パスワードでログインします（WindowsユーザーはPuttyまたはWinSCPを使用します）。
{{< gallery match="images/2/*.png" >}}
ターミナル、winSCP、Puttyでログインして、このコンソールを開いたままにしておくと、後で便利です。
## ステップ2：Docspelフォルダの作成
Dockerのディレクトリに「docspell」というディレクトリを新規に作成します。
{{< gallery match="images/3/*.png" >}}
ここで、以下のファイルをダウンロードし、ディレクトリに解凍する必要があります： https://github.com/eikek/docspell/archive/refs/heads/master.zip .私はこのためにコンソールを使っています。
{{< terminal >}}
cd /volume1/docker/docspell/
mkdir docs
mkdir postgres_data
wget https://github.com/eikek/docspell/archive/refs/heads/master.zip 
/bin/7z x master.zip

{{</ terminal >}}
次に「docker/docker-compose.yml」ファイルを編集して、「consumeredir」と「db」にSynologyのアドレスを入力します。
{{< gallery match="images/4/*.png" >}}
その後、Composeファイルを起動することができます。
{{< terminal >}}
cd docspell-master/docker/
docker-compose up -d

{{</ terminal >}}
数分後、ディスクステーションのIPと割り当てられたポート/7878で、私のDocspellサーバーを呼び出すことができます。
{{< gallery match="images/5/*.png" >}}
資料の検索がうまくいく。画像中のテキストがインデックス化されていないのは残念です。Papermergeでは、画像中のテキストを検索することも可能です。
