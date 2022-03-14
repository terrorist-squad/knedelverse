+++
date = "2020-02-14"
title = "Nginx: Hur kan jag blockera TOR-användare?"
difficulty = "level-3"
tags = ["blacklisting", "block", "hacker", "darknet", "nginx", "security", "tor"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2020/february/20200214-nginx-tor/index.sv.md"
+++
För min darknet-blockerare behöver jag bara en Tor exit node IO-lista och följande regel:
```
location / { 
  limit_req zone=one; #request limit 
  limit_conn addr 
  include /etc/nginx/conf.d/tor-ips.conf;  #tor ips blocken ... 
}

```
Med följande skript kan jag skapa en svart lista över Ip-adresser:
## Skript för IP-uppdatering

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
Skriptet placerar en PI-lista (tor-ips.conf) i katalogen "/etc/nginx/conf.d/". Kontrollerar serverkonfigurationen och uppdaterar Nginx-inställningarna. Blockerade användare kommer då att se det:
{{< gallery match="images/1/*.png" >}}