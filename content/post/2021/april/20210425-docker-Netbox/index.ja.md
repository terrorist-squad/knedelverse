+++
date = "2021-04-25T09:28:11+01:00"
title = "コンテナで素晴らしいものを: Synology 上の Netbox - Diskstation"
difficulty = "level-3"
tags = ["Computernetzwerken", "DCIM", "Docker", "docker-compose", "IPAM", "netbox", "Synology", "netwerk"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210425-docker-Netbox/index.ja.md"
+++
NetBoxは、コンピュータネットワークの管理に使用されるフリーソフトウェアです。今日は、Synology DiskStation に Netbox サービスをインストールする方法を紹介します。
## ステップ1：Synologyを準備する
まず、DiskStationでSSHログインを有効にする必要があります。そのためには、「コントロールパネル」→「ターミナル」を開きます。
{{< gallery match="images/1/*.png" >}}
そして、「SSH」、指定されたポート、管理者パスワードでログインします（WindowsユーザーはPuttyまたはWinSCPを使用します）。
{{< gallery match="images/2/*.png" >}}
ターミナル、winSCP、Puttyでログインして、このコンソールを開いたままにしておくと、後で便利です。
## ステップ2：NETBOXフォルダの作成
Dockerディレクトリの中に「netbox」というディレクトリを新規に作成します。
{{< gallery match="images/3/*.png" >}}
ここで、以下のファイルをダウンロードし、ディレクトリに解凍する必要があります：https://github.com/netbox-community/netbox-docker/archive/refs/heads/release.zip。私はこのためにコンソールを使っています。
{{< terminal >}}
cd /volume1/docker/netbox/
sudo wget https://github.com/netbox-community/netbox-docker/archive/refs/heads/release.zip
sudo /bin/7z x release.zip
cd netbox-docker-release
sudo mkdir netbox-media-files
sudo mkdir netbox-redis-data
sudo mkdir netbox-postgres-data

{{</ terminal >}}
そして「docker/docker-compose.yml」ファイルを編集し、「netbox-media-files」、「netbox-postgres-data」、「netbox-redis-data」に自分のSynologyアドレスを入力するのです。
```
version: '3.4'
services:
  netbox: 
    image: netboxcommunity/netbox:${VERSION-v3.1-1.6.0}
    depends_on:
    - postgres
    - redis
    - redis-cache
    - netbox-worker
    env_file: env/netbox.env
    user: 'unit:root'
    volumes:
    - ./startup_scripts:/opt/netbox/startup_scripts:z,ro
    - ./initializers:/opt/netbox/initializers:z,ro
    - ./configuration:/etc/netbox/config:z,ro
    - ./reports:/etc/netbox/reports:z,ro
    - ./scripts:/etc/netbox/scripts:z,ro
    - ./netbox-media-files:/opt/netbox/netbox/media:z
    ports:
    - "8097:8080"
    
  netbox-worker:
    image: netboxcommunity/netbox:${VERSION-v3.1-1.6.0}
    env_file: env/netbox.env
    user: 'unit:root'
    depends_on:
    - redis
    - postgres
    command:
    - /opt/netbox/venv/bin/python
    - /opt/netbox/netbox/manage.py
    - rqworker

  netbox-housekeeping:
    image: netboxcommunity/netbox:${VERSION-v3.1-1.6.0}
    env_file: env/netbox.env
    user: 'unit:root'
    depends_on:
    - redis
    - postgres
    command:
    - /opt/netbox/housekeeping.sh

  # postgres
  postgres:
    image: postgres:14-alpine
    env_file: env/postgres.env
    volumes:
    - ./netbox-postgres-data:/var/lib/postgresql/data

  # redis
  redis:
    image: redis:6-alpine
    command:
    - sh
    - -c # this is to evaluate the $REDIS_PASSWORD from the env
    - redis-server --appendonly yes --requirepass $$REDIS_PASSWORD ## $$ because of docker-compose
    env_file: env/redis.env
    volumes:
    - ./netbox-redis-data:/data

  redis-cache:
    image: redis:6-alpine
    command:
    - sh
    - -c # this is to evaluate the $REDIS_PASSWORD from the env
    - redis-server --requirepass $$REDIS_PASSWORD ## $$ because of docker-compose
    env_file: env/redis-cache.env


```
継承することが非常に重要です。"<<:*netbox "を置き換えて、"netbox "用のポートを入力すると、Composeファイルが起動できるようになります。
{{< terminal >}}
sudo docker-compose up

{{</ terminal >}}
データベースの作成に時間がかかる場合があります。この挙動は、コンテナの詳細を介して観察することができます。
{{< gallery match="images/4/*.png" >}}
SynologyのIPアドレスと私のコンテナポートでnetboxサーバーを呼び出します。
{{< gallery match="images/5/*.png" >}}
