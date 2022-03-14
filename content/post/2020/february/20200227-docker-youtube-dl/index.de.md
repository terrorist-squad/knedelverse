+++
date = "2020-02-27"
title = "Großartiges mit Containern: Youtube-Downloader auf der Synology Diskstation betreiben"
difficulty = "level-1"
tags = ["Docker", "docker-compose", "download", "linux", "Synology", "video", "youtube"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2020/february/20200227-docker-youtube-dl/index.de.md"
+++

Viele meiner Freunde wissen, dass ich ein privates Lern-Video-Portal in meinem Homelab – Network betreibe. Ich habe mir Videos-Kurse aus vergangenen Lernportal-Mitgliedschaften und guten Youtube-Tutorials für den Offline-Gebrauch auf meinen NAS gesichert.
{{< gallery match="images/1/*.png" >}}

Über die Zeit habe ich 8845 Video-Kurse mit 282616 Einzelvideos gesammelt. Die Gesamtlaufzeit entspricht ca. 2 Jahre. Absolut verrückt!

In diesem Tutorial zeige ich, wie man sich gute Youtube-Tutorials mit einem Docker-Download-Dienst für Offline-Zwecke sichern kann.

## Option für Profis
Als erfahrener Synology-Nutzer kann man sich natürlich gleich mit SSH Einloggen und das ganze Setup via Docker-Compose-Datei installieren.
```
version: "2"
services:
  youtube-dl:
    image: modenaf360/youtube-dl-nas
    container_name: youtube-dl
    environment:
      - MY_ID=admin
      - MY_PW=admin
    volumes:
      - ./YouTube:/downfolder
    ports:
      - 8080:8080
    restart: unless-stopped
```

## Schritt 1
Als erstes erstelle ich einen Ordner für die Downloads. Ich rufe die „Systemsteurung“ -> „Gemeinsamer Ordner“ auf und erstelle einen neuen Ordner „Downloads".
{{< gallery match="images/2/*.png" >}}

## Schritt 2: Docker-Image suchen
Ich klicke im Synology-Docker-Fenster auf den Reiter „Registrierung“ und suche nach „youtube-dl-nas". Ich wähle das Docker-Image „modenaf360/youtube-dl-nas“ und klicke anschließend auf den Tag „latest".
{{< gallery match="images/3/*.png" >}}

Nach dem Image – Download liegt das Image als Abbild bereit. Docker unterscheide zwischen 2 Zuständen, Container „Dynamisch zustand“ und Image/Abbild (Festzustand). Bevor wir nun einen Container aus dem Abbild erzeugen, müssen noch ein paar Einstellungen getätigt werden.

## Schritt 3: Image/Abbild in Betrieb nehmen:
Ich klicke per Doppelklick  auf mein youtube-dl-nas-Abbild. 
{{< gallery match="images/4/*.png" >}}

Danach klicke ich auf „Erweiterte Einstellungen“ und aktiviere den „Automatischen Neustart". Ich wähle den Reiter „Volumen“ aus und klicke auf „Ordner hinzufügen“. Dort erstelle ich einen neuen Datenbank-Ordner mit diesem Mount-Pfad „/downfolder“.
{{< gallery match="images/5/*.png" >}}

Ich vergebe feste Ports für den „Youtube-Downloader“ – Container. Ohne feste Ports könnte es sein, dass der „Youtube-Downloader“ nach einem Neustart auf einen anderen Port läuft.
{{< gallery match="images/6/*.png" >}}

Zum Schluss trage ich noch zwei Umgebungsvariablen ein. Die Variable „MY_ID“ ist mein Nutzername und „MY_PW“ mein Password.
{{< gallery match="images/7/*.png" >}}

Nach diesen Einstellungen kann Downloader gestartet werden! Danach kann man den Downloader über die Ip-Adresse der Synology-Disktation und vergebenen Port aufrufen, zum Beispiel http://192.168.21.23:8070 . 
{{< gallery match="images/8/*.png" >}}

Für die Authentifizierung nimmt man den Nutzernamen und Passwort aus MY_ID und MY_PW.

## Schritt 4: Los gehts
Nun kann Youtube-Video-Urls und Playlist-Urls in „URL“-Feld eintragen und alle Videos landen automatisch im Download-Ordner der Synology-Diskstation.
{{< gallery match="images/9/*.png" >}}

Download-Ordner:
{{< gallery match="images/10/*.png" >}}