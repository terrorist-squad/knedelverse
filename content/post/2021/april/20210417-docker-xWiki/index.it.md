+++
date = "2021-04-17"
title = "Grandi cose con i contenitori: eseguire il proprio xWiki sulla stazione disco Synology"
difficulty = "level-1"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "xwiki", "wiki",]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210417-docker-xWiki/index.it.md"
+++
XWiki è una piattaforma software wiki libera scritta in Java e progettata con l'estensibilità in mente. Oggi mostro come installare un servizio xWiki sulla Synology DiskStation.
## Opzione per i professionisti
Come utente esperto di Synology, puoi ovviamente accedere con SSH e installare l'intera configurazione tramite il file Docker Compose.
```
version: '3'
services:
  xwiki:
    image: xwiki:10-postgres-tomcat
    restart: always
    ports:
      - 8080:8080
    links:
      - db
    environment:
      DB_HOST: db
      DB_DATABASE: xwiki
      DB_DATABASE: xwiki
      DB_PASSWORD: xwiki
      TZ: 'Europe/Berlin'

  db:
    image: postgres:latest
    restart: always
    volumes:
      - ./postgresql:/var/lib/postgresql/data
    environment:
      - POSTGRES_USER=xwiki
      - POSTGRES_PASSWORD=xwiki
      - POSTGRES_DB=xwiki
      - TZ='Europe/Berlin'

```
Altre immagini Docker utili per uso domestico possono essere trovate nella [Dockerverse]({{< ref "dockerverse" >}} "Dockerverse").
## Passo 1: preparare la cartella wiki
Creo una nuova directory chiamata "wiki" nella directory Docker.
{{< gallery match="images/1/*.png" >}}

## Passo 2: installare il database
Dopo di che, deve essere creato un database. Faccio clic sulla scheda "Registrazione" nella finestra di Synology Docker e cerco "postgres". Seleziono l'immagine Docker "postgres" e poi clicco sul tag "latest".
{{< gallery match="images/2/*.png" >}}
Dopo il download dell'immagine, l'immagine è disponibile come immagine. Docker distingue tra 2 stati, container "stato dinamico" e immagine (stato fisso). Prima di creare un contenitore dall'immagine, devono essere fatte alcune impostazioni. Faccio doppio clic sulla mia immagine postgres.
{{< gallery match="images/3/*.png" >}}
Poi clicco su "Impostazioni avanzate" e attivo il "Riavvio automatico". Seleziono la scheda "Volume" e clicco su "Aggiungi cartella". Lì creo una nuova cartella di database con questo percorso di montaggio "/var/lib/postgresql/data".
{{< gallery match="images/4/*.png" >}}
Sotto "Impostazioni delle porte" tutte le porte sono cancellate. Questo significa che seleziono la porta "5432" e la cancello con il tasto "-".
{{< gallery match="images/5/*.png" >}}
{{<table "table table-striped table-bordered">}}
|Nome della variabile|Valore|Che cos'è?|
|--- | --- |---|
|TZ	| Europe/Berlin	|Fuso orario|
|POSTGRES_DB	| xwiki |Questo è il nome del database.|
|POSTGRES_USER	| xwiki |Nome utente del database del wiki.|
|POSTGRES_PASSWORD	| xwiki |Password dell'utente del database wiki.|
{{</table>}}
Infine, inserisco queste quattro variabili d'ambiente:Vedi:
{{< gallery match="images/6/*.png" >}}
Dopo queste impostazioni, il server Mariadb può essere avviato! Premo "Applica" dappertutto.
## Passo 3: installare xWiki
Faccio clic sulla scheda "Registrazione" nella finestra di Synology Docker e cerco "xwiki". Seleziono l'immagine Docker "xwiki" e poi clicco sul tag "10-postgres-tomcat".
{{< gallery match="images/7/*.png" >}}
Faccio doppio clic sulla mia immagine xwiki. Poi clicco su "Impostazioni avanzate" e attivo anche qui il "Riavvio automatico".
{{< gallery match="images/8/*.png" >}}
Assegno porte fisse per il contenitore "xwiki". Senza porte fisse, potrebbe essere che il "server xwiki" giri su una porta diversa dopo un riavvio.
{{< gallery match="images/9/*.png" >}}
Inoltre, deve essere creato un "link" al contenitore "postgres". Faccio clic sulla scheda "Link" e seleziono il contenitore del database. Il nome dell'alias dovrebbe essere ricordato per l'installazione del wiki.
{{< gallery match="images/10/*.png" >}}
{{<table "table table-striped table-bordered">}}
|Nome della variabile|Valore|Che cos'è?|
|--- | --- |---|
|TZ |	Europe/Berlin	|Fuso orario|
|DB_HOST	| db |Nomi alias / collegamento al contenitore|
|DB_DATABASE	| xwiki	|Dati dal passo 2|
|DB_USER	| xwiki	|Dati dal passo 2|
|DB_PASSWORD	| xwiki |Dati dal passo 2|
{{</table>}}
Infine, inserisco queste variabili d'ambiente:Vedi:
{{< gallery match="images/11/*.png" >}}
Il contenitore può ora essere avviato. Chiamo il server xWiki con l'indirizzo IP di Synology e la mia porta del container.
{{< gallery match="images/12/*.png" >}}
