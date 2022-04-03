+++
date = "2021-05-30"
title = "自分のダークネットページを開設する"
difficulty = "level-3"
tags = ["darknet", "tor", "website", "hosting", "hidden"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/may/20210530-darknet-tor-site/index.ja.md"
+++
ビジターとしてダークネットをサーフするのは非常に簡単です。でも、どうすればOnionのページをホストできるのでしょうか？自分のダークネットページを開設する方法を紹介します。
## ステップ1：ダークネットのサーフィンはどうすればいい？
私は説明しやすいようにUbuntuのデスクトップを使用しています。そこで、以下のパッケージをインストールします。
{{< terminal >}}
sudo apt-get update
sudo apt-get install tor 

{{</ terminal >}}
そして、「/etc/privoxy/config」ファイルを編集して、次のように入力します（$ sudo vim /etc/privoxy/config）。パソコンのIPは "ifconfig "で調べることができます。
```
listen-address hier-muss-die-ip-des-rechners-rein:8118
forward-socks5 / 127.0.0.1:9050 .

```
ご覧ください。
{{< gallery match="images/1/*.png" >}}
システム起動時にTorとPrivoxyも実行されるようにするためには、やはり自動起動に入力する必要があります。
{{< terminal >}}
sudo update-rc.d tor defaults
sudo update-rc.d privoxy defaults

{{</ terminal >}}
これで、サービスを開始することができます。
{{< terminal >}}
sudo service tor restart
sudo service privoxy restart

{{</ terminal >}}
Firefoxにプロキシのアドレスを入力し、「Javascript」を無効にして「Tor test page」にアクセスします。すべてがうまくいった場合、TOR/.Onionのサイトを訪問できるようになりました。
{{< gallery match="images/2/*.png" >}}

## ステップ 2: Darknet サイトをホストするにはどうすればよいですか？
まず、HTTPサーバーをインストールする。
{{< terminal >}}
sudo apt-get install nginx

{{</ terminal >}}
そして、NGINXの設定（vim /etc/nginx/nginx.conf）を変更し、これらの機能をオフにしています。
```
server_tokens off;
port_in_redirect off;
server_name_in_redirect off;

```
ご覧ください。
{{< gallery match="images/3/*.png" >}}
ここでNGINXサーバーを再度再起動する必要があります。
{{< terminal >}}
sudo service nginx restart

{{</ terminal >}}
また、Torの設定も変更する必要があります。etc/tor/torrc」ファイルの「HiddenServiceDir」「HiddenServicePort」行をコメントアウトしています。
{{< gallery match="images/4/*.png" >}}
その後、このサービスも再起動します。
{{< terminal >}}
sudo service tor restart

{{</ terminal >}}

## レディ
var/lib/tor/hidden_servic/hostname の下に、私のDarknet/Onionアドレスがあります。これで、/var/www/html以下のすべてのコンテンツがDarkentで利用できるようになりました。
{{< gallery match="images/5/*.png" >}}
