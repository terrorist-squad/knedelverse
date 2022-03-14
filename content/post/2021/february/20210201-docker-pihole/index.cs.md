+++
date = "2021-02-01"
title = "Velké věci s kontejnery: Pihole na stanici Synology DiskStation"
difficulty = "level-3"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "dns", "adblocker", "fritzbox"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/february/20210201-docker-pihole/index.cs.md"
+++
Dnes ukážu, jak nainstalovat službu Pihole na diskovou stanici Synology a připojit ji k Fritzboxu.
## Krok 1: Příprava společnosti Synology
Nejprve je třeba na zařízení DiskStation aktivovat přihlášení SSH. Chcete-li to provést, přejděte do nabídky "Ovládací panely" > "Terminál".
{{< gallery match="images/1/*.png" >}}
Poté se můžete přihlásit pomocí "SSH", zadaného portu a hesla správce (uživatelé Windows používají Putty nebo WinSCP).
{{< gallery match="images/2/*.png" >}}
Přihlašuji se přes Terminál, winSCP nebo Putty a nechávám tuto konzoli otevřenou na později.
## Krok 2: Vytvoření složky Pihole
V adresáři Docker vytvořím nový adresář s názvem "pihole".
{{< gallery match="images/3/*.png" >}}
Pak se přepnu do nového adresáře a vytvořím dvě složky "etc-pihole" a "etc-dnsmasq.d":
{{< terminal >}}
cd /volume1/docker/
mkdir -p {etc-pihole,etc-dnsmasq.d}

{{</ terminal >}}
Nyní je třeba do adresáře Pihole umístit následující soubor Docker Compose s názvem "pihole.yml":
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
Nyní lze kontejner spustit:
{{< terminal >}}
sudo docker-compose up -d

{{</ terminal >}}
Vyvolám server Pihole s IP adresou Synology a portem kontejneru a přihlásím se pomocí hesla WEBPASSWORD.
{{< gallery match="images/4/*.png" >}}
Nyní lze adresu DNS změnit v zařízení Fritzbox v části "Domácí síť" > "Síť" > "Nastavení sítě".
{{< gallery match="images/5/*.png" >}}