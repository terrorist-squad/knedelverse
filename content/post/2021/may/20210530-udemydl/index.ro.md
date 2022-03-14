+++
date = "2021-05-30"
title = "Udemy Downloader pe Synology DiskStation"
difficulty = "level-2"
tags = ["udemy", "download", "synology", "diskstation", "udemydl"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/may/20210530-udemydl/index.ro.md"
+++
În acest tutorial veți învăța cum să descărcați cursurile "udemy" pentru utilizare offline.
## Pasul 1: Pregătiți dosarul Udemy
Creez un nou director numit "udemy" în directorul Docker.
{{< gallery match="images/1/*.png" >}}

## Pasul 2: Instalați imaginea Ubuntu
Fac clic pe fila "Înregistrare" din fereastra Synology Docker și caut "ubunutu". Selectez imaginea Docker "ubunutu" și apoi fac clic pe eticheta "latest".
{{< gallery match="images/2/*.png" >}}
Fac dublu clic pe imaginea mea Ubuntu. Apoi fac clic pe "Setări avansate" și activez și aici "Repornire automată".
{{< gallery match="images/3/*.png" >}}
Selectez fila "Volume" și fac clic pe "Add folder". Acolo creez un nou dosar cu această cale de montare "/download".
{{< gallery match="images/4/*.png" >}}
Acum containerul poate fi pornit
{{< gallery match="images/5/*.png" >}}

## Pasul 4: Instalați Udemy Downloader
Fac clic pe "Container" în fereastra Synology Docker și dau dublu clic pe "Containerul Udemy". Apoi fac clic pe fila "Terminal" și introduc următoarele comenzi.
{{< gallery match="images/6/*.png" >}}

##  Comenzi:

{{< terminal >}}
apt-get update
apt-get install python3 python3-pip wget unzip
cd /download
wget https://github.com/r0oth3x49/udemy-dl/archive/refs/heads/master.zip
unzip master.zip
cd udemy-dl-master
pip3 pip install -r requirements.txt

{{</ terminal >}}
Capturi de ecran:
{{< gallery match="images/7/*.png" >}}

## Pasul 4: Punerea în funcțiune a descărcătorului Udemy
Acum am nevoie de un "token de acces". Vizitez Udemy cu browserul meu Firefox și deschid Firebug. Fac clic pe fila "Web storage" și copiez "Access token".
{{< gallery match="images/8/*.png" >}}
Creez un nou fișier în containerul meu:
{{< terminal >}}
echo "access_token=859wjuhV7PMLsZu15GOWias9A0iFnRjkL9pJXOv2" > /download/cookie.txt

{{</ terminal >}}
După aceea, pot descărca cursurile pe care le-am cumpărat deja:
{{< terminal >}}
cd /download
python3 udemy-dl-master/udemy-dl.py -k /download/cookie.txt https://www.udemy.com/course/ansible-grundlagen/learn/

{{</ terminal >}}
A se vedea:
{{< gallery match="images/9/*.png" >}}
