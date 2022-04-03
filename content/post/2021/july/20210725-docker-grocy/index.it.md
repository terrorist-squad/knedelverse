+++
date = "2021-07-25"
title = "Grandi cose con i contenitori: gestione del frigorifero con Grocy"
difficulty = "level-1"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "kühlschrank", "erp", "mhd", "Speispläne", "cms", "Cafe", "Bistro"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/july/20210725-docker-grocy/index.it.md"
+++
Con Grocy è possibile gestire un'intera casa, un ristorante, un caffè, un bistrot o un mercato alimentare. È possibile gestire frigoriferi, menu, attività, liste della spesa e la durata di conservazione del cibo.
{{< gallery match="images/1/*.png" >}}
Oggi mostro come installare un servizio Grocy sulla Synology disk station.
## Opzione per i professionisti
Come utente esperto di Synology, puoi ovviamente accedere con SSH e installare l'intera configurazione tramite il file Docker Compose.
```
version: "2.1"
services:
  grocy:
    image: ghcr.io/linuxserver/grocy
    container_name: grocy
    environment:
      - PUID=1024
      - PGID=100
      - TZ=Europe/Berlin
    volumes:
      - ./data:/config
    ports:
      - 9283:80
    restart: unless-stopped

```
Altre immagini Docker utili per uso domestico possono essere trovate nella [Dockerverse]({{< ref "dockerverse" >}} "Dockerverse").
## Passo 1: Preparare la cartella Grocy
Creo una nuova directory chiamata "grocy" nella directory Docker.
{{< gallery match="images/2/*.png" >}}

## Passo 2: installare Grocy
Faccio clic sulla scheda "Registrazione" nella finestra di Synology Docker e cerco "Grocy". Seleziono l'immagine Docker "linuxserver/grocy:latest" e poi clicco sul tag "latest".
{{< gallery match="images/3/*.png" >}}
Faccio doppio clic sulla mia immagine Grocy.
{{< gallery match="images/4/*.png" >}}
Poi clicco su "Impostazioni avanzate" e attivo anche qui il "Riavvio automatico". Seleziono la scheda "Volume" e clicco su "Aggiungi cartella". Lì creo una nuova cartella con questo percorso di montaggio "/config".
{{< gallery match="images/5/*.png" >}}
Assegno delle porte fisse per il contenitore "Grocy". Senza porte fisse, potrebbe essere che il "server Grocy" giri su una porta diversa dopo un riavvio.
{{< gallery match="images/6/*.png" >}}
{{<table "table table-striped table-bordered">}}
|Nome della variabile|Valore|Che cos'è?|
|--- | --- |---|
|TZ | Europe/Berlin |Fuso orario|
|PUID | 1024 |ID utente da Synology Admin User|
|PGID |	100 |ID gruppo da Synology Admin User|
{{</table>}}
Infine, inserisco queste variabili d'ambiente:Vedi:
{{< gallery match="images/7/*.png" >}}
Il contenitore può ora essere avviato. Richiamo il server Grocy con l'indirizzo IP di Synology e la mia porta del container e accedo con il nome utente "admin" e la password "admin".
{{< gallery match="images/8/*.png" >}}

