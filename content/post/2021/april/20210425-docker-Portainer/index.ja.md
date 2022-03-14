+++
date = "2021-04-25T09:28:11+01:00"
title = "コンテナの素晴らしさ：Synology Docker GUIの代替としてのPortainer"
difficulty = "level-3"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "watchtower"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210425-docker-Portainer/index.ja.md"
+++

## ステップ1：Synologyの準備
まず、DiskStationでSSHログインを有効にする必要があります。そのためには、「コントロールパネル」→「ターミナル」で
{{< gallery match="images/1/*.png" >}}
そして、「SSH」で指定されたポートと管理者パスワードでログインします（WindowsユーザーはPuttyまたはWinSCPを使用）。
{{< gallery match="images/2/*.png" >}}
Terminal、winSCP、Puttyなどでログインして、このコンソールを後から開くようにしています。
## ステップ2：portainerフォルダの作成
Dockerのディレクトリに「portainer」という新しいディレクトリを作ります。
{{< gallery match="images/3/*.png" >}}
そして、コンソールでportainerディレクトリに行き、そこに「portainer.yml」というフォルダと新しいファイルを作成します。
{{< terminal >}}
cd /volume1/docker/portainer
mkdir portainer_data
vim portainer.yml

{{</ terminal >}}
以下は「portainer.yml」ファイルの内容です。
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
家庭での使用に便利なDockerイメージは、[Dockerverse]({{< ref "dockerverse" >}} "Dockerverse")にもあります。
## Step 3: ポータースタート
また、このステップでは、コンソールをうまく利用することができます。私はDocker Compose経由でportainerサーバーを起動します。
{{< terminal >}}
sudo docker-compose -f portainer.yml up -d

{{</ terminal >}}
そして、ディスクステーションのIPと「ステップ2」で割り当てられたポートを使って、Portainerサーバーを呼び出すことができます。私は管理者のパスワードを入力し、ローカル変数を選択します。
{{< gallery match="images/4/*.png" >}}
ご覧の通り、すべてが素晴らしい出来です。
{{< gallery match="images/5/*.png" >}}