+++
date = "2021-05-30"
title = "Synology DiskStation上のUdemyダウンローダー"
difficulty = "level-2"
tags = ["udemy", "download", "synology", "diskstation", "udemydl"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/may/20210530-udemydl/index.ja.md"
+++
このチュートリアルでは、オフラインで使用するために「udemy」コースをダウンロードする方法について説明します。
## ステップ1：Udemyフォルダの準備
Dockerディレクトリに「udemy」というディレクトリを新規に作成します。
{{< gallery match="images/1/*.png" >}}

## ステップ2：Ubuntuイメージのインストール
Synology Dockerウィンドウの「登録」タブをクリックし、「ubunutu」を検索しています。Dockerイメージ「ubunutu」を選択し、「latest」タグをクリックしています。
{{< gallery match="images/2/*.png" >}}
Ubuntuのイメージをダブルクリックする。そして「詳細設定」をクリックし、ここでも「自動再起動」を有効にしています。
{{< gallery match="images/3/*.png" >}}
ボリューム」タブを選択し、「フォルダの追加」をクリックしています。そこに、このマウントパス「/download」で新しいフォルダを作成します。
{{< gallery match="images/4/*.png" >}}
これで、コンテナを起動することができます
{{< gallery match="images/5/*.png" >}}

## ステップ4：Udemy Downloaderのインストール
Synology Dockerウィンドウで「コンテナ」をクリックし、「Udemyコンテナ」をダブルクリックします。そして、「ターミナル」タブをクリックし、以下のコマンドを入力します。
{{< gallery match="images/6/*.png" >}}

## コマンドを使用します。

{{< terminal >}}
apt-get update
apt-get install python3 python3-pip wget unzip
cd /download
wget https://github.com/r0oth3x49/udemy-dl/archive/refs/heads/master.zip
unzip master.zip
cd udemy-dl-master
pip3 pip install -r requirements.txt

{{</ terminal >}}
スクリーンショット
{{< gallery match="images/7/*.png" >}}

## ステップ4：Udemyダウンローダーを稼働させる
あとは「アクセストークン」が必要です。私はFirefoxブラウザでUdemyにアクセスし、Firebugを開きます。Webストレージ」タブをクリックし、「アクセストークン」をコピーしています。
{{< gallery match="images/8/*.png" >}}
コンテナ内に新しいファイルを作成します。
{{< terminal >}}
echo "access_token=859wjuhV7PMLsZu15GOWias9A0iFnRjkL9pJXOv2" > /download/cookie.txt

{{</ terminal >}}
その後、すでに購入したコースをダウンロードすることができます。
{{< terminal >}}
cd /download
python3 udemy-dl-master/udemy-dl.py -k /download/cookie.txt https://www.udemy.com/course/ansible-grundlagen/learn/

{{</ terminal >}}
ご覧ください。
{{< gallery match="images/9/*.png" >}}

