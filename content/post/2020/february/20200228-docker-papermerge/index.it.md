+++
date = "2020-02-28"
title = "Grandi cose con i container: eseguire Papermerge DMS su un Synology NAS"
difficulty = "level-3"
tags = ["archiv", "automatisch", "dms", "Docker", "Document-Managment-System", "google", "ocr", "papermerge", "Synology", "tesseract", "texterkennung"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2020/february/20200228-docker-papermerge/index.it.md"
+++
Papermerge è un giovane sistema di gestione dei documenti (DMS) che può assegnare ed elaborare automaticamente i documenti. In questo tutorial mostro come ho installato Papermerge sulla mia Synology disk station e come funziona il DMS.
## Opzione per i professionisti
Come utente esperto di Synology, puoi ovviamente accedere con SSH e installare l'intera configurazione tramite il file Docker Compose.
```
version: "2.1"
services:
  papermerge:
    image: ghcr.io/linuxserver/papermerge
    container_name: papermerge
    environment:
      - PUID=1024
      - PGID=100
      - TZ=Europe/Berlin
    volumes:
      - ./config>:/config
      - ./appdata/data>:/data
    ports:
      - 8090:8000
    restart: unless-stopped

```

## Passo 1: Creare la cartella
Prima creo una cartella per l'unione della carta. Vado in "Controllo sistema" -> "Cartella condivisa" e creo una nuova cartella chiamata "Archivio documenti".
{{< gallery match="images/1/*.png" >}}
Passo 2: Cercare l'immagine DockerFaccio clic sulla scheda "Registrazione" nella finestra Synology Docker e cerco "Papermerge". Seleziono l'immagine Docker "linuxserver/papermerge" e poi clicco sul tag "latest".
{{< gallery match="images/2/*.png" >}}
Dopo il download dell'immagine, l'immagine è disponibile come immagine. Docker distingue tra 2 stati, container "stato dinamico" e immagine/immagine (stato fisso). Prima di poter creare un contenitore dall'immagine, devono essere fatte alcune impostazioni.
## Passo 3: Mettere l'immagine in funzione:
Faccio doppio clic sulla mia immagine di fusione della carta.
{{< gallery match="images/3/*.png" >}}
Poi clicco su "Impostazioni avanzate" e attivo il "Riavvio automatico". Seleziono la scheda "Volume" e clicco su "Aggiungi cartella". Lì creo una nuova cartella di database con questo percorso di montaggio "/data".
{{< gallery match="images/4/*.png" >}}
Qui memorizzo anche una seconda cartella che includo con il percorso di montaggio "/config". Non ha molta importanza dove si trova questa cartella. Tuttavia, è importante che appartenga all'utente admin di Synology.
{{< gallery match="images/5/*.png" >}}
Assegno porte fisse per il contenitore "Papermerge". Senza porte fisse, potrebbe essere che il "server Papermerge" giri su una porta diversa dopo un riavvio.
{{< gallery match="images/6/*.png" >}}
Infine, inserisco tre variabili d'ambiente. La variabile "PUID" è l'ID utente e "PGID" è l'ID del gruppo del mio utente admin. Potete scoprire il PGID/PUID via SSH con il comando "cat /etc/passwd | grep admin".
{{< gallery match="images/7/*.png" >}}
Dopo queste impostazioni, il server Papermerge può essere avviato! In seguito, Papermerge può essere chiamato tramite l'indirizzo Ip della distazione Synology e la porta assegnata, per esempio http://192.168.21.23:8095.
{{< gallery match="images/8/*.png" >}}
Il login di default è admin con password admin.
## Come funziona Papermerge?
Papermerge analizza il testo di documenti e immagini. Papermerge usa una libreria OCR/"optical character recognition" chiamata tesseract, pubblicata da Goolge.
{{< gallery match="images/9/*.png" >}}
Ho creato una cartella chiamata "Tutto con Lorem" per testare l'assegnazione automatica dei documenti. Poi ho cliccato insieme un nuovo modello di riconoscimento nella voce di menu "Automatizza".
{{< gallery match="images/10/*.png" >}}
Tutti i nuovi documenti che contengono la parola "Lorem" sono messi nella cartella "Everything with Lorem" e contrassegnati con "has-lorem". È importante usare una virgola nei tag, altrimenti il tag non verrà impostato. Se carichi un documento corrispondente, sarà etichettato e ordinato.
{{< gallery match="images/11/*.png" >}}