+++
date = "2021-05-30"
title = "Synology DiskStationのUdemyダウンローダー"
difficulty = "level-2"
tags = ["udemy", "download", "synology", "diskstation", "udemydl"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/may/20210530-udemydl/index.ja.md"
+++
このチュートリアルでは、「udemy」のコースをダウンロードしてオフラインで使用する方法を学びます。
## ステップ1：Udemyフォルダの準備
Dockerのディレクトリに「udemy」という新しいディレクトリを作ります。
{{< gallery match="images/1/*.png" >}}

## ステップ2：Ubuntuイメージのインストール
Synology Dockerのウィンドウで「登録」タブをクリックし、「ubunutu」を検索します。ubunutu」というDockerイメージを選択して、「latest」というタグをクリックします。
{{< gallery match="images/2/*.png" >}}
私はUbuntuのイメージをダブルクリックする。そして、「詳細設定」をクリックして、ここでも「自動再起動」を有効にします。
{{< gallery match="images/3/*.png" >}}
ボリューム "タブを選択し、"フォルダの追加 "をクリックします。そこで、「/download」というマウントパスで新しいフォルダを作成します。
{{< gallery match="images/4/*.png" >}}
これで、コンテナを起動することができます。
{{< gallery match="images/5/*.png" >}}

## ステップ4：Udemy Downloaderのインストール
Synology Dockerのウィンドウで "Container "をクリックし、私の "Udemy container "をダブルクリックします。そして、「ターミナル」タブをクリックし、以下のコマンドを入力します。
{{< gallery match="images/6/*.png" >}}

## コマンドです。

{{< terminal >}}
apt-get update
apt-get install python3 python3-pip wget unzip
cd /download
wget https://github.com/r0oth3x49/udemy-dl/archive/refs/heads/master.zip
unzip master.zip
cd udemy-dl-master
pip3 pip install -r requirements.txt

{{</ terminal >}}
スクリーンショットです。
{{< gallery match="images/7/*.png" >}}

## ステップ4：Udemyのダウンローダーを運用する
あとは、「アクセストークン」が必要です。FirefoxブラウザでUdemyにアクセスし、Firebugを開きます。Webストレージ」のタブをクリックして、「アクセストークン」をコピーします。
{{< gallery match="images/8/*.png" >}}
私はコンテナに新しいファイルを作成します。
{{< terminal >}}
echo "access_token=859wjuhV7PMLsZu15GOWias9A0iFnRjkL9pJXOv2" > /download/cookie.txt

{{</ terminal >}}
その後、すでに購入したコースをダウンロードすることができます。
{{< terminal >}}
cd /download
python3 udemy-dl-master/udemy-dl.py -k /download/cookie.txt https://www.udemy.com/course/ansible-grundlagen/learn/

{{</ terminal >}}
見てください。
{{< gallery match="images/9/*.png" >}}
