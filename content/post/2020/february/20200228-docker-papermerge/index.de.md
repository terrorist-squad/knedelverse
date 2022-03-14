+++
date = "2020-02-28"
title = "Großartiges mit Containern: Papermerge DMS auf einem Synology-NAS betreiben"
difficulty = "level-3"
tags = ["archiv", "automatisch", "dms", "Docker", "Document-Managment-System", "google", "ocr", "papermerge", "Synology", "tesseract", "texterkennung"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2020/february/20200228-docker-papermerge/index.de.md"
+++

Papermerge ist ein junges Document-Managment-System (DMS), dass Dokumente automatisch zuordnen und verarbeiten kann. In diesem Tutorial zeige ich, wie ich Papermerge auf meiner Synology-Diskstation installiert habe und wie das DMS funktioniert.

## Option für Profis
Als erfahrener Synology-Nutzer kann man sich natürlich gleich mit SSH einloggen und das ganze Setup via Docker-Compose-Datei installieren.
```
version: "2.1"
services:
  papermerge:
    image: ghcr.io/linuxserver/papermerge
    container_name: papermerge
    environment:
      - PUID=1024
      - PGID=100
      - TZ=Europe/Berlin
    volumes:
      - ./config>:/config
      - ./appdata/data>:/data
    ports:
      - 8090:8000
    restart: unless-stopped
```

## Schritt 1: Ordner erstellen
Als erstes erstelle ich einen Ordner für die Papermerge. Ich rufe die „Systemsteurung“ -> „Gemeinsamer Ordner“ auf und erstelle einen neuen Ordner „Dokumentenarchiv".
{{< gallery match="images/1/*.png" >}}


Schritt 2: Docker-Image suchen
Ich klicke im Synology-Docker-Fenster auf den Reiter „Registrierung“ und suche nach „Papermerge“. Ich wähle das Docker-Image „linuxserver/papermerge“ und klicke anschließend auf den Tag „latest“.
{{< gallery match="images/2/*.png" >}}

Nach dem Image – Download liegt das Image als Abbild bereit. Docker unterscheide zwischen 2 Zuständen, Container „Dynamisch zustand“ und Image/Abbild (Festzustand). Bevor wir nun einen Container aus dem Abbild erzeugen, müssen noch ein paar Einstellungen getätigt werden.

## Schritt 3: Image/Abbild in Betrieb nehmen:
Ich klicke per Doppelklick  auf mein Papermerge-Abbild.
{{< gallery match="images/3/*.png" >}}

Danach klicke ich auf „Erweiterte Einstellungen“ und aktiviere den „Automatischen Neustart". Ich wähle den Reiter „Volumen“ aus und klicke auf „Ordner hinzufügen“. Dort erstelle ich einen neuen Datenbank-Ordner mit diesem Mount-Pfad „/data“.
{{< gallery match="images/4/*.png" >}}

Außerdem hinterlege ich hier noch einen zweiten Ordner den ich mit den Mount-Pfad „/config“ einbinde. Wo dieser Lieg ist eigentlich egal. Wichtig ist jedoch, dass dieser dem Synology-Admin-Nutzer gehört.
{{< gallery match="images/5/*.png" >}}

Ich vergebe feste Ports für den „Papermerge“ – Container. Ohne feste Ports könnte es sein, dass der „Papermerge-Server“ nach einem Neustart auf einen anderen Port läuft.
{{< gallery match="images/6/*.png" >}}

Zum Schluss trage ich noch drei Umgebungsvariablen ein. Die Variable „PUID“ ist die User-ID und „PGID“ die Gruppen-ID meines Adminnutzers. Außerdem trage ich noch die richtige Zeitzone ein.

Man kann die PGID/PUID via SSH mit dem Befehl „cat /etc/passwd | grep admin“ herausfinden. 
{{< gallery match="images/7/*.png" >}}

Nach diesen Einstellungen kann der Papermerge-Server gestartet werden! Danach kann man Papermerge über die Ip-Adresse der Synology-Disktation und vergebenen Port aufrufen, zum Beispiel http://192.168.21.23:8095.
{{< gallery match="images/8/*.png" >}}

Der Standard-Login ist admin mit Password admin.

## Wie funktionioniert Papermerge?
Papermerge analysiert die Texte von Dokumente und Bilder. Dabei verwendet Papermerge eine von Goolge herausgegebene OCR/“optical character recognition“-Bibliothek namens tesseract.
{{< gallery match="images/9/*.png" >}}

Ich habe mir einen Ordner namens „Alles mit Lorem“ angelegt, um die automatische Dokumentenzuordnung zu testen. Danach habe ich mir im Menüpunkt „Automates“ ein neues Erkennungsmuster zusammengeklickt.
{{< gallery match="images/10/*.png" >}}

Alle neue Dokumente, die das Wort „Lorem“ enthalten, werden im Ordner „Alles mit Lorem“ eingeordnet und mit dem Tag „hat-lorem“ versehen. Wichtig ist, dass man bei den Tags ein Komma verwenden muss. Sonst wird der Tag nicht gesetzt.

Wenn in nun ein entsprechendes Dokument hochlade, wird diese vertaggt und eingeordnet.
{{< gallery match="images/11/*.png" >}}