+++
date = "2022-03-21"
title = "Grandi cose con i contenitori: registrare MP3 dalla radio"
difficulty = "level-1"
tags = ["diskstation", "Docker", "docker-compose", "docker-for-desktop", "radio", "mp3", "ripp", "streamripper", "radiorecorder"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2022/march/20220321-docker-mighty-mixxx-tapper/index.it.md"
+++
Streamripper è uno strumento per la linea di comando che può essere usato per registrare flussi MP3 o OGG/Vorbis e salvarli direttamente sul disco rigido. Le canzoni sono automaticamente nominate con il nome dell'artista e salvate individualmente, il formato è quello originariamente inviato (quindi in effetti si creano file con estensione .mp3 o .ogg). Ho trovato una grande interfaccia di radiorecorder e ho costruito un'immagine Docker da essa, vedi: https://github.com/terrorist-squad/mightyMixxxTapper/
{{< gallery match="images/1/*.png" >}}

## Opzione per i professionisti
Come utente esperto di Synology, puoi ovviamente accedere con SSH e installare l'intera configurazione tramite il file Docker Compose.
```
version: "2.0"
services:
  mealie:
    container_name: mighty-mixxx-tapper
    image: chrisknedel/mighty-mixxx-tapper:latest
    restart: always
    ports:
      - 9000:80
    environment:
      TZ: Europa/Berlin
    volumes:
      - ./ripps/:/tmp/ripps/

```

## Passo 1: cercare l'immagine Docker
Faccio clic sulla scheda "Registrazione" nella finestra di Synology Docker e cerco "mighty-mixxx-tapper". Seleziono l'immagine Docker "chrisknedel/mighty-mixxx-tapper" e poi clicco sul tag "latest".
{{< gallery match="images/2/*.png" >}}
Dopo il download dell'immagine, l'immagine è disponibile come immagine. Docker distingue tra 2 stati, container "stato dinamico" e immagine/immagine (stato fisso). Prima di poter creare un contenitore dall'immagine, devono essere fatte alcune impostazioni.
## Passo 2: Mettere l'immagine in funzione:
Faccio doppio clic sulla mia immagine "mighty-mixxx-tapper".
{{< gallery match="images/3/*.png" >}}
Poi clicco su "Impostazioni avanzate" e attivo il "Riavvio automatico". Seleziono la scheda "Volume" e clicco su "Aggiungi cartella". Lì creo una nuova cartella con questo percorso di montaggio "/tmp/ripps/".
{{< gallery match="images/4/*.png" >}}
Assegno porte fisse per il contenitore "mighty-mixxx-tapper". Senza porte fisse, potrebbe essere che il "mighty-mixxx-tapper-server" giri su una porta diversa dopo un riavvio.
{{< gallery match="images/5/*.png" >}}
Dopo queste impostazioni, mighty-mixxx-tapper-server può essere avviato! In seguito, puoi chiamare mighty-mixxx-tapper tramite l'indirizzo Ip della distazione Synology e la porta assegnata, per esempio http://192.168.21.23:8097.
{{< gallery match="images/6/*.png" >}}