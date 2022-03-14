+++
date = "2021-02-01"
title = "Lucruri grozave cu containere: Pihole pe Synology DiskStation"
difficulty = "level-3"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "dns", "adblocker", "fritzbox"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/february/20210201-docker-pihole/index.ro.md"
+++
Astăzi vă arăt cum să instalați un serviciu Pihole pe stația de discuri Synology și cum să o conectați la Fritzbox.
## Pasul 1: Pregătiți Synology
În primul rând, conectarea SSH trebuie să fie activată pe DiskStation. Pentru a face acest lucru, mergeți la "Control Panel" > "Terminal".
{{< gallery match="images/1/*.png" >}}
Apoi vă puteți conecta prin "SSH", portul specificat și parola de administrator (utilizatorii de Windows folosesc Putty sau WinSCP).
{{< gallery match="images/2/*.png" >}}
Mă conectez prin Terminal, winSCP sau Putty și las această consolă deschisă pentru mai târziu.
## Pasul 2: Creați dosarul Pihole
Creez un nou director numit "pihole" în directorul Docker.
{{< gallery match="images/3/*.png" >}}
Apoi mă mut în noul director și creez două dosare "etc-pihole" și "etc-dnsmasq.d":
{{< terminal >}}
cd /volume1/docker/
mkdir -p {etc-pihole,etc-dnsmasq.d}

{{</ terminal >}}
Acum, următorul fișier Docker Compose numit "pihole.yml" trebuie să fie plasat în directorul Pihole:
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
Containerul poate fi pornit acum:
{{< terminal >}}
sudo docker-compose up -d

{{</ terminal >}}
Sun la serverul Pihole cu adresa IP a Synology și portul containerului meu și mă conectez cu parola WEBPASSWORD.
{{< gallery match="images/4/*.png" >}}
Acum, adresa DNS poate fi modificată în Fritzbox la "Rețea principală" > "Rețea" > "Setări rețea".
{{< gallery match="images/5/*.png" >}}