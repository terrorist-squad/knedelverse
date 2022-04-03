+++
date = "2021-03-21"
title = "コンテナですごいこと：Synology DSでJenkinsを動かす"
difficulty = "level-3"
tags = ["build", "devops", "diskstation", "java", "javascript", "Jenkins", "nas", "Synology"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/march/20210321-docker-jenkins/index.ja.md"
+++

## ステップ1：Synologyを準備する
まず、DiskStationでSSHログインを有効にする必要があります。そのためには、「コントロールパネル」→「ターミナル」を開きます。
{{< gallery match="images/1/*.png" >}}
そして、「SSH」、指定されたポート、管理者パスワードでログインします（WindowsユーザーはPuttyまたはWinSCPを使用します）。
{{< gallery match="images/2/*.png" >}}
ターミナル、winSCP、Puttyでログインして、このコンソールを開いたままにしておくと、後で便利です。
## ステップ2：Dockerフォルダの準備
Dockerディレクトリの中に「jenkins」というディレクトリを新規に作成します。
{{< gallery match="images/3/*.png" >}}
そして、新しいディレクトリに移動し、新しいフォルダ "data "を作成します。
{{< terminal >}}
sudo mkdir data

{{</ terminal >}}
また、「jenkins.yml」というファイルを作成し、以下の内容を記述しています。ポート「8081:」の前面部分を調整することができます。
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
このステップでは、コンソールもうまく活用できるんだ。Docker Compose経由でJenkinsサーバを起動させています。
{{< terminal >}}
sudo docker-compose -f jenkins.yml up -d

{{</ terminal >}}
その後、「ステップ2」で割り当てたディスクステーションのIPとポートで、Jenkinsサーバーを呼び出すことができます。
{{< gallery match="images/4/*.png" >}}

## ステップ4：セットアップ

{{< gallery match="images/5/*.png" >}}
ここでもコンソールを使って初期パスワードを読み上げています。
{{< terminal >}}
cat data/secrets/initialAdminPassword

{{</ terminal >}}
ご覧ください。
{{< gallery match="images/6/*.png" >}}
推奨インストール」を選択しました。
{{< gallery match="images/7/*.png" >}}

## ステップ5：初めての仕事
ログインして、Dockerジョブを作成します。
{{< gallery match="images/8/*.png" >}}
ご覧のとおり、すべてがうまくいっています。
{{< gallery match="images/9/*.png" >}}
