+++
date = "2021-04-18"
title = "Großartiges mit Containern: Docspell DMS auf der Synology-Diskstation betreiben"
difficulty = "level-2"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "Document-Managment-System"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210418-docker-Docspell/index.de.md"
+++

Docspell ist ein Document Management System für die Synology-Diskstation. Durch Docspell können Unterlagen indiziert, gesucht und sehr viel schneller gefunden werden. Heute zeige ich, wie man einen Docspell-Dienst auf der Synology-Diskstation installiert.

## Schritt 1: Synology vorbereiten
Als erstes muss der SSH-Login auf der Diskstation aktiviert werden. Dazu geht man in die „Systemsteuerung“ > „Terminal & SNMP“ und aktiviert dort die „SSH-Dienst aktivieren“-Einstellung.
{{< gallery match="images/1/*.png" >}}

Danach kann man sich via „SSH„, den angegebenen Port und den Administrator-Password anmelden (Windows-Nutzer nehmen Putty oder WinSCP).
{{< gallery match="images/2/*.png" >}}
Ich logge mich via Terminal, winSCP oder Putty ein und lasse diese Konsole für später offen. 

## Schritt 2: Docspel-Ordner erstellen
Ich erstelle ein neues Verzeichnis namens „docspell“ im Docker-Verzeichnis.
{{< gallery match="images/3/*.png" >}}

Jetzt muss die folgende Datei heruntergeladen und im Verzeichnis entpackt werden: https://github.com/eikek/docspell/archive/refs/heads/master.zip . Ich benutze dazu die Konsole:
{{< terminal >}}
cd /volume1/docker/docspell/
mkdir docs
mkdir postgres_data
wget https://github.com/eikek/docspell/archive/refs/heads/master.zip 
/bin/7z x master.zip
{{</ terminal >}}

Dann editiere ich die „docker/docker-compose.yml“-Datei und trage dort bei „consumedir“ und „db“ meine Synology-Adressen ein:
{{< gallery match="images/4/*.png" >}}

Danach kann ich die Compose-Datei starten:
{{< terminal >}}
cd docspell-master/docker/
docker-compose up -d
{{</ terminal >}}

Nach ein paar Minuten kann Ich meinen Docspell-Server mit der IP der Diskstation und den vergeben Port/7878 aufrufen. 
{{< gallery match="images/5/*.png" >}}

Die Suche nach Dokumenten funktioniert gut. Schade finde ich, dass die Texte in Bildern nicht indiziert werden. Bei Papermerge kann man auch nach Texten in Bilder suchen.