+++
date = "2021-04-16"
title = "Grandi cose con i contenitori: il proprio Wiki Bookstack sulla Synology DiskStation"
difficulty = "level-1"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "bookstack", "wiki"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210416-docker-Bookstack/index.it.md"
+++
Bookstack è un'alternativa "open source" a MediaWiki o Confluence. Oggi mostro come installare un servizio Bookstack sulla Synology disk station.
## Opzione per i professionisti
Come utente esperto di Synology, puoi ovviamente accedere con SSH e installare l'intera configurazione tramite il file Docker Compose.
```
version: '3'
services:
  bookstack:
    image: solidnerd/bookstack:0.27.4-1
    restart: always
    ports:
      - 8080:8080
    links:
      - database
    environment:
      DB_HOST: database:3306
      DB_DATABASE: my_wiki
      DB_USERNAME: wikiuser
      DB_PASSWORD: my_wiki_pass
      
  database:
    image: mariadb
    restart: always
    volumes:
       - ./mysql:/var/lib/mysql
    environment:
      MYSQL_ROOT_PASSWORD: my_wiki_pass1
      MYSQL_DATABASE: my_wiki
      MYSQL_USER: wikiuser
      MYSQL_PASSWORD: my_wiki_pass

```
Altre immagini Docker utili per uso domestico possono essere trovate nella [Dockerverse]({{< ref "dockerverse" >}} "Dockerverse").
## Passo 1: Preparare la cartella bookstack
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
|TZ	| Europe/Berlin |Fuso orario|
|MYSQL_ROOT_PASSWORD	|  my_wiki_pass |Password principale del database.|
|MYSQL_DATABASE | 	my_wiki	|Questo è il nome del database.|
|MYSQL_USER	|  wikiuser	|Nome utente del database del wiki.|
|MYSQL_PASSWORD	|  my_wiki_pass	|Password dell'utente del database wiki.|
{{</table>}}
Infine, inserisco queste variabili d'ambiente:Vedi:
{{< gallery match="images/6/*.png" >}}
Dopo queste impostazioni, il server Mariadb può essere avviato! Premo "Applica" dappertutto.
## Passo 3: installare Bookstack
Faccio clic sulla scheda "Registrazione" nella finestra di Synology Docker e cerco "bookstack". Seleziono l'immagine Docker "solidnerd/bookstack" e poi clicco sul tag "latest".
{{< gallery match="images/7/*.png" >}}
Faccio doppio clic sulla mia immagine Bookstack. Poi clicco su "Impostazioni avanzate" e attivo anche qui il "Riavvio automatico".
{{< gallery match="images/8/*.png" >}}
Assegno delle porte fisse per il contenitore "bookstack". Senza porte fisse, potrebbe essere che il "server bookstack" giri su una porta diversa dopo un riavvio. La prima porta del contenitore può essere cancellata. L'altra porta dovrebbe essere ricordata.
{{< gallery match="images/9/*.png" >}}
Inoltre, un "link" al contenitore "mariadb" deve ancora essere creato. Faccio clic sulla scheda "Link" e seleziono il contenitore del database. Il nome dell'alias dovrebbe essere ricordato per l'installazione del wiki.
{{< gallery match="images/10/*.png" >}}
{{<table "table table-striped table-bordered">}}
|Nome della variabile|Valore|Che cos'è?|
|--- | --- |---|
|TZ	| Europe/Berlin |Fuso orario|
|DB_HOST	| wiki-db:3306	|Nomi alias / collegamento al contenitore|
|DB_DATABASE	| my_wiki |Dati dal passo 2|
|DB_USERNAME	| wikiuser |Dati dal passo 2|
|DB_PASSWORD	| my_wiki_pass	|Dati dal passo 2|
{{</table>}}
Infine, inserisco queste variabili d'ambiente:Vedi:
{{< gallery match="images/11/*.png" >}}
Il contenitore può ora essere avviato. Potrebbe essere necessario un po' di tempo per creare il database. Il comportamento può essere osservato attraverso i dettagli del contenitore.
{{< gallery match="images/12/*.png" >}}
Chiamo il server Bookstack con l'indirizzo IP del Synology e la mia porta del container. Il nome di login è "admin@admin.com" e la password è "password".
{{< gallery match="images/13/*.png" >}}
