+++
date = "2021-04-25T09:28:11+01:00"
title = "コンテナの優れた点：Synology上のNetbox - Disk"
difficulty = "level-3"
tags = ["Computernetzwerken", "DCIM", "Docker", "docker-compose", "IPAM", "netbox", "Synology", "netwerk"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210425-docker-Netbox/index.ja.md"
+++
NetBoxは、コンピュータネットワークの管理に使用されるフリーソフトウェアです。今日は、Synology DiskStationにNetboxサービスをインストールする方法をご紹介します。
## ステップ1：Synologyの準備
まず、DiskStationでSSHログインを有効にする必要があります。そのためには、「コントロールパネル」→「ターミナル」で
{{< gallery match="images/1/*.png" >}}
そして、「SSH」で指定されたポートと管理者パスワードでログインします（WindowsユーザーはPuttyまたはWinSCPを使用）。
{{< gallery match="images/2/*.png" >}}
Terminal、winSCP、Puttyなどでログインして、このコンソールを後から開くようにしています。
## ステップ2：NETBOXフォルダの作成
Dockerのディレクトリに「netbox」という新しいディレクトリを作ります。
{{< gallery match="images/3/*.png" >}}
ここで、次のファイルをダウンロードして、ディレクトリに解凍する必要があります。https://github.com/netbox-community/netbox-docker/archive/refs/heads/release.zip。これにはコンソールを使います。
{{< terminal >}}
cd /volume1/docker/netbox/
sudo wget https://github.com/netbox-community/netbox-docker/archive/refs/heads/release.zip
sudo /bin/7z x release.zip
cd netbox-docker-release
sudo mkdir netbox-media-files
sudo mkdir netbox-redis-data
sudo mkdir netbox-postgres-data

{{</ terminal >}}
そして、「docker/docker-compose.yml」ファイルを編集し、「netbox-media-files」、「netbox-postgres-data」、「netbox-redis-data」に私のSynologyアドレスを入力します。
```
version: '3.4'
services:
  netbox: &netbox
    image: netboxcommunity/netbox:${VERSION-latest}
    depends_on:
    - postgres
    - redis
    - redis-cache
    - netbox-worker
    env_file: env/netbox.env
    user: '101'
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
    <<: *netbox
    depends_on:
    - redis
    entrypoint:
    - /opt/netbox/venv/bin/python
    - /opt/netbox/netbox/manage.py
    command:
    - rqworker
    ports: []

  # postgres
  postgres:
    image: postgres:12-alpine
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
その後、Composeファイルを起動します。
{{< terminal >}}
sudo docker-compose up

{{</ terminal >}}
データベースの作成には時間がかかる場合があります。この動作は、コンテナの詳細から確認できます。
{{< gallery match="images/4/*.png" >}}
SynologyのIPアドレスと私のコンテナポートを使ってnetboxサーバーに電話をかけます。
{{< gallery match="images/5/*.png" >}}