+++
date = "2019-07-17"
title = "Synology-Nas: Gitlab - Dockerコンテナでのランナー"
difficulty = "level-4"
tags = ["Docker", "git", "gitlab", "gitlab-runner", "raspberry-pi"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2019/july/20190717-synology-gitlab-runner/index.ja.md"
+++
Synology NAS に Gitlab ランナーを Docker コンテナとしてインストールするにはどうしたらいいですか？
## ステップ1：Dockerイメージの検索
Synology Docker ウィンドウの「登録」タブをクリックし、Gitlab を検索しています。Dockerイメージ「gitlab/gitlab-runner」を選択し、「bleding」というタグを選択しています。
{{< gallery match="images/1/*.png" >}}

## ステップ2：画像を運用に乗せる

## ホストの問題
私の synology-gitlab-insterlation は、常にホスト名のみで自分自身を識別します。パッケージセンターからオリジナルのSynology Gitlabパッケージを取り出したので、この挙動は後から変更することはできません。  回避策として、自分のhostsファイルを入れることができる。ここでは、ホスト名「peter」がNasのIPアドレス192.168.12.42に所属していることがわかります。
```
127.0.0.1       localhost                                                       
::1     localhost ip6-localhost ip6-loopback                                    
fe00::0 ip6-localnet                                                            
ff00::0 ip6-mcastprefix                                                         
ff02::1 ip6-allnodes                                                            
ff02::2 ip6-allrouters               
192.168.12.42 peter

```
このファイルは、単に Synology NAS に保存されます。
{{< gallery match="images/2/*.png" >}}

## ステップ3：GitLab Runnerのセットアップ
私は自分のランナー画像をクリックします。
{{< gallery match="images/3/*.png" >}}
自動再起動を有効にする」の設定を有効にしています。
{{< gallery match="images/4/*.png" >}}
そして、「詳細設定」をクリックし、「ボリューム」タブを選択します。
{{< gallery match="images/5/*.png" >}}
ファイルの追加」をクリックし、「/etc/hosts」のパスでhostsファイルをインクルードしています。このステップは、ホスト名が解決できない場合にのみ必要です。
{{< gallery match="images/6/*.png" >}}
設定に同意して、次へをクリックします。
{{< gallery match="images/7/*.png" >}}
これで、Containerの下に初期化されたイメージが表示されました。
{{< gallery match="images/8/*.png" >}}
コンテナ（私の場合はgitlab-gitlab-runner2）を選択し、「詳細」をクリックします。そして、「ターミナル」タブをクリックし、新しいbashセッションを作成します。ここでは、"gitlab-runner register "というコマンドを入力します。登録には、GitLabのインストール先である http://gitlab-adresse:port/admin/runners にある情報が必要です。   
{{< gallery match="images/9/*.png" >}}
さらにパッケージが必要な場合は、「apt-get update」でインストールし、「apt-get install python ...」でインストールすることができます。
{{< gallery match="images/10/*.png" >}}
その後、自分のプロジェクトにランナーを含めて使えるようになりました。
{{< gallery match="images/11/*.png" >}}
