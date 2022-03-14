+++
date = "2021-02-01"
title = "Veľké veci s kontajnermi: Pihole na stanici Synology DiskStation"
difficulty = "level-3"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "dns", "adblocker", "fritzbox"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/february/20210201-docker-pihole/index.sk.md"
+++
Dnes ukážem, ako nainštalovať službu Pihole na diskovú stanicu Synology a pripojiť ju k zariadeniu Fritzbox.
## Krok 1: Príprava spoločnosti Synology
Najprv je potrebné aktivovať prihlásenie SSH na zariadení DiskStation. Ak to chcete urobiť, prejdite na "Ovládací panel" > "Terminál".
{{< gallery match="images/1/*.png" >}}
Potom sa môžete prihlásiť cez "SSH", zadaný port a heslo správcu (používatelia systému Windows používajú Putty alebo WinSCP).
{{< gallery match="images/2/*.png" >}}
Prihlásim sa cez terminál, winSCP alebo Putty a túto konzolu nechám otvorenú na neskôr.
## Krok 2: Vytvorenie priečinka Pihole
V adresári Docker vytvorím nový adresár s názvom "pihole".
{{< gallery match="images/3/*.png" >}}
Potom prejdem do nového adresára a vytvorím dva adresáre "etc-pihole" a "etc-dnsmasq.d":
{{< terminal >}}
cd /volume1/docker/
mkdir -p {etc-pihole,etc-dnsmasq.d}

{{</ terminal >}}
Teraz je potrebné do adresára Pihole umiestniť nasledujúci súbor Docker Compose s názvom "pihole.yml":
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
Kontajner je teraz možné spustiť:
{{< terminal >}}
sudo docker-compose up -d

{{</ terminal >}}
Vyvolám server Pihole s IP adresou Synology a mojím kontajnerovým portom a prihlásim sa pomocou hesla WEBPASSWORD.
{{< gallery match="images/4/*.png" >}}
Teraz môžete adresu DNS zmeniť v zariadení Fritzbox v časti "Domáca sieť" > "Sieť" > "Nastavenia siete".
{{< gallery match="images/5/*.png" >}}