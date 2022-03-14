+++
date = "2021-04-25T09:28:11+01:00"
title = "Grandi cose con i container: Portainer come alternativa a Synology Docker GUI"
difficulty = "level-3"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "watchtower"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/april/20210425-docker-Portainer/index.it.md"
+++

## Passo 1: Preparare Synology
Innanzitutto, il login SSH deve essere attivato sulla DiskStation. Per farlo, andate nel "Pannello di controllo" > "Terminale
{{< gallery match="images/1/*.png" >}}
Poi si può accedere tramite "SSH", la porta specificata e la password dell'amministratore (gli utenti Windows usano Putty o WinSCP).
{{< gallery match="images/2/*.png" >}}
Mi collego tramite Terminale, winSCP o Putty e lascio questa console aperta per dopo.
## Passo 2: creare la cartella portainer
Creo una nuova directory chiamata "portainer" nella directory Docker.
{{< gallery match="images/3/*.png" >}}
Poi vado nella directory del portainer con la console e creo una cartella e un nuovo file chiamato "portainer.yml".
{{< terminal >}}
cd /volume1/docker/portainer
mkdir portainer_data
vim portainer.yml

{{</ terminal >}}
Ecco il contenuto del file "portainer.yml":
```
version: '3'

services:
  portainer:
    image: portainer/portainer:latest
    container_name: portainer
    restart: always
    ports:
      - 90070:9000
      - 9090:8000
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - ./portainer_data:/data

```
Altre immagini Docker utili per uso domestico possono essere trovate nella [Dockerverse]({{< ref "dockerverse" >}} "Dockerverse").
## Fase 3: avvio del portainer
Posso anche fare buon uso della console in questo passo. Avvio il server portainer tramite Docker Compose.
{{< terminal >}}
sudo docker-compose -f portainer.yml up -d

{{</ terminal >}}
Poi posso chiamare il mio server Portainer con l'IP della stazione disco e la porta assegnata dal "Passo 2". Inserisco la mia password di amministratore e seleziono la variante locale.
{{< gallery match="images/4/*.png" >}}
Come potete vedere, tutto funziona alla grande!
{{< gallery match="images/5/*.png" >}}