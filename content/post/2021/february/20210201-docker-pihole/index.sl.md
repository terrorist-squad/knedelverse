+++
date = "2021-02-01"
title = "Velike stvari z zabojniki: Pihole na strežniku Synology DiskStation"
difficulty = "level-3"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "dns", "adblocker", "fritzbox"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/february/20210201-docker-pihole/index.sl.md"
+++
Danes bom pokazal, kako namestiti storitev Pihole na diskovno postajo Synology in jo povezati z napravo Fritzbox.
## Korak 1: Pripravite Synology
Najprej je treba na napravi DiskStation aktivirati prijavo SSH. To storite tako, da greste v "Nadzorna plošča" > "Terminal".
{{< gallery match="images/1/*.png" >}}
Nato se lahko prijavite prek SSH, določenih vrat in skrbniškega gesla (uporabniki Windows uporabljajo Putty ali WinSCP).
{{< gallery match="images/2/*.png" >}}
Prijavim se prek terminala, winSCP ali Puttyja in pustim to konzolo odprto za pozneje.
## Korak 2: Ustvarite mapo Pihole
V imeniku programa Docker ustvarim nov imenik z imenom "pihole".
{{< gallery match="images/3/*.png" >}}
Nato preidem v novi imenik in ustvarim dve mapi "etc-pihole" in "etc-dnsmasq.d":
{{< terminal >}}
cd /volume1/docker/
mkdir -p {etc-pihole,etc-dnsmasq.d}

{{</ terminal >}}
V imenik Pihole je treba namestiti naslednjo datoteko Docker Compose z imenom "pihole.yml":
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
Posodo lahko zaženete:
{{< terminal >}}
sudo docker-compose up -d

{{</ terminal >}}
Pokličem strežnik Pihole z naslovom IP Synology in pristaniščem za zabojnik ter se prijavim z geslom WEBPASSWORD.
{{< gallery match="images/4/*.png" >}}
Zdaj lahko naslov DNS spremenite v napravi Fritzbox pod "Domače omrežje" > "Omrežje" > "Nastavitve omrežja".
{{< gallery match="images/5/*.png" >}}