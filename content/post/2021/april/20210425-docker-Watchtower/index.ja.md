+++
date = "2021-04-25T09:28:11+01:00"
title = "短編：Watchtowerでコンテナを自動更新する"
difficulty = "level-2"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "watchtower"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210425-docker-Watchtower/index.ja.md"
+++
ディスクステーションでDockerコンテナを動作させる場合、当然ながら常に最新の状態であることが望まれます。Watchtower はイメージとコンテナを自動的に更新します。そうすることで、最新の機能と最新のデータセキュリティを享受することができるのです。今日は、Synology disk stationにWatchtowerをインストールする方法を紹介します。
## ステップ1：Synologyを準備する
まず、DiskStationでSSHログインを有効にする必要があります。そのためには、「コントロールパネル」→「ターミナル」を開きます。
{{< gallery match="images/1/*.png" >}}
そして、「SSH」、指定されたポート、管理者パスワードでログインします（WindowsユーザーはPuttyまたはWinSCPを使用します）。
{{< gallery match="images/2/*.png" >}}
ターミナル、winSCP、Puttyでログインして、このコンソールを開いたままにしておくと、後で便利です。
## ステップ2：Watchtowerのインストール
私はこのためにコンソールを使っています。
{{< terminal >}}
docker run --name watchtower --restart always -v /var/run/docker.sock:/var/run/docker.sock containrrr/watchtower

{{</ terminal >}}
その後、Watchtowerは常にバックグラウンドで動作しています。
{{< gallery match="images/3/*.png" >}}

