+++
date = "2021-04-25T09:28:11+01:00"
title = "Breve storia: aggiornare automaticamente i contenitori con Watchtower"
difficulty = "level-2"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "watchtower"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/april/20210425-docker-Watchtower/index.it.md"
+++
Se si eseguono contenitori Docker sulla propria stazione disco, si desidera naturalmente che siano sempre aggiornati. Watchtower aggiorna le immagini e i contenitori automaticamente. In questo modo si può godere delle ultime caratteristiche e della sicurezza dei dati più aggiornata. Oggi vi mostrerò come installare una Watchtower sulla Synology disk station.
## Passo 1: Preparare Synology
Innanzitutto, il login SSH deve essere attivato sulla DiskStation. Per farlo, andate nel "Pannello di controllo" > "Terminale
{{< gallery match="images/1/*.png" >}}
Poi si può accedere tramite "SSH", la porta specificata e la password dell'amministratore (gli utenti Windows usano Putty o WinSCP).
{{< gallery match="images/2/*.png" >}}
Mi collego tramite Terminale, winSCP o Putty e lascio questa console aperta per dopo.
## Passo 2: installare Watchtower
Io uso la console per questo:
{{< terminal >}}
docker run --name watchtower --restart always -v /var/run/docker.sock:/var/run/docker.sock containrrr/watchtower

{{</ terminal >}}
Dopo di che, Watchtower funziona sempre in background.
{{< gallery match="images/3/*.png" >}}
