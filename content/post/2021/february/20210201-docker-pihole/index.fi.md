+++
date = "2021-02-01"
title = "Suuria asioita konttien avulla: Pihole Synology DiskStationilla"
difficulty = "level-3"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "dns", "adblocker", "fritzbox"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/february/20210201-docker-pihole/index.fi.md"
+++
Tänään näytän, miten Pihole-palvelu asennetaan Synologyn levyasemaan ja liitetään se Fritzboxiin.
## Vaihe 1: Synologyn valmistelu
Ensin SSH-kirjautuminen on aktivoitava DiskStationissa. Tee tämä menemällä "Ohjauspaneeli" > "Pääte" > "Pääte".
{{< gallery match="images/1/*.png" >}}
Sitten voit kirjautua sisään "SSH:n", määritetyn portin ja järjestelmänvalvojan salasanan kautta (Windows-käyttäjät käyttävät Puttya tai WinSCP:tä).
{{< gallery match="images/2/*.png" >}}
Kirjaudun sisään terminaalin, winSCP:n tai Puttyn kautta ja jätän tämän konsolin auki myöhempää käyttöä varten.
## Vaihe 2: Luo Pihole-kansio
Luon Docker-hakemistoon uuden hakemiston nimeltä "pihole".
{{< gallery match="images/3/*.png" >}}
Sitten siirryn uuteen hakemistoon ja luon kaksi kansiota "etc-pihole" ja "etc-dnsmasq.d":
{{< terminal >}}
cd /volume1/docker/
mkdir -p {etc-pihole,etc-dnsmasq.d}

{{</ terminal >}}
Nyt seuraava Docker Compose -tiedosto nimeltä "pihole.yml" on sijoitettava Pihole-hakemistoon:
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
Säiliö voidaan nyt käynnistää:
{{< terminal >}}
sudo docker-compose up -d

{{</ terminal >}}
Soitan Pihole-palvelimelle Synologyn IP-osoitteella ja konttiportillani ja kirjaudun sisään WEBPASSWORD-salasanalla.
{{< gallery match="images/4/*.png" >}}
Nyt DNS-osoite voidaan muuttaa Fritzboxissa kohdassa "Kotiverkko" > "Verkko" > "Verkkoasetukset".
{{< gallery match="images/5/*.png" >}}