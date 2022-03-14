+++
date = "2019-07-17"
title = "Synology-Nas: Gitlab - Dockerコンテナ内のランナー"
difficulty = "level-4"
tags = ["Docker", "git", "gitlab", "gitlab-runner", "raspberry-pi"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2019/july/20190717-synology-gitlab-runner/index.ja.md"
+++
GitlabのランナーをDockerコンテナとしてSynology NASにインストールするには？
## ステップ1：Dockerイメージの検索
Synology Dockerのウィンドウで「Registration」タブをクリックし、Gitlabを検索します。Dockerイメージ「gitlab/gitlab-runner」を選択し、タグ「bleeding」を選択しています。
{{< gallery match="images/1/*.png" >}}

## Step2：イメージを形にして運用する

## ホストの問題
私のsynology-gitlab-insterlationは、常にホスト名のみで自分自身を識別しています。パッケージセンターからオリジナルのSynology Gitlabパッケージを取り出したので、この動作は後から変更することはできません。  回避策として、自分のhostsファイルを入れることができます。ここでは、ホスト名「peter」が、NasのIPアドレス192.168.12.42に属していることがわかります。
```
127.0.0.1       localhost                                                       
::1     localhost ip6-localhost ip6-loopback                                    
fe00::0 ip6-localnet                                                            
ff00::0 ip6-mcastprefix                                                         
ff02::1 ip6-allnodes                                                            
ff02::2 ip6-allrouters               
192.168.12.42 peter

```
このファイルは、単にSynology NASに保存されます。
{{< gallery match="images/2/*.png" >}}

## ステップ3：GitLab Runnerの設定
自分のランナー像をクリックする。
{{< gallery match="images/3/*.png" >}}
自動再起動を有効にする」の設定を有効にします。
{{< gallery match="images/4/*.png" >}}
そして、「詳細設定」をクリックし、「ボリューム」タブを選択します。
{{< gallery match="images/5/*.png" >}}
ファイルの追加」をクリックして、「/etc/hosts」というパスで自分のhostsファイルを入れます。この手順は、ホスト名が解決できない場合にのみ必要です。
{{< gallery match="images/6/*.png" >}}
私は設定を受け入れ、次をクリックします。
{{< gallery match="images/7/*.png" >}}
これで、Containerの下に初期化されたイメージが見つかりました。
{{< gallery match="images/8/*.png" >}}
コンテナ（私の場合はgitlab-gitlab-runner2）を選択して、「Details」をクリックします。そして、「ターミナル」タブをクリックして、新しいbashセッションを作ります。ここで「gitlab-runner register」というコマンドを入力します。登録には、GitLabのインストール先であるhttp://gitlab-adresse:port/admin/runners の情報が必要です。   
{{< gallery match="images/9/*.png" >}}
さらにパッケージが必要な場合は、「apt-get update」でインストールした後、「apt-get install python ...」でインストールできます。
{{< gallery match="images/10/*.png" >}}
その後、自分のプロジェクトにランナーを入れて使うことができます。
{{< gallery match="images/11/*.png" >}}