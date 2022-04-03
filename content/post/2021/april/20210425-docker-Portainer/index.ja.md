+++
date = "2021-04-25T09:28:11+01:00"
title = "コンテナで素晴らしいものを：Synology Docker GUI の代替となる Portainer"
difficulty = "level-3"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "watchtower"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210425-docker-Portainer/index.ja.md"
+++

## ステップ1：Synologyを準備する
まず、DiskStationでSSHログインを有効にする必要があります。そのためには、「コントロールパネル」→「ターミナル」を開きます。
{{< gallery match="images/1/*.png" >}}
そして、「SSH」、指定されたポート、管理者パスワードでログインします（WindowsユーザーはPuttyまたはWinSCPを使用します）。
{{< gallery match="images/2/*.png" >}}
ターミナル、winSCP、Puttyでログインして、このコンソールを開いたままにしておくと、後で便利です。
## ステップ2：portainerフォルダの作成
Dockerディレクトリの中に「portainer」というディレクトリを新規に作成します。
{{< gallery match="images/3/*.png" >}}
そして、コンソールでportainerディレクトリに行き、そこに「portainer.yml」というフォルダとファイルを新規に作成するのです。
{{< terminal >}}
cd /volume1/docker/portainer
mkdir portainer_data
vim portainer.yml

{{</ terminal >}}
以下は、「portainer.yml」ファイルの内容です。
```
version: '3'

services:
  portainer:
    image: portainer/portainer:latest
    container_name: portainer
    restart: always
    ports:
      - 90070:9000
      - 9090:8000
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - ./portainer_data:/data

```
家庭で使える便利なDockerイメージは、[ドッカーバース]({{< ref "dockerverse" >}} "ドッカーバース").Dockerにあります。
## ステップ3：ポーテナ開始
このステップでは、コンソールもうまく活用できるんだ。Docker Composeでportainerサーバを起動させています。
{{< terminal >}}
sudo docker-compose -f portainer.yml up -d

{{</ terminal >}}
そして、ディスクステーションのIPと「ステップ2」で割り当てたポートで、Portainerサーバーを呼び出すことができます。管理者パスワードを入力し、ローカルバリアントを選択しています。
{{< gallery match="images/4/*.png" >}}
ご覧のとおり、すべてがうまくいっています。
{{< gallery match="images/5/*.png" >}}
