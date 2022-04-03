+++
date = "2021-05-30"
title = "Udemy Downloader su Synology DiskStation"
difficulty = "level-2"
tags = ["udemy", "download", "synology", "diskstation", "udemydl"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/may/20210530-udemydl/index.it.md"
+++
In questo tutorial imparerete come scaricare i corsi "udemy" per l'uso offline.
## Passo 1: Preparare la cartella Udemy
Creo una nuova directory chiamata "udemy" nella directory Docker.
{{< gallery match="images/1/*.png" >}}

## Passo 2: installare l'immagine di Ubuntu
Faccio clic sulla scheda "Registrazione" nella finestra di Synology Docker e cerco "ubunutu". Seleziono l'immagine Docker "ubunutu" e poi clicco sul tag "latest".
{{< gallery match="images/2/*.png" >}}
Faccio doppio clic sulla mia immagine di Ubuntu. Poi clicco su "Impostazioni avanzate" e attivo anche qui il "Riavvio automatico".
{{< gallery match="images/3/*.png" >}}
Seleziono la scheda "Volume" e clicco su "Aggiungi cartella". Lì creo una nuova cartella con questo percorso di montaggio "/download".
{{< gallery match="images/4/*.png" >}}
Ora il contenitore può essere avviato
{{< gallery match="images/5/*.png" >}}

## Passo 4: installare Udemy Downloader
Clicco su "Container" nella finestra di Synology Docker e faccio doppio clic sul mio "Udemy container". Poi clicco sulla scheda "Terminale" e inserisco i seguenti comandi.
{{< gallery match="images/6/*.png" >}}

##  Comandi:

{{< terminal >}}
apt-get update
apt-get install python3 python3-pip wget unzip
cd /download
wget https://github.com/r0oth3x49/udemy-dl/archive/refs/heads/master.zip
unzip master.zip
cd udemy-dl-master
pip3 pip install -r requirements.txt

{{</ terminal >}}
Screenshot:
{{< gallery match="images/7/*.png" >}}

## Passo 4: Mettere in funzione il downloader di Udemy
Ora ho bisogno di un "token di accesso". Visito Udemy con il mio browser Firefox e apro Firebug. Clicco sulla scheda "Web storage" e copio il "Token di accesso".
{{< gallery match="images/8/*.png" >}}
Creo un nuovo file nel mio contenitore:
{{< terminal >}}
echo "access_token=859wjuhV7PMLsZu15GOWias9A0iFnRjkL9pJXOv2" > /download/cookie.txt

{{</ terminal >}}
Dopo di che posso scaricare i corsi che ho già comprato:
{{< terminal >}}
cd /download
python3 udemy-dl-master/udemy-dl.py -k /download/cookie.txt https://www.udemy.com/course/ansible-grundlagen/learn/

{{</ terminal >}}
Vedere:
{{< gallery match="images/9/*.png" >}}

