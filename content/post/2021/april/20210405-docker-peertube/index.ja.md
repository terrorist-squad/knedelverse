+++
date = "2021-04-05"
title = "コンテナを利用した優れた取り組み：PeerTubeによる独自のビデオポータル"
difficulty = "level-1"
tags = ["diskstation", "peertube", "Synology", "video", "videoportal"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210405-docker-peertube/index.ja.md"
+++
Peertubeでは、自分だけの動画ポータルを作ることができます。今日は、SynologyのディスクステーションにPeertubeをインストールした様子をご紹介します。
## ステップ1：Synologyの準備
まず、DiskStationでSSHログインを有効にする必要があります。そのためには、「コントロールパネル」→「ターミナル」で
{{< gallery match="images/1/*.png" >}}
そして、「SSH」で指定されたポートと管理者パスワードでログインします。
{{< gallery match="images/2/*.png" >}}
Terminal、winSCP、Puttyなどでログインして、このコンソールを後から開くようにしています。
## ステップ2：Dockerフォルダの準備
Dockerのディレクトリに「Peertube」という新しいディレクトリを作ります。
{{< gallery match="images/3/*.png" >}}
そして、Peertubeのディレクトリに入り、以下の内容で「peertube.yml」というファイルを新規に作成します。ポートでは、フロント部分の「9000：」を調整することができます。2つ目のボリュームには、すべてのビデオ、プレイリスト、サムネイルなどが含まれているため、適応する必要があります。
```
version: "3.7"

services:
  peertube:
    image: chocobozzz/peertube:contain-buster
    container_name: peertube_peertube
    ports:
       - "9000:9000"
    volumes:
      - ./config:/config
      - ./videos:/data
    environment:
      - TZ="Europe/Berlin"
      - PT_INITIAL_ROOT_PASSWORD=password
      - PEERTUBE_WEBSERVER_HOSTNAME=ip
      - PEERTUBE_WEBSERVER_PORT=port
      - PEERTUBE_WEBSERVER_HTTPS=false
      - PEERTUBE_DB_USERNAME=peertube
      - PEERTUBE_DB_PASSWORD=peertube
      - PEERTUBE_DB_HOSTNAME=postgres
      - POSTGRES_DB=peertube
      - POSTGRES_USER=postgres
      - POSTGRES_PASSWORD=postgres
      - PEERTUBE_REDIS_HOSTNAME=redis
      - PEERTUBE_ADMIN_EMAIL=himself@christian-knedel.de
    depends_on:
      - postgres
      - redis
    restart: "always"
    networks:
      - peertube

  postgres:
    restart: always
    image: postgres:12
    container_name: peertube_postgres
    volumes:
      - ./postgresql:/var/lib/postgresql/data
    environment:
      - POSTGRES_USER=peertube
      - POSTGRES_PASSWORD=peertube
      - POSTGRES_DB=peertube
    networks:
      - peertube

  redis:
    image: redis:4-alpine
    container_name: peertube_redis
    volumes:
      - ./redis:/data
    restart: "always"
    networks:
      - peertube
    expose:
      - "6379"

networks:
  peertube:

```
このファイルはDocker Composeで起動します。
{{< terminal >}}
sudo docker-compose -f compose-file-name.yml up -d

{{</ terminal >}}
その後、「ステップ2」で設定したディスクステーションのIPと割り当てられたポートを使って、Peertubeサーバーを呼び出すことができます。最高ですね。
{{< gallery match="images/4/*.png" >}}
ユーザー名は "root"、パスワードは "password"（または手順2 / PT_INITIAL_ROOT_PASSWORD）となります。
## テーマのカスタマイズ
Peertubeの外観をカスタマイズするのはとても簡単です。そのためには、「管理」→「設定」→「詳細設定」をクリックします。
{{< gallery match="images/5/*.png" >}}
そこで、CSS欄に以下のように入力しました。
```
body#custom-css {
--mainColor: #3598dc;
--mainHoverColor: #3598dc;
--mainBackgroundColor: #FAFAFA;
--mainForegroundColor: #888888;
--menuBackgroundColor: #f5f5f5;
--menuForegroundColor: #888888;
--submenuColor: #fff;
--inputColor: #fff;
--inputPlaceholderColor: #898989;
}

```

## Rest API
PeerTubeは、広範囲で文書化されたRest APIを備えています。https://docs.joinpeertube.org/api-rest-reference.html。
{{< gallery match="images/6/*.png" >}}
このコマンドでは、ビデオの検索が可能です。
{{< terminal >}}
curl -s "http://pree-tube/api/v1search/videos?search=docker&languageOneOf=de"

{{</ terminal >}}
アップロードなどには、認証とセッション・トークンが必要です。
```
#!/bin/bash
USERNAME="user"
PASSWORD="password"
API_PATH="http://peertube-adresse/api/v1"

client_id=$(curl -s "$API_PATH/oauth-clients/local" | jq -r ".client_id")
client_secret=$(curl -s "$API_PATH/oauth-clients/local" | jq -r ".client_secret")
token=$(curl -s "$API_PATH/users/token" \
  --data client_id="$client_id" \
  --data client_secret="$client_secret" \
  --data grant_type=password \
  --data response_type=code \
  --data username="$USERNAME" \
  --data password="$PASSWORD" \
  | jq -r ".access_token")

curl -s '$API_PATH/videos/upload'-H 'Authorization: Bearer $token' --max-time 11600 --form videofile=@'/scripte/output.mp4' --form name='mein upload' 

```

## 私のアドバイス：「Great things with containers: making Docker services more secure with LDAP and NGINX」をお読みください。
