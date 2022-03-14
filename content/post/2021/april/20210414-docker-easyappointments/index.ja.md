+++
date = "2021-04-16"
title = "危機を乗り越えるクリエイティブ：easyappointmentsでサービスを予約する"
difficulty = "level-3"
tags = ["buchung", "buchungstool", "click-and-meet", "corona", "Docker", "docker-compose", "easyappointments", "krise", "einzelhandel", "geschaefte"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210414-docker-easyappointments/index.ja.md"
+++
コロナの危機は、ドイツのサービスプロバイダーに大きな打撃を与えている。デジタルツールやソリューションは、コロナのパンデミックをできるだけ安全に乗り切るために役立ちます。このチュートリアルシリーズ「Creative out of the crisis」では、スモールビジネスに役立つ技術やツールを紹介しています。今日紹介するのは「Easyappointments」で、美容院やお店などのサービスを「クリックして会う」予約ツールです。Easyappointmentsは2つのエリアで構成されています。
## エリア1：バックエンド
サービスやアポイントメントを管理するための「バックエンド」です。
{{< gallery match="images/1/*.png" >}}

## エリア2：フロントエンド
予約をするためのエンドユーザーツールです。すでに予約されているすべてのアポイントメントはブロックされ、二重に予約することはできません。
{{< gallery match="images/2/*.png" >}}

## インストール
私はすでにDocker-Composeを使ってEasyappointmentsを何度かインストールしており、このインストール方法は非常にお勧めできます。サーバーに "easyappointments "という新しいディレクトリを作ります。
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
このファイルはDocker Composeで起動します。その後、インストールは意図したドメイン/ポートでアクセスできるようになります。
{{< terminal >}}
docker-compose -f easyappointments.yml up

{{</ terminal >}}

## サービスの作成
サービスは「サービス」で作成することができます。そして、それぞれの新しいサービスを、サービスプロバイダー/ユーザーに割り当てる必要があります。つまり、専門の社員やサービス業者を予約することができるのです。
{{< gallery match="images/3/*.png" >}}
また、最終消費者は、サービスや好みのサービスプロバイダーを選ぶことができます。
{{< gallery match="images/4/*.png" >}}

## 労働時間と休憩時間
一般的な勤務時間は、「設定」→「ビジネスロジック」で設定できます。ただし、サービス提供者／利用者の労働時間は、利用者の「就業計画」で変更することも可能です。
{{< gallery match="images/5/*.png" >}}

## 予約の概要とダイアリー
予約カレンダーでは、すべての予約が見えるようになっています。もちろん、予約の作成や編集もそこで行うことができます。
{{< gallery match="images/6/*.png" >}}

## 色や論理の調整
"app/www "ディレクトリをコピーアウトして "volume "として入れておけば、スタイルシートやロジックを好きなようにアレンジすることができます。
{{< gallery match="images/7/*.png" >}}