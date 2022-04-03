+++
date = "2021-04-11"
title = "危機を脱したクリエイティブ：PrestaShopによるプロフェッショナルなウェブショップ"
difficulty = "level-4"
tags = ["corona", "Docker", "docker-compose", "kreativ", "krise", "online-shop", "presta", "shop", "shopsystem"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210411-docker-PrestaShop/index.ja.md"
+++
PrestaShopはヨーロッパのオープンソースEコマースプラットフォームで、同社の情報によると、現在30万台以上のインストールがあります。今日、私はこのPHPソフトをサーバーにインストールしています。このチュートリアルでは、Linux、Docker、Docker Composeの知識が必要です。
## ステップ1：PrestaShopのインストール
サーバーに「prestashop」というディレクトリを新規に作成します。
{{< terminal >}}
mkdir prestashop
cd prestashop

{{</ terminal >}}
そして、prestashopのディレクトリに入り、以下の内容で「prestashop.yml」というファイルを新規に作成します。
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
残念ながら、現在のLastestバージョンではうまくいかなかったので、「1.7.7.2」をインストールしました。このファイルはDocker Compose経由で起動します。
{{< terminal >}}
docker-compose -f prestashop.yml up

{{</ terminal >}}
処理に時間がかかるので、新鮮なコーヒーを手に入れるのが一番です。以下のテキストが表示されているときのみ、インターフェイスを使用することができます。
{{< gallery match="images/1/*.png" >}}
その後、PrestaShopサーバーを呼び出し、インターフェイスを介してインストールを続行することができます。
{{< gallery match="images/2/*.png" >}}
Docker-Composeを「Ctrl C」で終了し、サブフォルダ「prestadata」を呼び出す（「cd prestadata」）。そこで、「install」フォルダを「rm -r install」で削除する必要があります。
{{< gallery match="images/3/*.png" >}}
さらに、そこには「Admin」フォルダがあり、私の場合は「admin697vqoryt」です。この略称を後々のために覚えておいて、Docker Compose経由でサーバーを再度起動します。
{{< terminal >}}
docker-compose -f prestashop.yml up -d

{{</ terminal >}}

## ステップ2：ショップのテスト
再起動後、Prestaショップのインストールをテストし、「shop-url/admin shortcuts」で管理画面も呼び出しています。
{{< gallery match="images/4/*.png" >}}
