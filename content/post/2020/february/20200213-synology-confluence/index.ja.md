+++
date = "2020-02-13"
title = "Synology-Nas: wikiシステムとしてのConfluence"
difficulty = "level-4"
tags = ["atlassian", "confluence", "Docker", "ds918", "Synology", "wiki", "nas"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2020/february/20200213-synology-confluence/index.ja.md"
+++
Synology NASにAtlassian Confluenceをインストールするには、適切な場所に来ています。
## ステップ1
まず、SynologyのインターフェイスでDockerアプリを開き、サブアイテムの「登録」に進みます。そこで「Confluence」を検索して、最初の画像「Atlassian Confluence」をクリックします。
{{< gallery match="images/1/*.png" >}}

## ステップ2
画像のダウンロード後、画像として利用できます。Dockerでは、コンテナ（動的状態）とimage/イメージ（固定状態）の2つの状態を区別しています。イメージからコンテナを作成する前に、いくつかの設定を行う必要があります。
## 自動再起動
私の Confluence イメージをダブルクリックします。
{{< gallery match="images/2/*.png" >}}
そして、「詳細設定」をクリックし、「自動再起動」を有効にします。
{{< gallery match="images/3/*.png" >}}

## ポート
Confluence コンテナには固定ポートを割り当てています。ポートが固定されていないと、再起動後に Confluence が異なるポートで動作する可能性があります。
{{< gallery match="images/4/*.png" >}}

## メモリ
物理的なフォルダを作成し、コンテナにマウントします（/var/atlassian/application-data/confluence/）。この設定により、データのバックアップやリストアが容易になります。
{{< gallery match="images/5/*.png" >}}
これらの設定が終わると、Confluence が起動します。
{{< gallery match="images/6/*.png" >}}