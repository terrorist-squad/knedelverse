+++
date = "2021-02-01"
title = "Nagyszerű dolgok konténerekkel: Pihole a Synology Diskstationon"
difficulty = "level-3"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "dns", "adblocker", "fritzbox"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/february/20210201-docker-pihole/index.hu.md"
+++
Ma megmutatom, hogyan kell telepíteni egy Pihole szolgáltatást a Synology lemezállomásra, és hogyan kell csatlakoztatni a Fritzboxhoz.
## 1. lépés: A Synology előkészítése
Először is aktiválni kell az SSH bejelentkezést a DiskStationön. Ehhez menjen a "Vezérlőpult" > "Terminál" > "Terminál" menüpontba.
{{< gallery match="images/1/*.png" >}}
Ezután bejelentkezhet az "SSH"-n keresztül, a megadott porton és a rendszergazdai jelszóval (Windows felhasználók a Putty vagy a WinSCP segítségével).
{{< gallery match="images/2/*.png" >}}
Terminal, winSCP vagy Putty segítségével jelentkezem be, és ezt a konzolt későbbre nyitva hagyom.
## 2. lépés: Pihole mappa létrehozása
Létrehozok egy új könyvtárat "pihole" néven a Docker könyvtárban.
{{< gallery match="images/3/*.png" >}}
Ezután átváltok az új könyvtárba, és létrehozok két mappát: "etc-pihole" és "etc-dnsmasq.d":
{{< terminal >}}
cd /volume1/docker/
mkdir -p {etc-pihole,etc-dnsmasq.d}

{{</ terminal >}}
Most a következő "pihole.yml" nevű Docker Compose fájlt kell elhelyezni a Pihole könyvtárban:
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
A konténer most már elindítható:
{{< terminal >}}
sudo docker-compose up -d

{{</ terminal >}}
Felhívom a Pihole szervert a Synology IP-címével és a konténerportommal, és bejelentkezem a WEBPASSWORD jelszóval.
{{< gallery match="images/4/*.png" >}}
Most a DNS-cím megváltoztatható a Fritzboxban az "Otthoni hálózat" > "Hálózat" > "Hálózati beállítások" menüpont alatt.
{{< gallery match="images/5/*.png" >}}