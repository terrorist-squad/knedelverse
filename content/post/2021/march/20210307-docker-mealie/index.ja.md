+++
date = "2021-03-07"
title = "コンテナを使って素晴らしいことをする：Synology DiskStation でレシピを管理、アーカイブする"
difficulty = "level-1"
tags = ["diskstation", "Docker", "docker-compose", "docker-for-desktop", "rezepte", "speisen", "Synology"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/march/20210307-docker-mealie/index.ja.md"
+++
お気に入りのレシピをすべてDockerコンテナに集めて、好きなように整理することができます。自分でレシピを書いたり、「Chefkoch」や「Essen」などのウェブサイトからレシピを取り込んだりすることができます。
{{< gallery match="images/1/*.png" >}}

## プロフェッショナルのためのオプション
経験豊富なSynologyユーザーであれば、もちろんSSHでログインし、Docker Composeファイルでセットアップ全体をインストールすることができます。
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
Synology Dockerのウィンドウで「登録」タブをクリックし、「mealie」を検索します。私はDockerイメージ「hkotel/mealie:latest」を選択し、「latest」というタグをクリックしています。
{{< gallery match="images/2/*.png" >}}
画像のダウンロード後、画像として利用できます。Dockerでは、コンテナ（動的状態）とimage/イメージ（固定状態）の2つの状態を区別しています。イメージからコンテナを作成する前に、いくつかの設定を行う必要があります。
## Step2：イメージを形にして運用する
私は自分の「ミートゥー」の画像をダブルクリックします。
{{< gallery match="images/3/*.png" >}}
そして、「詳細設定」をクリックし、「自動再起動」を有効にします。ボリューム "タブを選択し、"フォルダの追加 "をクリックします。そこで、「/app/data」というマウントパスで新しいフォルダを作成します。
{{< gallery match="images/4/*.png" >}}
Mealie "コンテナには固定ポートを割り当てています。ポートが固定されていないと、再起動後に「Mealieサーバー」が別のポートで動作してしまう可能性があります。
{{< gallery match="images/5/*.png" >}}
最後に、2つの環境変数を入力します。変数 "db_type "はデータベースタイプ、"TZ "はタイムゾーン "Europe/Berlin "です。
{{< gallery match="images/6/*.png" >}}
これらの設定が終わると、Mealie Serverが起動します。その後、Synology disctationのIPアドレスと割り当てられたポート(例：http://192.168.21.23:8096)を使ってMealieに電話をかけることができます。
{{< gallery match="images/7/*.png" >}}

## Mealieの機能は？
右/下の「プラス」ボタンにマウスを合わせ、「鎖」のマークをクリックすると、URLを入力することができます。そして、Mealieアプリケーションは、必要なメタ情報やスキーマ情報を自動的に検索します。
{{< gallery match="images/8/*.png" >}}
インポートは非常にうまくいきました（これらの関数をChef、FoodのURLで使用しました）。
{{< gallery match="images/9/*.png" >}}
編集モードでは、カテゴリーを追加することもできます。各カテゴリーの後に「Enter」キーを1回押すことが重要です。それ以外の場合は、この設定は適用されません。
{{< gallery match="images/10/*.png" >}}

## 特典映像
メニューのカテゴリーが自動的に更新されないことに気づきました。ここでは、ブラウザのリロードで助けてください。
{{< gallery match="images/11/*.png" >}}

## その他の機能
もちろん、レシピの検索はもちろん、メニューの作成も可能です。また、"Mealie "は非常に広範囲にカスタマイズすることができます。
{{< gallery match="images/12/*.png" >}}
また、Mealieはモバイルでも活躍します。
{{< gallery match="images/13/*.*" >}}

## Rest-Api
APIドキュメントは、"http://gewaehlte-ip:und-port ... /docs "にあります。ここでは、自動化のために使用できる多くの方法を見つけることができます。
{{< gallery match="images/14/*.png" >}}

## Apiの例
次のようなフィクションを想像してみてください。「Gruner und Jahr社は、インターネット・ポータルEssenを立ち上げた。
{{< terminal >}}
wget --spider --force-html -r -l12  "https://www.essen-und-trinken.de/rezepte/archiv/"  2>&1 | grep '/rezepte/' | grep '^--' | awk '{ print $3 }' > liste.txt

{{</ terminal >}}
次に、このリストをクリーンアップして、rest apiに対して送信します。
```
#!/bin/bash
sort -u liste.txt > clear.txt

while read p; do
  echo "import url: $p"
  curl -d "{\"url\":\"$p\"}" -H "Content-Type: application/json" http://synology-ip:8096/api/recipes/create-url
  sleep 1
done < clear.txt

```
これで、オフラインでもレシピにアクセスできるようになりました。
{{< gallery match="images/15/*.png" >}}
