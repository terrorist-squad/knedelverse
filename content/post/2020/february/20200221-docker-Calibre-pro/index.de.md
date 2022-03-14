+++
date = "2020-02-21"
title = "Großartiges mit Containern: Calibre mit Docker-Compose betreiben (Synology-Profi-Setup)"
difficulty = "level-3"
tags = ["calibre", "calibre-web", "Docker", "docker-compose", "Synology", "linux"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2020/february/20200221-docker-Calibre-pro/index.de.md"
+++

Es gibt bereits ein einfacheres Tutorial auf diesem Blog: [Synology-Nas: Calibre Web als ebook-Bibliothek installieren]({{< ref "post/2020/february/20200213-synology-calibreweb" >}} "Synology-Nas: Calibre Web als ebook-Bibliothek installieren"). Diese Tutorial ist für alle Synology-DS-Profis.

## Schritt 1: Synology vorbereiten
Als erstes muss der SSH-Login auf der Diskstation aktiviert werden. Dazu geht man in die „Systemsteuerung“ > „Terminal & SNMP“ und aktiviert dort die „SSH-Dienst aktivieren“-Einstellung.
{{< gallery match="images/1/*.png" >}}

Danach kann man sich via „SSH„, den angegebenen Port und den Administrator-Password anmelden (Windows-Nutzer nehmen Putty oder WinSCP).
{{< gallery match="images/2/*.png" >}}

Ich logge mich via Terminal, winSCP oder Putty ein und lasse diese Konsole für später offen.

## Schritt 2: Bücher-Ordner erstellen
Ich erstelle einen neuen Ordner für die Calibre- Bibliothek. Dafür rufe ich die „Systemsteurung“ -> „Gemeinsamer Ordner“ auf und erstelle einen neuen Ordner „Buecher". Wenn noch kein „Docker"-Ordner vorhanden ist, dann muss auch dieser angelegt werden.
{{< gallery match="images/3/*.png" >}}

## Schritt 3: Bücher-Ordner vorbereiten
Jetzt muss die folgende Datei heruntergeladen und entpackt werden: https://drive.google.com/file/d/1zfeU7Jh3FO_jFlWSuZcZQfQOGD0NvXBm/view. Der Inhalt („metadata.db“) muss in das neue Bücher-Verzeichnis gelegt werden, siehe:
{{< gallery match="images/4/*.png" >}}

## Schritt 4: Docker-Ordner vorbereiten
Ich erstelle ein neues Verzeichnis namens „calibre“ im Docker-Verzeichnis:
{{< gallery match="images/5/*.png" >}}

Danach wechsel ich in das neue Verzeichnis und erstelle dort eine neue Datei namens „calibre.yml“ mit folgendem Inhalt:
```
version: '2'
services:
  calibre-web:
    image: linuxserver/calibre-web
    container_name: calibre-web-server
    environment:
      - PUID=1026
      - PGID=100
      - TZ=Europe/Berlin
    volumes:
      - /volume1/Buecher:/books
      - /volume1/docker/calibre:/briefkaste
    ports:
      - 8055:8083
    restart: unless-stopped
```

In dieser neuen Datei müssen mehrere Stellen wie folgt angepasst werden:
* PUID/PGID: In PUID/PGID muss die User– und Gruppen-ID des DS–Nutzers eingetragen werden. Hier verwende ich die Konsole aus „Schritt 1“ und die befehle „id -u“ um die User-ID zu sehen. Mit dem Befehl „id -g“ bekomme ich die Gruppen-ID.
* ports: Bei den Port muss der vordere Teil „8055:“ angepasst werden.
Verzeichnisse	Alle Verzeichnisse in dieser Datei müssen korrigiert werden. Die richtigen Adressen kann man im Eigenschaften-Fenster der DS sehen. (Screenshot folgt)

{{< gallery match="images/6/*.png" >}}

## Schritt 5: Teststart
Auch in diesem Schritt kann ich die Konsole gut gebrauchen. Ich wechsel in das Calibre-Verzeichnis und starte dort den Calibre-Server via Docker-Compose. 
{{< terminal >}}
cd /volume1/docker/calibre
sudo docker-compose -f calibre.yml up -d
{{</ terminal >}}

{{< gallery match="images/7/*.png" >}}

## Schritt 6: Einrichtung
Danach kann ich meinen Calibre-Server mit der IP der Diskstation und den vergeben Port aus „Schritt 4“ aufrufen. Im Setup verwende ich meinen „/books“-Mountpoint. Danach ist der Server schon nutzbar.
{{< gallery match="images/8/*.png" >}}

## Schritt 7: Finalisierung des Setups
Auch in diesem Schritt wird die Konsole gebraucht. Ich benutze den Befehl „exec“ um die Container-interne Applikations-Datenbank zu sichern.
{{< terminal >}}
sudo docker exec -it calibre-web-server cp /app/calibre-web/app.db /briefkaste/app.db
{{</ terminal >}}

Danach sehe ich eine neue „app.db“-Datei im Calibre-Verzeichnis:
{{< gallery match="images/9/*.png" >}}

Anschließend stoppe ich den Calibre-Server:
{{< terminal >}}
sudo docker-compose -f calibre.yml down
{{</ terminal >}}

Nun ändere ich den Briefkaste-Pfad und persistiere darüber die Applikations-Datenbank.
```
version: '2'
services:
  calibre-web:
    image: linuxserver/calibre-web
    container_name: calibre-web-server
    environment:
      - PUID=1026
      - PGID=100
      - TZ=Europe/Berlin
    volumes:
      - /volume1/Buecher:/books
      - /volume1/docker/calibre/app.db:/app/calibre-web/app.db
    ports:
      - 8055:8083
    restart: unless-stopped
```

Danach kann der Server wieder gestartet werden:
{{< terminal >}}
sudo docker-compose -f calibre.yml up -d
{{</ terminal >}}