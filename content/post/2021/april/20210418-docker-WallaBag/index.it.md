+++
date = "2021-04-18"
title = "Grandi cose con i contenitori: possedere WallaBag sulla stazione disco Synology"
difficulty = "level-1"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "archiv", "wallabag"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210418-docker-WallaBag/index.it.md"
+++
Wallabag è un programma per archiviare siti web o articoli interessanti. Oggi mostro come installare un servizio Wallabag sulla stazione disco Synology.
## Opzione per i professionisti
Come utente esperto di Synology, puoi ovviamente accedere con SSH e installare l'intera configurazione tramite il file Docker Compose.
```
version: '3'
services:
  wallabag:
    image: wallabag/wallabag
    environment:
      - MYSQL_ROOT_PASSWORD=wallaroot
      - SYMFONY__ENV__DATABASE_DRIVER=pdo_mysql
      - SYMFONY__ENV__DATABASE_HOST=db
      - SYMFONY__ENV__DATABASE_PORT=3306
      - SYMFONY__ENV__DATABASE_NAME=wallabag
      - SYMFONY__ENV__DATABASE_USER=wallabag
      - SYMFONY__ENV__DATABASE_PASSWORD=wallapass
      - SYMFONY__ENV__DATABASE_CHARSET=utf8mb4
      - SYMFONY__ENV__DOMAIN_NAME=http://192.168.178.50:8089
      - SYMFONY__ENV__SERVER_NAME="Your wallabag instance"
      - SYMFONY__ENV__FOSUSER_CONFIRMATION=false
      - SYMFONY__ENV__TWOFACTOR_AUTH=false
    ports:
      - "8089:80"
    volumes:
      - ./wallabag/images:/var/www/wallabag/web/assets/images

  db:
    image: mariadb
    environment:
      - MYSQL_ROOT_PASSWORD=wallaroot
    volumes:
      - ./mariadb:/var/lib/mysql

```
Altre immagini Docker utili per uso domestico possono essere trovate nella [Dockerverse]({{< ref "dockerverse" >}} "Dockerverse").
## Passo 1: Preparare la cartella wallabag
Creo una nuova directory chiamata "wallabag" nella directory Docker.
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
|TZ| Europe/Berlin	|Fuso orario|
|MYSQL_ROOT_PASSWORD	 | wallaroot |Password principale del database.|
{{</table>}}
Infine, inserisco queste variabili d'ambiente:Vedi:
{{< gallery match="images/6/*.png" >}}
Dopo queste impostazioni, il server Mariadb può essere avviato! Premo "Applica" dappertutto.
{{< gallery match="images/7/*.png" >}}

## Passo 3: installare Wallabag
Faccio clic sulla scheda "Registrazione" nella finestra di Synology Docker e cerco "wallabag". Seleziono l'immagine Docker "wallabag/wallabag" e poi clicco sul tag "latest".
{{< gallery match="images/8/*.png" >}}
Faccio doppio clic sull'immagine della mia borsa. Poi clicco su "Impostazioni avanzate" e attivo anche qui il "Riavvio automatico".
{{< gallery match="images/9/*.png" >}}
Seleziono la scheda "Volume" e clicco su "Aggiungi cartella". Lì creo una nuova cartella con questo percorso di montaggio "/var/www/wallabag/web/assets/images".
{{< gallery match="images/10/*.png" >}}
Assegno delle porte fisse per il contenitore "wallabag". Senza porte fisse, potrebbe essere che il "server wallabag" giri su una porta diversa dopo un riavvio. La prima porta del contenitore può essere cancellata. L'altra porta dovrebbe essere ricordata.
{{< gallery match="images/11/*.png" >}}
Inoltre, un "link" al contenitore "mariadb" deve ancora essere creato. Faccio clic sulla scheda "Link" e seleziono il contenitore del database. Il nome dell'alias deve essere ricordato per l'installazione di wallabag.
{{< gallery match="images/12/*.png" >}}
{{<table "table table-striped table-bordered">}}
|Umgebungsvariable	|Valore|
|--- |---|
|MYSQL_ROOT_PASSWORD	|wallaroot|
|SYMFONY__ENV__DATABASE_DRIVER	|pdo_mysql|
|SYMFONY__ENV__DATABASE_HOST	|db|
|SYMFONY__ENV__DATABASE_PORT	|3306|
|SYMFONY__ENV__DATABASE_NAME	|wallabag|
|SYMFONY__ENV__DATABASE_USER	|wallabag|
|SYMFONY__ENV__DATABASE_PASSWORD	|wallapass|
|SYMFONY__ENV__DATABASE_CHARSET |utf8mb4|
|SYMFONY__ENV__DOMAIN_NAME	|"http://synology-ip:container-port" <- Per favore cambia|
|SYMFONY__ENV__SERVER_NAME	|"Wallabag - Server"|
|SYMFONY__ENV__FOSUSER_CONFIRMATION	|falso|
|SYMFONY__ENV__TWOFACTOR_AUTH	|falso|
{{</table>}}
Infine, inserisco queste variabili d'ambiente:Vedi:
{{< gallery match="images/13/*.png" >}}
Il contenitore può ora essere avviato. Potrebbe essere necessario un po' di tempo per creare il database. Il comportamento può essere osservato attraverso i dettagli del contenitore.
{{< gallery match="images/14/*.png" >}}
Chiamo il server wallabag con l'indirizzo IP di Synology e la mia porta del container.
{{< gallery match="images/15/*.png" >}}
