+++
date = "2020-02-21"
title = "Grandi cose con i container: eseguire Calibre con Docker Compose (configurazione Synology pro)"
difficulty = "level-3"
tags = ["calibre", "calibre-web", "Docker", "docker-compose", "Synology", "linux"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2020/february/20200221-docker-Calibre-pro/index.it.md"
+++
C'è già un tutorial più semplice su questo blog: [Synology-Nas: installare Calibre Web come libreria di ebook]({{< ref "post/2020/february/20200213-synology-calibreweb" >}} "Synology-Nas: installare Calibre Web come libreria di ebook"). Questo tutorial è per tutti i professionisti di Synology DS.
## Passo 1: Preparare Synology
Innanzitutto, il login SSH deve essere attivato sulla DiskStation. Per farlo, andate nel "Pannello di controllo" > "Terminale
{{< gallery match="images/1/*.png" >}}
Poi si può accedere tramite "SSH", la porta specificata e la password dell'amministratore (gli utenti Windows usano Putty o WinSCP).
{{< gallery match="images/2/*.png" >}}
Mi collego tramite Terminale, winSCP o Putty e lascio questa console aperta per dopo.
## Passo 2: Creare una cartella di libri
Creo una nuova cartella per la libreria di Calibre. Per fare questo, richiamo "Controllo del sistema" -> "Cartella condivisa" e creo una nuova cartella chiamata "Libri". Se non c'è ancora una cartella "Docker", allora anche questa deve essere creata.
{{< gallery match="images/3/*.png" >}}

## Passo 3: Preparare la cartella del libro
Ora il seguente file deve essere scaricato e scompattato: https://drive.google.com/file/d/1zfeU7Jh3FO_jFlWSuZcZQfQOGD0NvXBm/view. Il contenuto ("metadata.db") deve essere messo nella nuova directory del libro, vedi:
{{< gallery match="images/4/*.png" >}}

## Passo 4: Preparare la cartella Docker
Creo una nuova directory chiamata "calibre" nella directory Docker:
{{< gallery match="images/5/*.png" >}}
Poi passo alla nuova directory e creo un nuovo file chiamato "calibre.yml" con il seguente contenuto:
```
version: '2'
services:
  calibre-web:
    image: linuxserver/calibre-web
    container_name: calibre-web-server
    environment:
      - PUID=1026
      - PGID=100
      - TZ=Europe/Berlin
    volumes:
      - /volume1/Buecher:/books
      - /volume1/docker/calibre:/briefkaste
    ports:
      - 8055:8083
    restart: unless-stopped

```
In questo nuovo file, diversi posti devono essere regolati come segue:* PUID/PGID: L'ID dell'utente e del gruppo dell'utente DS deve essere inserito in PUID/PGID. Qui uso la console dal "Passo 1" e i comandi "id -u" per vedere l'ID utente. Con il comando "id -g" ottengo l'ID del gruppo.* ports: Per la porta, la parte anteriore "8055:" deve essere corretta.directoriesTutte le directory in questo file devono essere corrette. Gli indirizzi corretti possono essere visti nella finestra delle proprietà del DS. (Segue uno screenshot)
{{< gallery match="images/6/*.png" >}}

## Passo 5: Inizio del test
Posso anche fare buon uso della console in questo passo. Passo alla directory di Calibre e avvio lì il server Calibre tramite Docker Compose.
{{< terminal >}}
cd /volume1/docker/calibre
sudo docker-compose -f calibre.yml up -d

{{</ terminal >}}

{{< gallery match="images/7/*.png" >}}

## Passo 6: Impostazione
Poi posso chiamare il mio server Calibre con l'IP della stazione disco e la porta assegnata dal "Passo 4". Uso il mio punto di montaggio "/books" nella configurazione. Dopo di che, il server è già utilizzabile.
{{< gallery match="images/8/*.png" >}}

## Passo 7: Finalizzazione della configurazione
Anche la console è necessaria in questo passo. Uso il comando "exec" per salvare il database dell'applicazione interna al contenitore.
{{< terminal >}}
sudo docker exec -it calibre-web-server cp /app/calibre-web/app.db /briefkaste/app.db

{{</ terminal >}}
Dopo di che vedo un nuovo file "app.db" nella directory di Calibre:
{{< gallery match="images/9/*.png" >}}
Poi fermo il server Calibre:
{{< terminal >}}
sudo docker-compose -f calibre.yml down

{{</ terminal >}}
Ora cambio il percorso della cassetta delle lettere e persisto il database dell'applicazione su di esso.
```
version: '2'
services:
  calibre-web:
    image: linuxserver/calibre-web
    container_name: calibre-web-server
    environment:
      - PUID=1026
      - PGID=100
      - TZ=Europe/Berlin
    volumes:
      - /volume1/Buecher:/books
      - /volume1/docker/calibre/app.db:/app/calibre-web/app.db
    ports:
      - 8055:8083
    restart: unless-stopped

```
Dopo di che, il server può essere riavviato:
{{< terminal >}}
sudo docker-compose -f calibre.yml up -d

{{</ terminal >}}