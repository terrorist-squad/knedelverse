+++
date = "2021-02-01"
title = "Stora saker med behållare: Pihole på Synology DiskStation"
difficulty = "level-3"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "dns", "adblocker", "fritzbox"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/february/20210201-docker-pihole/index.sv.md"
+++
Idag visar jag hur man installerar en Pihole-tjänst på Synology diskstationen och ansluter den till Fritzboxen.
## Steg 1: Förbered Synology
Först måste SSH-inloggningen aktiveras på DiskStationen. Detta gör du genom att gå till "Kontrollpanelen" > "Terminal".
{{< gallery match="images/1/*.png" >}}
Därefter kan du logga in via "SSH", den angivna porten och administratörslösenordet (Windows-användare använder Putty eller WinSCP).
{{< gallery match="images/2/*.png" >}}
Jag loggar in via Terminal, winSCP eller Putty och lämnar denna konsol öppen för senare.
## Steg 2: Skapa en Pihole-mapp
Jag skapar en ny katalog som heter "pihole" i Dockerkatalogen.
{{< gallery match="images/3/*.png" >}}
Sedan byter jag till den nya katalogen och skapar två mappar "etc-pihole" och "etc-dnsmasq.d":
{{< terminal >}}
cd /volume1/docker/
mkdir -p {etc-pihole,etc-dnsmasq.d}

{{</ terminal >}}
Nu måste följande Docker Compose-fil med namnet "pihole.yml" placeras i Pihole-katalogen:
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
Behållaren kan nu startas:
{{< terminal >}}
sudo docker-compose up -d

{{</ terminal >}}
Jag ringer upp Pihole-servern med Synologys IP-adress och min containerport och loggar in med lösenordet WEBPASSWORD.
{{< gallery match="images/4/*.png" >}}
Nu kan du ändra DNS-adressen i Fritzbox under "Hemnätverk" > "Nätverk" > "Nätverksinställningar".
{{< gallery match="images/5/*.png" >}}