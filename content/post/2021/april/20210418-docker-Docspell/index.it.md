+++
date = "2021-04-18"
title = "Grandi cose con i contenitori: esecuzione di Docspell DMS sulla Synology DiskStation"
difficulty = "level-2"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "Document-Managment-System"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210418-docker-Docspell/index.it.md"
+++
Docspell è un sistema di gestione dei documenti per la Synology DiskStation. Attraverso Docspell, i documenti possono essere indicizzati, cercati e trovati molto più velocemente. Oggi mostro come installare un servizio Docspell sulla Synology disk station.
## Passo 1: Preparare Synology
Innanzitutto, il login SSH deve essere attivato sulla DiskStation. Per farlo, andate nel "Pannello di controllo" > "Terminale
{{< gallery match="images/1/*.png" >}}
Poi si può accedere tramite "SSH", la porta specificata e la password dell'amministratore (gli utenti Windows usano Putty o WinSCP).
{{< gallery match="images/2/*.png" >}}
Mi collego tramite Terminale, winSCP o Putty e lascio questa console aperta per dopo.
## Passo 2: creare la cartella Docspel
Creo una nuova directory chiamata "docspell" nella directory Docker.
{{< gallery match="images/3/*.png" >}}
Ora il seguente file deve essere scaricato e scompattato nella directory: https://github.com/eikek/docspell/archive/refs/heads/master.zip . Io uso la console per questo:
{{< terminal >}}
cd /volume1/docker/docspell/
mkdir docs
mkdir postgres_data
wget https://github.com/eikek/docspell/archive/refs/heads/master.zip 
/bin/7z x master.zip

{{</ terminal >}}
Poi modifico il file "docker/docker-compose.yml" e inserisco i miei indirizzi Synology in "consumedir" e "db":
{{< gallery match="images/4/*.png" >}}
Dopo di che posso avviare il file Compose:
{{< terminal >}}
cd docspell-master/docker/
docker-compose up -d

{{</ terminal >}}
Dopo qualche minuto, posso chiamare il mio server Docspell con l'IP della stazione disco e la porta assegnata/7878.
{{< gallery match="images/5/*.png" >}}
