+++
date = "2021-04-11"
title = "短編：Synology ボリュームを ESXi に接続する。"
difficulty = "level-1"
tags = ["dos", "esxi", "khk-kaufmann-v1", "nuc", "pc-kaufmann", "Synology", "vmware"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210411-esxi-mount/index.ja.md"
+++

## ステップ1：「NFS」サービスを有効化する
まず、Diskstation で "NFS" サービスを有効化する必要があります。そのために、「コントロールパネル」→「ファイルサービス」の設定で、「NFSを有効にする」をクリックしています。
{{< gallery match="images/1/*.png" >}}
そして、「共有フォルダ」をクリックして、ディレクトリを選択します。
{{< gallery match="images/2/*.png" >}}

## ステップ2：ESXiにディレクトリをマウントする
ESXiで「ストレージ」→「新規データストア」をクリックし、そこにデータを入力します。
{{< gallery match="images/3/*.png" >}}

## レディ
これでメモリが使えるようになりました。
{{< gallery match="images/4/*.png" >}}
試しに、このマウントポイントを経由して、DOSのインストールと古い会計ソフトをインストールしてみました。
{{< gallery match="images/5/*.png" >}}

