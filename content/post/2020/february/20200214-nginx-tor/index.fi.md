+++
date = "2020-02-14"
title = "Nginx: Miten voin estää TOR-käyttäjät?"
difficulty = "level-3"
tags = ["blacklisting", "block", "hacker", "darknet", "nginx", "security", "tor"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2020/february/20200214-nginx-tor/index.fi.md"
+++
Tarvitsen darknet-estoani varten vain Tor exit node IO -luettelon ja seuraavan säännön:
```
location / { 
  limit_req zone=one; #request limit 
  limit_conn addr 
  include /etc/nginx/conf.d/tor-ips.conf;  #tor ips blocken ... 
}

```
Seuraavalla skriptillä voin luoda Ip-mustan listan:
## IP-päivityksen käsikirjoitus

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
Skripti sijoittaa PI-luettelon (tor-ips.conf) hakemistoon "/etc/nginx/conf.d/". Tarkistaa palvelimen kokoonpanon ja päivittää Nginx-asetukset. Estetyt käyttäjät näkevät tämän:
{{< gallery match="images/1/*.png" >}}