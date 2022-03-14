+++
date = "2021-05-30"
title = "自分のDarknetページを立ち上げる"
difficulty = "level-3"
tags = ["darknet", "tor", "website", "hosting", "hidden"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/may/20210530-darknet-tor-site/index.ja.md"
+++
ビジターとしてダークネットをサーフするのはとても簡単です。しかし、どうやってOnionのページをホストすることができますか？自分のDarknetページを開設する方法を紹介します。
## ステップ1：ダークネットをサーフィンするにはどうしたらいいですか？
私はUbuntuのデスクトップを使っているので、分かりやすいと思います。そこで以下のパッケージをインストールします。
{{< terminal >}}
sudo apt-get update
sudo apt-get install tor 

{{</ terminal >}}
そして、「/etc/privoxy/config」ファイルを編集し、以下のように入力します（$ sudo vim /etc/privoxy/config）。コンピュータのIPは「ifconfig」で調べることができます。
```
listen-address hier-muss-die-ip-des-rechners-rein:8118
forward-socks5 / 127.0.0.1:9050 .

```
見てください。
{{< gallery match="images/1/*.png" >}}
TorとPrivoxyがシステム起動時にも実行されるようにするために、やはりautostartに入力する必要があります。
{{< terminal >}}
sudo update-rc.d tor defaults
sudo update-rc.d privoxy defaults

{{</ terminal >}}
これで、サービスを開始することができます。
{{< terminal >}}
sudo service tor restart
sudo service privoxy restart

{{</ terminal >}}
私はFirefoxにプロキシのアドレスを入力し、「Javascript」を無効にして「Torテストページ」にアクセスします。すべてがうまくいけば、TOR/.Onionのサイトにアクセスできるようになります。
{{< gallery match="images/2/*.png" >}}

## ステップ2：どのようにしてDarknetサイトをホストすることができますか？
まず、HTTPサーバーをインストールします。
{{< terminal >}}
sudo apt-get install nginx

{{</ terminal >}}
そして、NGINXの設定を変更し（vim /etc/nginx/nginx.conf）、これらの機能をオフにします。
```
server_tokens off;
port_in_redirect off;
server_name_in_redirect off;

```
見てください。
{{< gallery match="images/3/*.png" >}}
NGINXサーバーを再起動する必要があります。
{{< terminal >}}
sudo service nginx restart

{{</ terminal >}}
また、Torの設定にも変更を加える必要があります。etc/tor/torrc "ファイルの "HiddenServiceDir "と "HiddenServicePort "の行をコメントします。
{{< gallery match="images/4/*.png" >}}
その後、このサービスも再起動します。
{{< terminal >}}
sudo service tor restart

{{</ terminal >}}

## 準備完了
var/lib/tor/hidden_servic/hostname "の下に、私のDarknet/Onionアドレスがあります。これで、/var/www/html以下のすべてのコンテンツがDarkentに表示されるようになりました。
{{< gallery match="images/5/*.png" >}}