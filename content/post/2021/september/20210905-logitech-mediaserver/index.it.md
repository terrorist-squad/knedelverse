+++
date = "2021-09-05"
title = "Grandi cose con i contenitori: media server Logitech sulla Synology disk station"
difficulty = "level-1"
tags = ["logitech", "synology", "diskstation", "nas", "sound-system", "multiroom"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/september/20210905-logitech-mediaserver/index.it.md"
+++
In questa esercitazione, imparerai come installare un Logitech Media Server sulla Synology DiskStation.
{{< gallery match="images/1/*.jpg" >}}

## Passo 1: preparare la cartella Logitech Media Server
Creo una nuova directory chiamata "logitechmediaserver" nella directory Docker.
{{< gallery match="images/2/*.png" >}}

## Passo 2: installare l'immagine di Logitech Mediaserver
Faccio clic sulla scheda "Registrazione" nella finestra di Synology Docker e cerco "logitechmediaserver". Seleziono l'immagine Docker "lmscommunity/logitechmediaserver" e poi clicco sul tag "latest".
{{< gallery match="images/3/*.png" >}}
Faccio doppio clic sulla mia immagine Logitech Media Server. Poi clicco su "Impostazioni avanzate" e attivo anche qui il "Riavvio automatico".
{{< gallery match="images/4/*.png" >}}
{{<table "table table-striped table-bordered">}}
|Ordner |Mountpath|
|--- |---|
|/volume1/docker/logitechmediaserver/config |/configurazione|
|/volume1/docker/logitechmediaserver/music |/musica|
|/volume1/docker/logitechmediaserver/playlist |/playlist|
{{</table>}}
Seleziono la scheda "Volume" e clicco su "Aggiungi cartella". Lì creo tre cartelle:Vedi:
{{< gallery match="images/5/*.png" >}}
Assegno delle porte fisse per il contenitore "Logitechmediaserver". Senza porte fisse, potrebbe essere che il "Logitechmediaserver server" giri su una porta diversa dopo un riavvio.
{{< gallery match="images/6/*.png" >}}
Infine, inserisco una variabile d'ambiente. La variabile "TZ" è il fuso orario "Europa/Berlino".
{{< gallery match="images/7/*.png" >}}
Dopo queste impostazioni, Logitechmediaserver-Server può essere avviato! In seguito, potete chiamare il Logitechmediaserver tramite l'indirizzo Ip della distazione Synology e la porta assegnata, per esempio http://192.168.21.23:9000 .
{{< gallery match="images/8/*.png" >}}
