+++
date = "2021-04-25T09:28:11+01:00"
title = "BitwardenRS sulla Synology DiskStation"
difficulty = "level-2"
tags = ["bitwardenrs", "Docker", "docker-compose", "password-manager", "passwort", "Synology"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210425-docker-BitwardenRS/index.it.md"
+++
Bitwarden è un servizio gratuito open-source di gestione delle password che memorizza le informazioni riservate come le credenziali di un sito web in un caveau criptato. Oggi mostro come installare un BitwardenRS sulla Synology DiskStation.
## Passo 1: preparare la cartella BitwardenRS
Creo una nuova directory chiamata "bitwarden" nella directory Docker.
{{< gallery match="images/1/*.png" >}}

## Passo 2: installare BitwardenRS
Faccio clic sulla scheda "Registrazione" nella finestra di Synology Docker e cerco "bitwarden". Seleziono l'immagine Docker "bitwardenrs/server" e poi clicco sul tag "latest".
{{< gallery match="images/2/*.png" >}}
Faccio doppio clic sulla mia immagine di bitwardenrs. Poi clicco su "Impostazioni avanzate" e attivo anche qui il "Riavvio automatico".
{{< gallery match="images/3/*.png" >}}
Seleziono la scheda "Volume" e clicco su "Aggiungi cartella". Lì creo una nuova cartella con questo percorso di montaggio "/data".
{{< gallery match="images/4/*.png" >}}
Assegno delle porte fisse per il contenitore "bitwardenrs". Senza porte fisse, potrebbe essere che il "server bitwardenrs" giri su una porta diversa dopo un riavvio. La prima porta del contenitore può essere cancellata. L'altra porta dovrebbe essere ricordata.
{{< gallery match="images/5/*.png" >}}
Il contenitore può ora essere avviato. Chiamo il server bitwardenrs con l'indirizzo IP del Synology e la mia porta container 8084.
{{< gallery match="images/6/*.png" >}}

## Passo 3: impostare HTTPS
Clicco su "Pannello di controllo" > "Reverse Proxy" e "Crea".
{{< gallery match="images/7/*.png" >}}
Dopo di che, posso chiamare il server bitwardenrs con l'indirizzo IP di Synology e la mia porta proxy 8085, criptata.
{{< gallery match="images/8/*.png" >}}
