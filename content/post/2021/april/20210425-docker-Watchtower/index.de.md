+++
date = "2021-04-25T09:28:11+01:00"
title = "Kurzgeschichte: Container automatisch aktualisieren mit Watchtower"
difficulty = "level-2"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "watchtower"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/april/20210425-docker-Watchtower/index.de.md"
+++

Wenn man Docker Container auf seiner Diskstation betreibt, möchte man natürlich, dass diese auch immer auf dem neusten Stand sind. Watchtower aktualisiert Images und Container selbstständig. So kann man die neusten Features und aktuellste Datensicherheit genießen. Heute zeige ich, wie man einen Watchtower auf der Synology-Diskstation installiert.

## Schritt 1: Synology vorbereiten
Als erstes muss der SSH-Login auf der Diskstation aktiviert werden. Dazu geht man in die „Systemsteuerung“ > „Terminal & SNMP“ und aktiviert dort die „SSH-Dienst aktivieren“-Einstellung.
{{< gallery match="images/1/*.png" >}}

Danach kann man sich via „SSH„, den angegebenen Port und den Administrator-Password anmelden (Windows-Nutzer nehmen Putty oder WinSCP).
{{< gallery match="images/2/*.png" >}}
Ich logge mich via Terminal, winSCP oder Putty ein und lasse diese Konsole für später offen. 

## Schritt 2: Watchtower-installieren
Ich benutze dazu die Konsole:
{{< terminal >}}
docker run --name watchtower --restart always -v /var/run/docker.sock:/var/run/docker.sock containrrr/watchtower
{{</ terminal >}}

Danach läuft Watchtower immer im Hintergrund.
{{< gallery match="images/3/*.png" >}}

