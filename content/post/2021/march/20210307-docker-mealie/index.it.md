+++
date = "2021-03-07"
title = "Grandi cose con i contenitori: gestire e archiviare ricette sulla Synology DiskStation"
difficulty = "level-1"
tags = ["diskstation", "Docker", "docker-compose", "docker-for-desktop", "rezepte", "speisen", "Synology"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/march/20210307-docker-mealie/index.it.md"
+++
Raccogliete tutte le vostre ricette preferite nel contenitore Docker e organizzatele come volete. Scrivi le tue ricette o importa ricette da siti web, per esempio "Chefkoch", "Essen
{{< gallery match="images/1/*.png" >}}

## Opzione per i professionisti
Come utente esperto di Synology, puoi ovviamente accedere con SSH e installare l'intera configurazione tramite il file Docker Compose.
```
version: "2.0"
services:
  mealie:
    container_name: mealie
    image: hkotel/mealie:latest
    restart: always
    ports:
      - 9000:80
    environment:
      db_type: sqlite
      TZ: Europa/Berlin
    volumes:
      - ./mealie/data/:/app/data

```

## Passo 1: cercare l'immagine Docker
Faccio clic sulla scheda "Registrazione" nella finestra di Synology Docker e cerco "mealie". Seleziono l'immagine Docker "hkotel/mealie:latest" e poi clicco sul tag "latest".
{{< gallery match="images/2/*.png" >}}
Dopo il download dell'immagine, l'immagine è disponibile come immagine. Docker distingue tra 2 stati, container "stato dinamico" e immagine/immagine (stato fisso). Prima di poter creare un contenitore dall'immagine, devono essere fatte alcune impostazioni.
## Passo 2: Mettere l'immagine in funzione:
Faccio doppio clic sulla mia immagine "mealie".
{{< gallery match="images/3/*.png" >}}
Poi clicco su "Impostazioni avanzate" e attivo il "Riavvio automatico". Seleziono la scheda "Volume" e clicco su "Aggiungi cartella". Lì creo una nuova cartella con questo percorso di montaggio "/app/data".
{{< gallery match="images/4/*.png" >}}
Assegno delle porte fisse per il contenitore "Mealie". Senza porte fisse, potrebbe essere che il "server Mealie" giri su una porta diversa dopo un riavvio.
{{< gallery match="images/5/*.png" >}}
Infine, inserisco due variabili d'ambiente. La variabile "db_type" è il tipo di database e "TZ" è il fuso orario "Europe/Berlin".
{{< gallery match="images/6/*.png" >}}
Dopo queste impostazioni, Mealie Server può essere avviato! In seguito potete chiamare Mealie tramite l'indirizzo Ip della distazione Synology e la porta assegnata, per esempio http://192.168.21.23:8096 .
{{< gallery match="images/7/*.png" >}}

## Come funziona Mealie?
Se sposto il mouse sul pulsante "più" a destra/in basso e poi clicco sul simbolo della "catena", posso inserire un url. L'applicazione Mealie cerca quindi automaticamente le informazioni meta e schema richieste.
{{< gallery match="images/8/*.png" >}}
L'importazione funziona benissimo (ho usato queste funzioni con gli URL di Chef, Food
{{< gallery match="images/9/*.png" >}}
In modalità di modifica, posso anche aggiungere una categoria. È importante che io prema il tasto "Enter" una volta dopo ogni categoria. Altrimenti, questa impostazione non viene applicata.
{{< gallery match="images/10/*.png" >}}

## Caratteristiche speciali
Ho notato che le categorie del menu non si aggiornano automaticamente. Qui bisogna aiutarsi con un ricarico del browser.
{{< gallery match="images/11/*.png" >}}

## Altre caratteristiche
Naturalmente, è possibile cercare ricette e anche creare menu. Inoltre, è possibile personalizzare "Mealie" in modo molto ampio.
{{< gallery match="images/12/*.png" >}}
Mealie ha un ottimo aspetto anche su mobile:
{{< gallery match="images/13/*.*" >}}

## Rest-Api
La documentazione API può essere trovata su "http://gewaehlte-ip:und-port ... /docs". Qui troverete molti metodi che possono essere utilizzati per l'automazione.
{{< gallery match="images/14/*.png" >}}

## Esempio di Api
Immaginate la seguente finzione: "Gruner und Jahr lancia il portale internet Essen
{{< terminal >}}
wget --spider --force-html -r -l12  "https://www.essen-und-trinken.de/rezepte/archiv/"  2>&1 | grep '/rezepte/' | grep '^--' | awk '{ print $3 }' > liste.txt

{{</ terminal >}}
Poi pulite questa lista e sparatela contro la rest api, esempio:
```
#!/bin/bash
sort -u liste.txt > clear.txt

while read p; do
  echo "import url: $p"
  curl -d "{\"url\":\"$p\"}" -H "Content-Type: application/json" http://synology-ip:8096/api/recipes/create-url
  sleep 1
done < clear.txt

```
Ora puoi anche accedere alle ricette offline:
{{< gallery match="images/15/*.png" >}}
Conclusione: se metti un po' di tempo in Mealie, puoi costruire un grande database di ricette! Mealie è costantemente sviluppato come progetto open source e può essere trovato al seguente indirizzo: https://github.com/hay-kot/mealie/
