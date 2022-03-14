+++
date = "2020-02-14"
title = "Nginx: Πώς μπορώ να μπλοκάρω τους χρήστες του TOR;"
difficulty = "level-3"
tags = ["blacklisting", "block", "hacker", "darknet", "nginx", "security", "tor"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2020/february/20200214-nginx-tor/index.el.md"
+++
Για τον αποκλεισμό του darknet χρειάζομαι μόνο μια λίστα IO κόμβων εξόδου Tor και τον ακόλουθο κανόνα:
```
location / { 
  limit_req zone=one; #request limit 
  limit_conn addr 
  include /etc/nginx/conf.d/tor-ips.conf;  #tor ips blocken ... 
}

```
Με το ακόλουθο σενάριο μπορώ να δημιουργήσω μια μαύρη λίστα Ip:
## Σενάριο ενημέρωσης IP

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
Το σενάριο τοποθετεί μια λίστα PI (tor-ips.conf) στον κατάλογο "/etc/nginx/conf.d/". Ελέγχει τη διαμόρφωση του διακομιστή και ενημερώνει τις ρυθμίσεις του Nginx. Οι αποκλεισμένοι χρήστες θα το δουν αυτό:
{{< gallery match="images/1/*.png" >}}