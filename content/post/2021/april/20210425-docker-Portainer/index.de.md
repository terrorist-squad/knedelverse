+++
date = "2021-04-25T09:28:11+01:00"
title = "Großartiges mit Containern: Portainer als Alternative zu Synology Docker GUI"
difficulty = "level-3"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "watchtower"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210425-docker-Portainer/index.de.md"
+++

## Schritt 1: Synology vorbereiten
Als erstes muss der SSH-Login auf der Diskstation aktiviert werden. Dazu geht man in die „Systemsteuerung“ > „Terminal & SNMP“ und aktiviert dort die „SSH-Dienst aktivieren“-Einstellung.
{{< gallery match="images/1/*.png" >}}

Danach kann man sich via „SSH„, den angegebenen Port und den Administrator-Password anmelden (Windows-Nutzer nehmen Putty oder WinSCP).
{{< gallery match="images/2/*.png" >}}
Ich logge mich via Terminal, winSCP oder Putty ein und lasse diese Konsole für später offen. 

## Schritt 2: portainer-Ordner erstellen
Ich erstelle ein neues Verzeichnis namens „portainer“ im Docker-Verzeichnis.
{{< gallery match="images/3/*.png" >}}

Danach gehe ich mit der Konsole in das portainer–Verzeichnis und erstelle dort einen Ordner und eine neue Datei namens „portainer.yml“.
{{< terminal >}}
cd /volume1/docker/portainer
mkdir portainer_data
vim portainer.yml
{{</ terminal >}}
Hier ist der Inhalt der „portainer.yml“-Datei:
```
version: '3'

services:
  portainer:
    image: portainer/portainer:latest
    container_name: portainer
    restart: always
    ports:
      - 90070:9000
      - 9090:8000
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - ./portainer_data:/data
```
Weitere nützliche Docker-Images für den Heimgebrauch finden Sie im [Dockerverse]({{< ref "dockerverse" >}} "Dockerverse").


## Schritt 3: Portainer-Start
Auch in diesem Schritt kann ich die Konsole gut gebrauchen. Ich starte den portainer-Server via Docker-Compose.
{{< terminal >}}
sudo docker-compose -f portainer.yml up -d
{{</ terminal >}}

Danach kann ich meinen Portainer-Server mit der IP der Diskstation und den vergeben Port aus „Schritt 2“ aufrufen. Ich gebe mein Admin-Passwort ein und wähle die lokale Variante.

{{< gallery match="images/4/*.png" >}}
Wie man sehen kann, funktioniert alles prima!

{{< gallery match="images/5/*.png" >}}