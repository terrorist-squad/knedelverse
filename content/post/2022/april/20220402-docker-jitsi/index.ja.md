+++
date = "2022-04-02"
title = "コンテナで素敵なこと：Jitsyのインストール"
difficulty = "level-5"
tags = ["Jitsi", "docker", "docker-compose", "meeting", "video", "server", "synology"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2022/april/20220402-docker-jitsi/index.ja.md"
+++
Jitsiを使えば、安全なビデオ会議ソリューションを構築し、展開することができます。今日は、サーバーにJitsiサービスをインストールする方法を紹介します。参考：https://jitsi.github.io/handbook/docs/devops-guide/devops-guide-docker/ .
## ステップ1：「jitsi」フォルダの作成
インストール用に「jitsi」というディレクトリを新規に作成します。
{{< terminal >}}
mkdir jitsi/
wget https://github.com/jitsi/docker-jitsi-meet/archive/refs/tags/stable-7001.zip
unzip  stable-7001.zip -d jitsi/
rm stable-7001.zip 
cd /docker/jitsi/docker-jitsi-meet-stable-7001

{{</ terminal >}}

## ステップ2：コンフィギュレーション
今度は、標準の構成をコピーして、それを適応させる。
{{< terminal >}}
cp env.example .env

{{</ terminal >}}
ご覧ください。
{{< gallery match="images/1/*.png" >}}
.envファイルのセキュリティオプションで強力なパスワードを使用するために、以下のbashスクリプトを一度実行する必要があります。
{{< terminal >}}
./gen-passwords.sh

{{</ terminal >}}
では、Jitsi用のフォルダをもう少し作ってみます。
{{< terminal >}}
mkdir -p ./jitsi-meet-cfg/{web/crontabs,web/letsencrypt,transcripts,prosody/config,prosody/prosody-plugins-custom,jicofo,jvb,jigasi,jibri}

{{</ terminal >}}
その後、Jitsiサーバーを起動することができます。
{{< terminal >}}
docker-compose up

{{</ terminal >}}
その後、Jitsiサーバーを使用することができます!
{{< gallery match="images/2/*.png" >}}

