+++
date = "2021-04-16"
title = "危機を脱するクリエイティブ：easyappointmentsでサービスを予約する"
difficulty = "level-3"
tags = ["buchung", "buchungstool", "click-and-meet", "corona", "Docker", "docker-compose", "easyappointments", "krise", "einzelhandel", "geschaefte"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210414-docker-easyappointments/index.ja.md"
+++
コロナの危機は、ドイツのサービスプロバイダーに大きな打撃を与えている。デジタルツールやソリューションは、コロナのパンデミックをできるだけ安全に乗り切るために役立ちます。このチュートリアルシリーズ「Creative out of crisis」では、中小企業に役立つ技術やツールを紹介します。今日は、美容院やショップなどのサービス向けの「クリック＆ミート」予約ツール「Easyappointments」を紹介します。Easyappointmentsは、2つの領域で構成されています。
## エリア1：バックエンド
サービスやアポイントメントを管理するための「バックエンド」です。
{{< gallery match="images/1/*.png" >}}

## 領域2：フロントエンド
予約のためのエンドユーザーツールです。すでに予約されているすべての予約はブロックされ、重複して予約することはできません。
{{< gallery match="images/2/*.png" >}}

## インストール
私はすでにDocker-ComposeでEasyappointmentsを何度かインストールしており、このインストール方法は非常にお勧めできます。サーバーに「easyappointments」というディレクトリを新規に作成します。
{{< terminal >}}
mkdir easyappointments
cd easyappointments

{{</ terminal >}}
そして、easyappointmentsディレクトリに入り、以下の内容で「easyappointments.yml」というファイルを新規に作成します。
```
version: '2'
services:
  db:
    image: mysql
    environment:
      - MYSQL_ROOT_PASSWORD=root
      - MYSQL_DATABASE=easyappointments
      - MYSQL_USER=easyappointments
      - MYSQL_PASSWORD=easyappointments
    command: mysqld --default-authentication-plugin=mysql_native_password
    volumes:
      - ./easy-appointments-data:/var/lib/mysql
    expose:
      - 3306
    networks:
      - easyappointments-network
    restart: always

  application:
    image: jamrizzi/easyappointments
    volumes:
      - ./easy-appointments:/app/www
    depends_on:
      - db
    ports:
      - 8089:8888
    environment:
      - DB_HOST=db
      - DB_USERNAME=easyappointments
      - DB_NAME=easyappointments
      - DB_PASSWORD=easyappointments
      - TZ=Europe/Berlin
      - BASE_URL=http://192.168.178.50:8089 
    networks:
      - easyappointments-network
    restart: always

networks:
  easyappointments-network:

```
このファイルはDocker Compose経由で起動します。その後、意図したドメイン/ポートでインストールにアクセスできるようになります。
{{< terminal >}}
docker-compose -f easyappointments.yml up

{{</ terminal >}}

## サービスの作成
サービスは、「サービス」で作成することができます。そして、新しいサービスには、サービスプロバイダーやユーザーを割り当てる必要があります。つまり、専門の社員やサービスプロバイダーを予約することができるのです。
{{< gallery match="images/3/*.png" >}}
また、最終消費者はサービスや好みのサービスプロバイダーを選択することができます。
{{< gallery match="images/4/*.png" >}}

## 労働時間・休憩時間
一般的な勤務時間は、「設定」→「ビジネスロジック」で設定できます。ただし、サービス提供者／利用者の勤務時間は、利用者の「勤務計画」で変更することも可能です。
{{< gallery match="images/5/*.png" >}}

## 予約の概要と日記
アポイントメントカレンダーは、すべての予約を可視化します。もちろん、予約もそこで作成・編集することができます。
{{< gallery match="images/6/*.png" >}}

## 色や論理の調整
app/www」ディレクトリをコピーアウトして「volume」として入れれば、スタイルシートやロジックを自由にアレンジすることができます。
{{< gallery match="images/7/*.png" >}}
