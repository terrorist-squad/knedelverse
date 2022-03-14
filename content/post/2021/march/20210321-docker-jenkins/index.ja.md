+++
date = "2021-03-21"
title = "コンテナで実現すること：Synology DSでJenkinsを動かす"
difficulty = "level-3"
tags = ["build", "devops", "diskstation", "java", "javascript", "Jenkins", "nas", "Synology"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/march/20210321-docker-jenkins/index.ja.md"
+++

## ステップ1：Synologyの準備
まず、DiskStationでSSHログインを有効にする必要があります。そのためには、「コントロールパネル」→「ターミナル」で
{{< gallery match="images/1/*.png" >}}
そして、「SSH」で指定されたポートと管理者パスワードでログインします（WindowsユーザーはPuttyまたはWinSCPを使用）。
{{< gallery match="images/2/*.png" >}}
Terminal、winSCP、Puttyなどでログインして、このコンソールを後から開くようにしています。
## ステップ2：Dockerフォルダの準備
Dockerディレクトリに「jenkins」という新しいディレクトリを作ります。
{{< gallery match="images/3/*.png" >}}
その後、新しいディレクトリに移動し、新しいフォルダ「data」を作成します。
{{< terminal >}}
sudo mkdir data

{{</ terminal >}}
また、「jenkins.yml」というファイルを作成し、以下のような内容にしています。ポート「8081:」のフロント部分を調整することができます。
```
version: '2.0'
services:
  jenkins:
    restart: always
    image: jenkins/jenkins:lts
    privileged: true
    user: root
    ports:
      - 8081:8080
    container_name: jenkins
    volumes:
      - ./data:/var/jenkins_home
      - /var/run/docker.sock:/var/run/docker.sock
      - /usr/local/bin/docker:/usr/local/bin/docker

```

## ステップ3：スタート
また、このステップでは、コンソールをうまく利用することができます。Docker ComposeでJenkinsサーバーを起動します。
{{< terminal >}}
sudo docker-compose -f jenkins.yml up -d

{{</ terminal >}}
その後、ディスクステーションのIPと「ステップ2」で割り当てられたポートを使って、Jenkinsサーバーを呼び出すことができます。
{{< gallery match="images/4/*.png" >}}

## ステップ4：セットアップ

{{< gallery match="images/5/*.png" >}}
ここでもコンソールを使って、初期パスワードを読み上げます。
{{< terminal >}}
cat data/secrets/initialAdminPassword

{{</ terminal >}}
見てください。
{{< gallery match="images/6/*.png" >}}
推奨インストール」を選択しました。
{{< gallery match="images/7/*.png" >}}

## ステップ5：最初の仕事
ログインして、Dockerジョブを作成します。
{{< gallery match="images/8/*.png" >}}
ご覧の通り、すべてが素晴らしい出来です。
{{< gallery match="images/9/*.png" >}}