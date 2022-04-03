+++
date = "2020-02-13"
title = "Synology-Nas：WikiシステムとしてのConfluence"
difficulty = "level-4"
tags = ["atlassian", "confluence", "Docker", "ds918", "Synology", "wiki", "nas"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2020/february/20200213-synology-confluence/index.ja.md"
+++
Synology NAS に Atlassian Confluence をインストールしたいのであれば、正しい場所にいることになります。
## ステップ1
まず、SynologyのインターフェイスでDockerアプリを開き、「登録」というサブアイテムに進みます。そこで「Confluence」を検索し、最初の画像「Atlassian Confluence」をクリックします。
{{< gallery match="images/1/*.png" >}}

## ステップ2
画像ダウンロード後、画像として利用可能です。Dockerでは、コンテナ（動的状態）とイメージ/画像（固定状態）の2つの状態を区別しています。イメージからコンテナを作成する前に、いくつかの設定を行う必要があります。
## 自動再起動
Confluenceのイメージをダブルクリックする。
{{< gallery match="images/2/*.png" >}}
そして、「詳細設定」をクリックして「自動再起動」を有効にしています。
{{< gallery match="images/3/*.png" >}}

## 港湾
Confluenceのコンテナには固定ポートを割り当てています。固定ポートがなければ、Confluence は再起動後に異なるポートで動作する可能性があります。
{{< gallery match="images/4/*.png" >}}

## メモリ
物理フォルダを作り、コンテナ（/var/atlassian/application-data/confluence/）にマウントしています。この設定により、データのバックアップや復元が容易になります。
{{< gallery match="images/5/*.png" >}}
これらの設定後、Confluenceを起動することができます!
{{< gallery match="images/6/*.png" >}}
