+++
date = "2021-07-25"
title = "コンテナの優れた点：UI付きDockerレジストリ"
difficulty = "level-3"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "registry", "images", "ui", "interface"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/july/20210725-docker-registry/index.ja.md"
+++
独自のレジストリを使ってDockerイメージをネットワーク全体で利用できるようにする方法をご紹介します。
## インストール
サーバーに「docker-registry」という新しいディレクトリを作ります。
{{< terminal >}}
mkdir docker-registry

{{</ terminal >}}
そして、docker-registryディレクトリに入り（「cd docker-registry」）、「registry.yml」という新しいファイルを以下の内容で作成します。
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
家庭での使用に便利なDockerイメージは、[Dockerverse]({{< ref "dockerverse" >}} "Dockerverse")にもあります。
## スタートコマンド
このファイルはDocker Composeで起動します。その後、インストールは意図したドメイン/ポートでアクセスできるようになります。
{{< terminal >}}
docker-compose -f registry.yml up -d

{{</ terminal >}}
その後、UIコンテナのターゲットIPとポートを使って、独自のレジストリを使用することができます。
{{< gallery match="images/1/*.png" >}}
これで、レジストリからイメージを構築、プッシュ、投入できるようになりました。
{{< terminal >}}
docker build -t 192.168.178.61:5000/mein-image:version .
docker push 192.168.178.61:5000/mein-image:version
docker pull 192.168.178.61:5000/mein-image:version

{{</ terminal >}}
