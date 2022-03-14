+++
date = "2021-02-01"
title = "Store ting med containere: Pihole på Synology DiskStation"
difficulty = "level-3"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "dns", "adblocker", "fritzbox"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/february/20210201-docker-pihole/index.da.md"
+++
I dag viser jeg, hvordan man installerer en Pihole-tjeneste på Synology diskstationen og forbinder den med Fritzboxen.
## Trin 1: Forbered Synology
Først skal SSH-login være aktiveret på DiskStationen. Du kan gøre dette ved at gå til "Kontrolpanel" > "Terminal".
{{< gallery match="images/1/*.png" >}}
Derefter kan du logge ind via "SSH", den angivne port og administratoradgangskoden (Windows-brugere bruger Putty eller WinSCP).
{{< gallery match="images/2/*.png" >}}
Jeg logger ind via Terminal, winSCP eller Putty og lader denne konsol være åben til senere.
## Trin 2: Opret Pihole-mappen
Jeg opretter en ny mappe med navnet "pihole" i Docker-mappen.
{{< gallery match="images/3/*.png" >}}
Derefter skifter jeg til den nye mappe og opretter to mapper "etc-pihole" og "etc-dnsmasq.d":
{{< terminal >}}
cd /volume1/docker/
mkdir -p {etc-pihole,etc-dnsmasq.d}

{{</ terminal >}}
Nu skal følgende Docker Compose-fil med navnet "pihole.yml" placeres i Pihole-mappen:
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
Beholderen kan nu startes:
{{< terminal >}}
sudo docker-compose up -d

{{</ terminal >}}
Jeg kalder Pihole-serveren op med Synologys IP-adresse og min containerport og logger ind med adgangskoden WEBPASSWORD.
{{< gallery match="images/4/*.png" >}}
Nu kan DNS-adressen ændres i Fritzboxen under "Home Network" > "Network" > "Network Settings" (Netværksindstillinger).
{{< gallery match="images/5/*.png" >}}