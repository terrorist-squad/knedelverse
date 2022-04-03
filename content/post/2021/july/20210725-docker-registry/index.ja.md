+++
date = "2021-07-25"
title = "コンテナですごいこと：UI付きDockerレジストリ"
difficulty = "level-3"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "registry", "images", "ui", "interface"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/july/20210725-docker-registry/index.ja.md"
+++
Dockerイメージを独自のレジストリでネットワーク全体に公開する方法について説明します。
## インストール
サーバーに「docker-registry」というディレクトリを新規に作成します。
{{< terminal >}}
mkdir docker-registry

{{</ terminal >}}
そして、docker-registryディレクトリに入り（「cd docker-registry」）、以下の内容で「registry.yml」というファイルを新規に作成します。
```
version: '3'

services:
  registry:
    restart: always
    image: registry:2
    ports:
    - "5000:5000"
    environment:
      REGISTRY_STORAGE_FILESYSTEM_ROOTDIRECTORY: /data
    volumes:
      - ./data:/data
    networks:
      - registry-ui-net

  ui:
    restart: always
    image: joxit/docker-registry-ui:static
    ports:
      - 8080:80
    environment:
      - REGISTRY_TITLE=My Private Docker Registry
      - REGISTRY_URL=http://registry:5000
    depends_on:
      - registry
    networks:
      - registry-ui-net

networks:
  registry-ui-net:

```
家庭で使える便利なDockerイメージは、[ドッカーバース]({{< ref "dockerverse" >}} "ドッカーバース").Dockerにあります。
## スタートコマンド
このファイルはDocker Compose経由で起動します。その後、意図したドメイン/ポートでインストールにアクセスできるようになります。
{{< terminal >}}
docker-compose -f registry.yml up -d

{{</ terminal >}}
その後、UIコンテナのターゲットIPとポートで自前のレジストリを使用することができます。
{{< gallery match="images/1/*.png" >}}
これで、レジストリからイメージをビルド、プッシュ、ポピュレートすることができるようになりました。
{{< terminal >}}
docker build -t 192.168.178.61:5000/mein-image:version .
docker push 192.168.178.61:5000/mein-image:version
docker pull 192.168.178.61:5000/mein-image:version

{{</ terminal >}}

