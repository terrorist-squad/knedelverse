+++
date = "2021-02-01"
title = "Geweldige dingen met containers: Pihole op het Synology DiskStation"
difficulty = "level-3"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "dns", "adblocker", "fritzbox"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/february/20210201-docker-pihole/index.nl.md"
+++
Vandaag laat ik zien hoe je een Pihole service installeert op het Synology disk station en deze verbindt met de Fritzbox.
## Stap 1: Synology voorbereiden
Eerst moet de SSH-aanmelding op het DiskStation worden geactiveerd. Om dit te doen, ga naar het "Configuratiescherm" > "Terminal
{{< gallery match="images/1/*.png" >}}
Vervolgens kunt u inloggen via "SSH", de opgegeven poort en het beheerderswachtwoord (Windows-gebruikers gebruiken Putty of WinSCP).
{{< gallery match="images/2/*.png" >}}
Ik log in via Terminal, winSCP of Putty en laat deze console open voor later.
## Stap 2: Pihole map aanmaken
Ik maak een nieuwe map aan genaamd "pihole" in de Docker map.
{{< gallery match="images/3/*.png" >}}
Dan ga ik naar de nieuwe directory en maak twee mappen "etc-pihole" en "etc-dnsmasq.d":
{{< terminal >}}
cd /volume1/docker/
mkdir -p {etc-pihole,etc-dnsmasq.d}

{{</ terminal >}}
Nu moet het volgende Docker Compose bestand met de naam "pihole.yml" in de Pihole directory geplaatst worden:
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
De container kan nu worden gestart:
{{< terminal >}}
sudo docker-compose up -d

{{</ terminal >}}
Ik roep de Pihole server op met het Synology IP adres en mijn container poort en log in met het WEBPASSWORD wachtwoord.
{{< gallery match="images/4/*.png" >}}
Nu kan het DNS adres worden gewijzigd in de Fritzbox onder "Thuisnetwerk" > "Netwerk" > "Netwerk Instellingen".
{{< gallery match="images/5/*.png" >}}