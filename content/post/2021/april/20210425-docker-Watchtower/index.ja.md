+++
date = "2021-04-25T09:28:11+01:00"
title = "ショートストーリー：Watchtowerでコンテナを自動的に更新する"
difficulty = "level-2"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "watchtower"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210425-docker-Watchtower/index.ja.md"
+++
ディスクステーションでDockerコンテナを運用している場合、当然ながら常に最新の状態にしておきたいものです。Watchtowerは、イメージやコンテナを自動的にアップデートします。これにより、最新の機能と最新のデータセキュリティを享受することができます。今日は、SynologyのディスクステーションにWatchtowerをインストールする方法をご紹介します。
## ステップ1：Synologyの準備
まず、DiskStationでSSHログインを有効にする必要があります。そのためには、「コントロールパネル」→「ターミナル」で
{{< gallery match="images/1/*.png" >}}
そして、「SSH」で指定されたポートと管理者パスワードでログインします（WindowsユーザーはPuttyまたはWinSCPを使用）。
{{< gallery match="images/2/*.png" >}}
Terminal、winSCP、Puttyなどでログインして、このコンソールを後から開くようにしています。
## Step 2: Watchtowerのインストール
これにはコンソールを使います。
{{< terminal >}}
docker run --name watchtower --restart always -v /var/run/docker.sock:/var/run/docker.sock containrrr/watchtower

{{</ terminal >}}
その後、Watchtowerは常にバックグラウンドで動作します。
{{< gallery match="images/3/*.png" >}}
