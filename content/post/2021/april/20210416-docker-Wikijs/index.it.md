+++
date = "2021-04-16"
title = "Grandi cose con i container: installare Wiki.js sulla Synology Diskstation"
difficulty = "level-1"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "wikijs", "wiki"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210416-docker-Wikijs/index.it.md"
+++
Wiki.js è un potente software wiki open source che rende la documentazione un piacere con la sua semplice interfaccia. Oggi mostro come installare un servizio Wiki.js sulla Synology DiskStation.
## Opzione per i professionisti
Come utente esperto di Synology, puoi ovviamente accedere con SSH e installare l'intera configurazione tramite il file Docker Compose.
```
version: '3'
services:
  wikijs:
    image: requarks/wiki:latest
    restart: always
    ports:
      - 8082:3000
    links:
      - database
    environment:
      DB_TYPE: mysql
      DB_HOST: database
      DB_PORT: 3306
      DB_NAME: my_wiki
      DB_USER: wikiuser
      DB_PASS: my_wiki_pass
      TZ: 'Europe/Berlin'

  database:
    image: mysql
    restart: always
    expose:
      - 3306
    volumes:
       - ./mysql:/var/lib/mysql
    environment:
      MYSQL_ROOT_PASSWORD: my_wiki_pass
      MYSQL_DATABASE: my_wiki
      MYSQL_USER: wikiuser
      MYSQL_PASSWORD: my_wiki_pass

```
Puoi trovare altre immagini Docker utili per uso domestico nel Dockerverse.
## Passo 1: preparare la cartella wiki
Creo una nuova directory chiamata "wiki" nella directory Docker.
{{< gallery match="images/1/*.png" >}}

## Passo 2: installare il database
Dopo di che, si deve creare un database. Faccio clic sulla scheda "Registrazione" nella finestra di Synology Docker e cerco "mysql". Seleziono l'immagine Docker "mysql" e poi clicco sul tag "latest".
{{< gallery match="images/2/*.png" >}}
Dopo il download dell'immagine, l'immagine è disponibile come immagine. Docker distingue tra 2 stati, container "stato dinamico" e immagine (stato fisso). Prima di creare un contenitore dall'immagine, devono essere fatte alcune impostazioni. Faccio doppio clic sulla mia immagine mysql.
{{< gallery match="images/3/*.png" >}}
Poi clicco su "Impostazioni avanzate" e attivo il "Riavvio automatico". Seleziono la scheda "Volume" e clicco su "Aggiungi cartella". Lì creo una nuova cartella di database con questo percorso di montaggio "/var/lib/mysql".
{{< gallery match="images/4/*.png" >}}
Sotto "Impostazioni delle porte" tutte le porte sono cancellate. Questo significa che seleziono la porta "3306" e la cancello con il tasto "-".
{{< gallery match="images/5/*.png" >}}
{{<table "table table-striped table-bordered">}}
|Nome della variabile|Valore|Che cos'è?|
|--- | --- |---|
|TZ	| Europe/Berlin |Fuso orario|
|MYSQL_ROOT_PASSWORD	| my_wiki_pass |Password principale del database.|
|MYSQL_DATABASE |	my_wiki |Questo è il nome del database.|
|MYSQL_USER	| wikiuser |Nome utente del database del wiki.|
|MYSQL_PASSWORD |	my_wiki_pass	|Password dell'utente del database wiki.|
{{</table>}}
Infine, inserisco queste quattro variabili d'ambiente:Vedi:
{{< gallery match="images/6/*.png" >}}
Dopo queste impostazioni, il server Mariadb può essere avviato! Premo "Applica" dappertutto.
## Passo 3: installare Wiki.js
Faccio clic sulla scheda "Registrazione" nella finestra di Synology Docker e cerco "wiki". Seleziono l'immagine Docker "requarks/wiki" e poi clicco sul tag "latest".
{{< gallery match="images/7/*.png" >}}
Faccio doppio clic sulla mia immagine WikiJS. Poi clicco su "Impostazioni avanzate" e attivo anche qui il "Riavvio automatico".
{{< gallery match="images/8/*.png" >}}
Assegno porte fisse per il contenitore "WikiJS". Senza porte fisse, potrebbe essere che il "server bookstack" giri su una porta diversa dopo un riavvio.
{{< gallery match="images/9/*.png" >}}
Inoltre, un "link" al contenitore "mysql" deve ancora essere creato. Faccio clic sulla scheda "Link" e seleziono il contenitore del database. Il nome dell'alias dovrebbe essere ricordato per l'installazione del wiki.
{{< gallery match="images/10/*.png" >}}
{{<table "table table-striped table-bordered">}}
|Nome della variabile|Valore|Che cos'è?|
|--- | --- |---|
|TZ	| Europe/Berlin	|Fuso orario|
|DB_HOST	| wiki-db	|Nomi alias / collegamento al contenitore|
|DB_TYPE	| mysql	||
|DB_PORT	| 3306	 ||
|DB_PASSWORD	| my_wiki	|Dati dal passo 2|
|DB_USER	| wikiuser |Dati dal passo 2|
|DB_PASS	| my_wiki_pass	|Dati dal passo 2|
{{</table>}}
Infine, inserisco queste variabili d'ambiente:Vedi:
{{< gallery match="images/11/*.png" >}}
Il contenitore può ora essere avviato. Chiamo il server Wiki.js con l'indirizzo IP di Synology e la mia porta contenitore/3000.
{{< gallery match="images/12/*.png" >}}