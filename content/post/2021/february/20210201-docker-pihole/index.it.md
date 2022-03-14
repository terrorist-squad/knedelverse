+++
date = "2021-02-01"
title = "Grandi cose con i contenitori: Pihole sulla Synology DiskStation"
difficulty = "level-3"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "dns", "adblocker", "fritzbox"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/february/20210201-docker-pihole/index.it.md"
+++
Oggi mostro come installare un servizio Pihole sulla stazione disco Synology e collegarla al Fritzbox.
## Passo 1: Preparare Synology
Innanzitutto, il login SSH deve essere attivato sulla DiskStation. Per farlo, andate nel "Pannello di controllo" > "Terminale
{{< gallery match="images/1/*.png" >}}
Poi si può accedere tramite "SSH", la porta specificata e la password dell'amministratore (gli utenti Windows usano Putty o WinSCP).
{{< gallery match="images/2/*.png" >}}
Mi collego tramite Terminale, winSCP o Putty e lascio questa console aperta per dopo.
## Passo 2: creare la cartella Pihole
Creo una nuova directory chiamata "pihole" nella directory Docker.
{{< gallery match="images/3/*.png" >}}
Poi passo alla nuova directory e creo due cartelle "etc-pihole" e "etc-dnsmasq.d":
{{< terminal >}}
cd /volume1/docker/
mkdir -p {etc-pihole,etc-dnsmasq.d}

{{</ terminal >}}
Ora il seguente file Docker Compose chiamato "pihole.yml" deve essere messo nella directory Pihole:
```
version: "3"

services:
  pihole:
    container_name: pihole
    image: pihole/pihole:latest
    ports:
      - "53:53/tcp"
      - "53:53/udp"
      - "67:67/udp"
      - "8080:80/tcp"
    environment:
      TZ: 'Europe/Berlin'
      WEBPASSWORD: 'password'
    volumes:
      - './etc-pihole/:/etc/pihole/'
      - './etc-dnsmasq.d/:/etc/dnsmasq.d/'
    cap_add:
      - NET_ADMIN
    restart: unless-stopped

```
Il contenitore può ora essere avviato:
{{< terminal >}}
sudo docker-compose up -d

{{</ terminal >}}
Richiamo il server Pihole con l'indirizzo IP del Synology e la mia porta del container e accedo con la password WEBPASSWORD.
{{< gallery match="images/4/*.png" >}}
Ora l'indirizzo DNS può essere cambiato nel Fritzbox sotto "Home Network" > "Network" > "Network Settings".
{{< gallery match="images/5/*.png" >}}