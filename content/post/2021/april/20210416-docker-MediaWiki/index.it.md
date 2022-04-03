+++
date = "2021-04-16"
title = "Grandi cose con i contenitori: installare il proprio MediaWiki sulla stazione disco Synology"
difficulty = "level-1"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "mediawiki", "wiki"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210416-docker-MediaWiki/index.it.md"
+++
MediaWiki è un sistema wiki basato su PHP che è disponibile gratuitamente come prodotto open source. Oggi mostro come installare un servizio MediaWiki sulla stazione disco Synology.
## Opzione per i professionisti
Come utente esperto di Synology, puoi ovviamente accedere con SSH e installare l'intera configurazione tramite il file Docker Compose.
```
version: '3'
services:
  mediawiki:
    image: mediawiki
    restart: always
    ports:
      - 8081:80
    links:
      - database
    volumes:
      - ./images:/var/www/html/images
      # After initial setup, download LocalSettings.php to the same directory as
      # this yaml and uncomment the following line and use compose to restart
      # the mediawiki service
      # - ./LocalSettings.php:/var/www/html/LocalSettings.php

  database:
    image: mariadb
    restart: always
    volumes:
       - ./mysql:/var/lib/mysql
    environment:
      # @see https://phabricator.wikimedia.org/source/mediawiki/browse/master/includes/DefaultSettings.php
      MYSQL_ROOT_PASSWORD: my_wiki_pass1
      MYSQL_DATABASE: my_wiki
      MYSQL_USER: wikiuser
      MYSQL_PASSWORD: my_wiki_pass

```
Altre immagini Docker utili per uso domestico possono essere trovate nella [Dockerverse]({{< ref "dockerverse" >}} "Dockerverse").
## Passo 1: Preparare la cartella MediaWiki
Creo una nuova directory chiamata "wiki" nella directory Docker.
{{< gallery match="images/1/*.png" >}}

## Passo 2: installare il database
Dopo di che, si deve creare un database. Faccio clic sulla scheda "Registrazione" nella finestra di Synology Docker e cerco "mariadb". Seleziono l'immagine Docker "mariadb" e poi clicco sul tag "latest".
{{< gallery match="images/2/*.png" >}}
Dopo il download dell'immagine, l'immagine è disponibile come immagine. Docker distingue tra 2 stati, container "stato dinamico" e immagine (stato fisso). Prima di creare un contenitore dall'immagine, devono essere fatte alcune impostazioni. Faccio doppio clic sulla mia immagine mariadb.
{{< gallery match="images/3/*.png" >}}
Poi clicco su "Impostazioni avanzate" e attivo il "Riavvio automatico". Seleziono la scheda "Volume" e clicco su "Aggiungi cartella". Lì creo una nuova cartella di database con questo percorso di montaggio "/var/lib/mysql".
{{< gallery match="images/4/*.png" >}}
Sotto "Impostazioni delle porte" tutte le porte sono cancellate. Questo significa che seleziono la porta "3306" e la cancello con il tasto "-".
{{< gallery match="images/5/*.png" >}}
{{<table "table table-striped table-bordered">}}
|Nome della variabile|Valore|Che cos'è?|
|--- | --- |---|
|TZ	| Europe/Berlin	|Fuso orario|
|MYSQL_ROOT_PASSWORD	| my_wiki_pass	|Password principale del database.|
|MYSQL_DATABASE |	my_wiki	|Questo è il nome del database.|
|MYSQL_USER	| wikiuser |Nome utente del database del wiki.|
|MYSQL_PASSWORD	| my_wiki_pass |Password dell'utente del database wiki.|
{{</table>}}
Infine, inserisco queste variabili d'ambiente:Vedi:
{{< gallery match="images/6/*.png" >}}
Dopo queste impostazioni, il server Mariadb può essere avviato! Premo "Applica" dappertutto.
## Passo 3: installare MediaWiki
Faccio clic sulla scheda "Registrazione" nella finestra di Synology Docker e cerco "mediawiki". Seleziono l'immagine Docker "mediawiki" e poi clicco sul tag "latest".
{{< gallery match="images/7/*.png" >}}
Faccio doppio clic sulla mia immagine Mediawiki.
{{< gallery match="images/8/*.png" >}}
Poi clicco su "Impostazioni avanzate" e attivo anche qui il "Riavvio automatico". Seleziono la scheda "Volume" e clicco su "Aggiungi cartella". Lì creo una nuova cartella con questo percorso di montaggio "/var/www/html/images".
{{< gallery match="images/9/*.png" >}}
Assegno porte fisse per il contenitore "MediaWiki". Senza porte fisse, potrebbe essere che il "server MediaWiki" giri su una porta diversa dopo un riavvio.
{{< gallery match="images/10/*.png" >}}
Inoltre, un "link" al contenitore "mariadb" deve ancora essere creato. Faccio clic sulla scheda "Link" e seleziono il contenitore del database. Il nome dell'alias dovrebbe essere ricordato per l'installazione del wiki.
{{< gallery match="images/11/*.png" >}}
Infine, inserisco una variabile d'ambiente "TZ" con valore "Europe/Berlin".
{{< gallery match="images/12/*.png" >}}
Il contenitore può ora essere avviato. Chiamo il server Mediawiki con l'indirizzo IP di Synology e la mia porta del container. Sotto Database server inserisco il nome dell'alias del contenitore del database. Inserisco anche il nome del database, il nome utente e la password del "Passo 2".
{{< gallery match="images/13/*.png" >}}
