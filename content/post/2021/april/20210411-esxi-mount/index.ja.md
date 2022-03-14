+++
date = "2021-04-11"
title = "ショートストーリー：SynologyボリュームをESXiに接続する。"
difficulty = "level-1"
tags = ["dos", "esxi", "khk-kaufmann-v1", "nuc", "pc-kaufmann", "Synology", "vmware"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210411-esxi-mount/index.ja.md"
+++

## ステップ1："NFS "サービスの有効化
まず、Diskstation上で「NFS」サービスを有効にする必要があります。そのためには、「コントロールパネル」→「ファイルサービス」の設定で、「NFSを有効にする」をクリックします。
{{< gallery match="images/1/*.png" >}}
そして、「共有フォルダ」をクリックして、ディレクトリを選択します。
{{< gallery match="images/2/*.png" >}}

## Step 2: ESXiにディレクトリをマウントする
ESXiでは、「ストレージ」→「新規データストア」をクリックし、そこにデータを入力します。
{{< gallery match="images/3/*.png" >}}

## 準備完了
これでメモリが使えるようになりました。
{{< gallery match="images/4/*.png" >}}
試しに、このマウントポイント経由でDOSインストールと古い会計ソフトをインストールしてみました。
{{< gallery match="images/5/*.png" >}}
