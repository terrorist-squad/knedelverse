+++
date = "2020-02-13"
title = "Synology-Nas: installare Calibre Web come libreria di ebook"
difficulty = "level-1"
tags = ["calbre-web", "calibre", "Docker", "ds918", "ebook", "epub", "nas", "pdf", "Synology"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2020/february/20200213-synology-calibreweb/index.it.md"
+++
Come posso installare Calibre-Web come contenitore Docker sul mio Synology NAS? Attenzione: questo metodo di installazione è obsoleto e non è compatibile con l'attuale software Calibre. Date un'occhiata a questo nuovo tutorial:[Grandi cose con i container: eseguire Calibre con Docker Compose]({{< ref "post/2020/february/20200221-docker-Calibre-pro" >}} "Grandi cose con i container: eseguire Calibre con Docker Compose"). Questo tutorial è per tutti i professionisti di Synology DS.
## Passo 1: Creare la cartella
Per prima cosa, creo una cartella per la libreria di Calibre.  Richiamo il "Controllo di sistema" -> "Cartella condivisa" e creo una nuova cartella "Libri".
{{< gallery match="images/1/*.png" >}}

##  Passo 2: creare la libreria Calibre
Ora copio una libreria esistente o "[questa libreria di esempio vuota](https://drive.google.com/file/d/1zfeU7Jh3FO_jFlWSuZcZQfQOGD0NvXBm/view)" nella nuova directory. Io stesso ho copiato la libreria esistente dell'applicazione desktop.
{{< gallery match="images/2/*.png" >}}

## Passo 3: cercare l'immagine Docker
Clicco sulla scheda "Registrazione" nella finestra di Synology Docker e cerco "Calibre". Seleziono l'immagine Docker "janeczku/calibre-web" e poi clicco sul tag "latest".
{{< gallery match="images/3/*.png" >}}
Dopo il download dell'immagine, l'immagine è disponibile come immagine. Docker distingue tra 2 stati, container "stato dinamico" e immagine/immagine (stato fisso). Prima di poter creare un contenitore dall'immagine, devono essere fatte alcune impostazioni.
## Passo 4: Mettere l'immagine in funzione:
Faccio doppio clic sulla mia immagine Calibre.
{{< gallery match="images/4/*.png" >}}
Poi clicco su "Impostazioni avanzate" e attivo il "Riavvio automatico". Seleziono la scheda "Volume" e clicco su "Aggiungi cartella". Lì creo una nuova cartella di database con questo percorso di montaggio "/calibre".
{{< gallery match="images/5/*.png" >}}
Assegno porte fisse per il contenitore Calibre. Senza porte fisse, potrebbe essere che Calibre giri su una porta diversa dopo un riavvio.
{{< gallery match="images/6/*.png" >}}
Dopo queste impostazioni, Calibre può essere avviato!
{{< gallery match="images/7/*.png" >}}
Ora richiamo il mio IP Synology con la porta Calibre assegnata e vedo la seguente immagine. Inserisco "/calibre" come "Posizione del database di Calibre". Le restanti impostazioni sono una questione di gusto.
{{< gallery match="images/8/*.png" >}}
Il login di default è "admin" con password "admin123".
{{< gallery match="images/9/*.png" >}}
Fatto! Naturalmente, ora posso anche collegare l'applicazione desktop tramite la mia "cartella dei libri". Scambio la libreria nella mia app e poi seleziono la mia cartella Nas.
{{< gallery match="images/10/*.png" >}}
Qualcosa del genere:
{{< gallery match="images/11/*.png" >}}
Se ora modifico i meta-info nell'applicazione desktop, essi vengono automaticamente aggiornati anche nell'applicazione web.
{{< gallery match="images/12/*.png" >}}