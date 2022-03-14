+++
date = "2021-04-11"
title = "危機からの脱却：PrestaShopによるプロフェッショナルなウェブショップ"
difficulty = "level-4"
tags = ["corona", "Docker", "docker-compose", "kreativ", "krise", "online-shop", "presta", "shop", "shopsystem"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210411-docker-PrestaShop/index.ja.md"
+++
PrestaShopは、ヨーロッパのオープンソースのEコマースプラットフォームで、同社の情報によると、現在30万以上のインストール数があります。今日はこのPHPソフトウェアを私のサーバーにインストールします。このチュートリアルには、Linux、DockerおよびDocker Composeに関する知識が必要です。
## ステップ1：PrestaShopのインストール
サーバーに「prestashop」という新しいディレクトリを作成します。
{{< terminal >}}
mkdir prestashop
cd prestashop

{{</ terminal >}}
そして、prestashopディレクトリに入り、「prestashop.yml」という新しいファイルを以下の内容で作成します。
```
version: '2'

services:
  mariadb:
    image: mysql:5.7
    environment:
      - MYSQL_ROOT_PASSWORD=admin
      - MYSQL_DATABASE=prestashop
      - MYSQL_USER=prestashop
      - MYSQL_PASSWORD=prestashop
    volumes:
      - ./mysql:/var/lib/mysql
    expose:
      - 3306
    networks:
      - shop-network
    restart: always

  prestashop:
    image: prestashop/prestashop:1.7.7.2
    ports:
      - 8090:80
    depends_on:
      - mariadb
    volumes:
      - ./prestadata:/var/www/html
      - ./prestadata/modules:/var/www/html/modules
      - ./prestadata/themes:/var/www/html/themes
      - ./prestadata/override:/var/www/html/override
    environment:
      - PS_INSTALL_AUTO=0
    networks:
      - shop-network
    restart: always

networks:
  shop-network:

```
残念ながら、現在のLastestバージョンでは動作しなかったので、「1.7.7.2」バージョンをインストールしました。このファイルはDocker Composeで起動します。
{{< terminal >}}
docker-compose -f prestashop.yml up

{{</ terminal >}}
このプロセスには時間がかかるので、新鮮なコーヒーを手に入れるのがベストです。以下のテキストが表示されている場合のみ、このインターフェースを使用することができます。
{{< gallery match="images/1/*.png" >}}
その後、私のPrestaShopサーバーを呼び出し、インターフェースを介してインストールを続けることができます。
{{< gallery match="images/2/*.png" >}}
Docker-Composeを「Ctrl C」で終了させ、サブフォルダ「prestadata」を呼び出す（「cd prestadata」）。そこで、「rm -r install」で「install」フォルダを削除する必要があります。
{{< gallery match="images/3/*.png" >}}
さらに、そこには「Admin」フォルダがあり、私の場合は「admin697vqoryt」となっています。この略語を後で覚えておいて、Docker Compose経由で再びサーバーを起動する。
{{< terminal >}}
docker-compose -f prestashop.yml up -d

{{</ terminal >}}

## ステップ2：ショップのテスト
再起動後、Prestaショップのインストールをテストし、「shop-url/admin shortcuts」で管理画面も呼び出してみました。
{{< gallery match="images/4/*.png" >}}