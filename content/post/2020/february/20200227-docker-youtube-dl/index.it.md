+++
date = "2020-02-27"
title = "Grandi cose con i container: esecuzione del downloader di Youtube su Synology Diskstation"
difficulty = "level-1"
tags = ["Docker", "docker-compose", "download", "linux", "Synology", "video", "youtube"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2020/february/20200227-docker-youtube-dl/index.it.md"
+++
Molti dei miei amici sanno che gestisco un portale privato di video apprendimento sul mio Homelab - Network. Ho salvato sul mio NAS i video corsi delle passate iscrizioni al portale di apprendimento e i buoni tutorial di Youtube per l'uso offline.
{{< gallery match="images/1/*.png" >}}
Nel corso del tempo ho raccolto 8845 video corsi con 282616 video individuali. Il tempo di esecuzione totale è pari a circa 2 anni. In questo tutorial mostro come fare il backup di buoni tutorial di Youtube con un servizio di download di Docker per scopi offline.
## Opzione per i professionisti
Come utente esperto di Synology, puoi ovviamente accedere con SSH e installare l'intera configurazione tramite il file Docker Compose.
```
version: "2"
services:
  youtube-dl:
    image: modenaf360/youtube-dl-nas
    container_name: youtube-dl
    environment:
      - MY_ID=admin
      - MY_PW=admin
    volumes:
      - ./YouTube:/downfolder
    ports:
      - 8080:8080
    restart: unless-stopped

```

## Passo 1
Prima creo una cartella per i download. Vado in "Controllo sistema" -> "Cartella condivisa" e creo una nuova cartella chiamata "Download".
{{< gallery match="images/2/*.png" >}}

## Passo 2: cercare l'immagine Docker
Faccio clic sulla scheda "Registrazione" nella finestra di Synology Docker e cerco "youtube-dl-nas". Seleziono l'immagine Docker "modenaf360/youtube-dl-nas" e poi clicco sul tag "latest".
{{< gallery match="images/3/*.png" >}}
Dopo il download dell'immagine, l'immagine è disponibile come immagine. Docker distingue tra 2 stati, container "stato dinamico" e immagine/immagine (stato fisso). Prima di poter creare un contenitore dall'immagine, devono essere fatte alcune impostazioni.
## Passo 3: Mettere l'immagine in funzione:
Faccio doppio clic sulla mia immagine youtube-dl-nas.
{{< gallery match="images/4/*.png" >}}
Poi clicco su "Impostazioni avanzate" e attivo il "Riavvio automatico". Seleziono la scheda "Volume" e clicco su "Aggiungi cartella". Lì creo una nuova cartella di database con questo percorso di montaggio "/downfolder".
{{< gallery match="images/5/*.png" >}}
Assegno porte fisse per il contenitore "Youtube Downloader". Senza porte fisse, potrebbe essere che il "Youtube Downloader" funzioni su una porta diversa dopo un riavvio.
{{< gallery match="images/6/*.png" >}}
Infine, inserisco due variabili d'ambiente. La variabile "MY_ID" è il mio nome utente e "MY_PW" è la mia password.
{{< gallery match="images/7/*.png" >}}
Dopo queste impostazioni, Downloader può essere avviato! In seguito, potete chiamare il downloader tramite l'indirizzo Ip della distazione Synology e la porta assegnata, per esempio http://192.168.21.23:8070 .
{{< gallery match="images/8/*.png" >}}
Per l'autenticazione, prendete il nome utente e la password da MY_ID e MY_PW.
## Passo 4: Andiamo
Ora gli URL dei video di Youtube e delle playlist possono essere inseriti nel campo "URL" e tutti i video finiscono automaticamente nella cartella di download della Synology disk station.
{{< gallery match="images/9/*.png" >}}
Cartella di download:
{{< gallery match="images/10/*.png" >}}