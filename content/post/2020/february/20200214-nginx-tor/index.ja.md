+++
date = "2020-02-14"
title = "Nginx：TORユーザーをブロックするにはどうしたらいいですか？"
difficulty = "level-3"
tags = ["blacklisting", "block", "hacker", "darknet", "nginx", "security", "tor"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2020/february/20200214-nginx-tor/index.ja.md"
+++
私のダークネットブロッカーに必要なのは、Torの出口ノードのIOリストと以下のルールだけです。
```
location / { 
  limit_req zone=one; #request limit 
  limit_conn addr 
  include /etc/nginx/conf.d/tor-ips.conf;  #tor ips blocken ... 
}

```
以下のスクリプトで、IPブラックリストを作成することができます。
## IPアップデートスクリプト

```
#!/bin/sh 
# Copyright 2012, Nico R. Wohlgemuth <nico@lifeisabug.com> WGET=/usr/bin/wget 
LIST=/etc/nginx/conf.d/tor-ips.conf 

#ziel der blacklist 

LISTBAK=/etc/nginx/conf.d/tor-ips.bak 
TEMPLIST=/tmp/torlist.txt 

wget -qO- https://check.torproject.org/exit-addresses | grep ExitAddress | cut -d ' ' -f 2 | sed "s/^/deny /g; s/$/;/g" > $TEMPLIST 

if [ ! -s $TMPTEMPLIST ]; then 
  echo "error: list is empty or was not downloaded" 
  exit 1 
fi 

head -n3 $TEMPLIST 
tail -n3 $TEMPLIST 

echo -e "\ndoes this look okay? [y/n]: " 
read yesno 

if [ $yesno != "y" ]; then 
  echo "error: aborted" 
  rm $TEMPLIST exit 2 
else 
  mv $LIST $LISTBAK 
  mv $TEMPLIST $LIST 
fi 

/usr/sbin/nginx -t 
if [ $? -ne 0 ]; then 
  echo "deine config ist kaputtt" 
else 
  /bin/systemctl reload nginx 
  echo "alles ok" 
fi

```
このスクリプトは、PIリスト（tor-ips.conf）を「/etc/nginx/conf.d/」というディレクトリに配置します。サーバーの設定を確認し、Nginxの設定を更新します。ブロックされたユーザーにはその旨が表示されます。
{{< gallery match="images/1/*.png" >}}