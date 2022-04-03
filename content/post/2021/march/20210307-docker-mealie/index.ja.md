+++
date = "2021-03-07"
title = "コンテナで素晴らしいものを：Synology DiskStation でレシピを管理、アーカイブする。"
difficulty = "level-1"
tags = ["diskstation", "Docker", "docker-compose", "docker-for-desktop", "rezepte", "speisen", "Synology"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/march/20210307-docker-mealie/index.ja.md"
+++
お気に入りのレシピをDockerコンテナに集めて、好きなように整理してください。自分でレシピを書いたり、「シェフコク」「エッセン」などのウェブサイトからレシピを取り込むことができます。
{{< gallery match="images/1/*.png" >}}

## プロフェッショナル向けオプション
経験豊富な Synology ユーザーであれば、もちろん SSH でログインし、Docker Compose ファイルを介してセットアップ全体をインストールすることができます。
```
version: "2.0"
services:
  mealie:
    container_name: mealie
    image: hkotel/mealie:latest
    restart: always
    ports:
      - 9000:80
    environment:
      db_type: sqlite
      TZ: Europa/Berlin
    volumes:
      - ./mealie/data/:/app/data

```

## ステップ1：Dockerイメージの検索
Synology Dockerウィンドウの「登録」タブをクリックし、「mealie」を検索しています。Dockerイメージ「hkotel/mealie:latest」を選択し、「latest」タグをクリックしています。
{{< gallery match="images/2/*.png" >}}
画像ダウンロード後、画像として利用可能です。Dockerでは、コンテナ（動的状態）とイメージ/画像（固定状態）の2つの状態を区別しています。イメージからコンテナを作成する前に、いくつかの設定を行う必要があります。
## ステップ2：画像を運用に乗せる
自分の「ミーリー」画像をダブルクリックする。
{{< gallery match="images/3/*.png" >}}
そして、「詳細設定」をクリックして「自動再起動」を有効にしています。ボリューム」タブを選択し、「フォルダの追加」をクリックしています。そこで、このマウントパス「/app/data」で新しいフォルダを作成します。
{{< gallery match="images/4/*.png" >}}
Mealie」コンテナには、固定ポートを割り当てています。固定ポートがないと、再起動後に「Mealieサーバ」が別のポートで動作している可能性があります。
{{< gallery match="images/5/*.png" >}}
最後に、2つの環境変数を入力します。変数 "db_type "はデータベースの種類、"TZ "はタイムゾーン "Europe/Berlin "を表します。
{{< gallery match="images/6/*.png" >}}
これらの設定が終わると、Mealie Serverが起動できるようになりますその後、Synology disctation の IP アドレスと割り当てられたポート（例：http://192.168.21.23:8096）を介して、Mealie に電話をかけることができます。
{{< gallery match="images/7/*.png" >}}

## Mealieの仕組みについて教えてください。
右/下の「プラス」ボタンにマウスを合わせて、「鎖」マークをクリックすると、urlを入力することができます。そして、Mealieアプリケーションは、必要なメタ情報およびスキーマ情報を自動的に検索する。
{{< gallery match="images/8/*.png" >}}
インポートがうまくいく（私はこれらの関数をChef, Food
{{< gallery match="images/9/*.png" >}}
編集モードでは、カテゴリーを追加することもできるんだ。各カテゴリーの後に「Enter」キーを1回ずつ押すことが重要です。それ以外の場合は、この設定は適用されません。
{{< gallery match="images/10/*.png" >}}

## 特集
メニューのカテゴリーが自動的に更新されないことに気づきました。ここはブラウザのリロードで助けるしかない。
{{< gallery match="images/11/*.png" >}}

## その他の機能
もちろん、レシピの検索はもちろん、献立の作成も可能です。また、「Mealie」は非常に広範囲にカスタマイズすることが可能です。
{{< gallery match="images/12/*.png" >}}
Mealieは、モバイルでも見栄えがします。
{{< gallery match="images/13/*.*" >}}

## レスト・アピ
API のドキュメントは、"http://gewaehlte-ip:und-port ... /docs "で見ることができます。ここでは、自動化に使える様々な方法を紹介しています。
{{< gallery match="images/14/*.png" >}}

## Apiの例
次のようなフィクションを想像してみてください：「Gruner und JahrがインターネットポータルEssenを立ち上げる
{{< terminal >}}
wget --spider --force-html -r -l12  "https://www.essen-und-trinken.de/rezepte/archiv/"  2>&1 | grep '/rezepte/' | grep '^--' | awk '{ print $3 }' > liste.txt

{{</ terminal >}}
そして、このリストをクリーンアップして、例えば、rest apiに対して実行します。
```
#!/bin/bash
sort -u liste.txt > clear.txt

while read p; do
  echo "import url: $p"
  curl -d "{\"url\":\"$p\"}" -H "Content-Type: application/json" http://synology-ip:8096/api/recipes/create-url
  sleep 1
done < clear.txt

```
オフラインでレシピにアクセスすることもできるようになりました。
{{< gallery match="images/15/*.png" >}}
結論：Mealieに時間をかければ、素晴らしいレシピデータベースが構築できる！？Mealieはオープンソースプロジェクトとして常に開発されており、次のアドレスで見ることができます: https://github.com/hay-kot/mealie/
