+++
date = "2021-02-01"
title = "Großartiges mit Containern: Pihole auf der Synology-Diskstation"
difficulty = "level-3"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "dns", "adblocker", "fritzbox"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/february/20210201-docker-pihole/index.de.md"
+++
Heute zeige ich, wie man einen Pihole-Dienst auf der Synology-Diskstation installiert und mit der Fritzbox verbindet.

## Schritt 1: Synology vorbereiten
Als erstes muss der SSH-Login auf der Diskstation aktiviert werden. Dazu geht man in die „Systemsteuerung“ > „Terminal & SNMP“ und aktiviert dort die „SSH-Dienst aktivieren“-Einstellung.
{{< gallery match="images/1/*.png" >}}

Danach kann man sich via „SSH„, den angegebenen Port und den Administrator-Password anmelden (Windows-Nutzer nehmen Putty oder WinSCP).
{{< gallery match="images/2/*.png" >}}
Ich logge mich via Terminal, winSCP oder Putty ein und lasse diese Konsole für später offen. 

## Schritt 2: Pihole-Ordner erstellen
Ich erstelle ein neues Verzeichnis namens „pihole“ im Docker-Verzeichnis.
{{< gallery match="images/3/*.png" >}}

Danach wechsel ich in das neue Verzeichnis und erstelle zwei Ordner "etc-pihole" und "etc-dnsmasq.d": 
{{< terminal >}}
cd /volume1/docker/
mkdir -p {etc-pihole,etc-dnsmasq.d}
{{</ terminal >}}

Jetzt muss die folgende Docker-Compose-Datei mit Namen "pihole.yml" in das Pihole-Verzeichnis gelegt werden: 
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

Der Container kann nun gestartet werden:
{{< terminal >}}
sudo docker-compose up -d
{{</ terminal >}}


Ich rufe den Pihole-Server mit der Synology-IP-Adresse und meinem Container–Port auf und logge mich mit dem WEBPASSWORD-Passwort ein.
{{< gallery match="images/4/*.png" >}}

Nun kann die DNS-Adresse in der Fritzbox unter "Heimnetz" > "Netzwerk" > "Netzwerkeinstellungen" geändert werden.
{{< gallery match="images/5/*.png" >}}