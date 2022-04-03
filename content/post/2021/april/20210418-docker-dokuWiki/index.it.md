+++
date = "2021-04-18"
title = "Grandi cose con i contenitori: installare il proprio dokuWiki sulla stazione disco Synology"
difficulty = "level-2"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "dokuwiki", "wiki"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210418-docker-dokuWiki/index.it.md"
+++
DokuWiki è un software wiki open source conforme agli standard, facile da usare e allo stesso tempo estremamente versatile. Oggi mostro come installare un servizio DokuWiki sulla Synology disk station.
## Opzione per i professionisti
Come utente esperto di Synology, puoi ovviamente accedere con SSH e installare l'intera configurazione tramite il file Docker Compose.
```
version: '3'
services:
  dokuwiki:
    image:  bitnami/dokuwiki:latest
    restart: always
    ports:
      - 8080:8080
      - 8443:8443
    environment:
      TZ: 'Europe/Berlin'
      DOKUWIKI_USERNAME: 'admin'
      DOKUWIKI_FULL_NAME: 'wiki'
      DOKUWIKI_PASSWORD: 'password'
    volumes:
      - ./data:/bitnami/dokuwiki

```
Altre immagini Docker utili per uso domestico possono essere trovate nella [Dockerverse]({{< ref "dockerverse" >}} "Dockerverse").
## Passo 1: preparare la cartella wiki
Creo una nuova directory chiamata "wiki" nella directory Docker.
{{< gallery match="images/1/*.png" >}}

## Passo 2: installare DokuWiki
Dopo di che, deve essere creato un database. Faccio clic sulla scheda "Registrazione" nella finestra di Synology Docker e cerco "dokuwiki". Seleziono l'immagine Docker "bitnami/dokuwiki" e poi clicco sul tag "latest".
{{< gallery match="images/2/*.png" >}}
Dopo il download dell'immagine, l'immagine è disponibile come immagine. Docker distingue tra 2 stati, container "stato dinamico" e immagine (stato fisso). Prima di creare un contenitore dall'immagine, devono essere fatte alcune impostazioni. Faccio doppio clic sulla mia immagine dokuwiki.
{{< gallery match="images/3/*.png" >}}
Assegno porte fisse per il contenitore "dokuwiki". Senza porte fisse, potrebbe essere che il "server dokuwiki" giri su una porta diversa dopo un riavvio.
{{< gallery match="images/4/*.png" >}}
{{<table "table table-striped table-bordered">}}
|Nome della variabile|Valore|Che cos'è?|
|--- | --- |---|
|TZ	| Europe/Berlin	|Fuso orario|
|DOKUWIKI_USERNAME	| admin|Nome utente amministratore|
|DOKUWIKI_FULL_NAME |	wiki	|Nome WIki|
|DOKUWIKI_PASSWORD	| password	|Password dell'amministratore|
{{</table>}}
Infine, inserisco queste variabili d'ambiente:Vedi:
{{< gallery match="images/5/*.png" >}}
Il contenitore può ora essere avviato. Chiamo il server dokuWIki con l'indirizzo IP del Synology e la mia porta del container.
{{< gallery match="images/6/*.png" >}}

