+++
date = "2021-07-25"
title = "Großartiges mit Containern: Kühlschrank-Management mit Grocy"
difficulty = "level-1"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "kühlschrank", "erp", "mhd", "Speispläne", "cms", "Cafe", "Bistro"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/july/20210725-docker-grocy/index.de.md"
+++

Mit Grocy kann man einen ganzen Haushalt, Restaurant, Cafe, Bistro oder Lebensmittelmarkt managen. Man kann Kühlschränke, Speisepläne, Aufgabe, Einkaufslisten und die Mindesthaltbarkeit von Lebensmittel verwalten.
{{< gallery match="images/1/*.png" >}}

Heute zeige ich, wie man einen Grocy-Dienst auf der Synology-Diskstation installiert.

## Option für Profis
Als erfahrener Synology-Nutzer kann man sich natürlich gleich mit SSH einloggen und das ganze Setup via Docker-Compose-Datei installieren.
```
version: "2.1"
services:
  grocy:
    image: ghcr.io/linuxserver/grocy
    container_name: grocy
    environment:
      - PUID=1024
      - PGID=100
      - TZ=Europe/Berlin
    volumes:
      - ./data:/config
    ports:
      - 9283:80
    restart: unless-stopped
```
Weitere nützliche Docker-Images für den Heimgebrauch finden Sie im [Dockerverse]({{< ref "dockerverse" >}} "Dockerverse").

## Schritt 1: Grocy-Ordner vorbereiten
Ich erstelle ein neues Verzeichnis namens „grocy“ im Docker-Verzeichnis.
{{< gallery match="images/2/*.png" >}}

## Schritt 2: Grocy installieren
Ich klicke im Synology-Docker-Fenster auf den Reiter „Registrierung“ und suche nach „Grocy“. Ich wähle das Docker-Image „linuxserver/grocy:latest“ aus und klicke anschließend auf den Tag „latest“.
{{< gallery match="images/3/*.png" >}}

Ich klicke per Doppelklick  auf mein Grocy-Abbild.
{{< gallery match="images/4/*.png" >}}

Danach klicke ich auf „Erweiterte Einstellungen“ und aktiviere auch hier den „Automatischen Neustart". Ich wähle den Reiter „Volumen“ und klicke auf „Ordner hinzufügen“. Dort erstelle ich einen neuen Ordner mit diesem Mount-Pfad „/config“.
{{< gallery match="images/5/*.png" >}}

Ich vergebe feste Ports für den „Grocy“ – Container. Ohne feste Ports könnte es sein, dass der „Grocy-Server“ nach einem Neustart auf einen anderen Port läuft.
{{< gallery match="images/6/*.png" >}}

Zum Schluss trage ich noch diese Umgebungsvariablen ein:
{{<table "table table-striped table-bordered">}}
Variablenname |	Wert | Was ist das?
--- | --- | ---
TZ | Europe/Berlin | Zeitzone
PUID | 1024 | Nutzer-ID vom Synology-Admin-Nutzer
PGID |	100 | Gruppen-ID vom Synology-Admin-Nutzer
{{</table>}}

Siehe:
{{< gallery match="images/7/*.png" >}}

Der Container kann nun gestartet werden. Ich rufe den Grocy-Server mit der Synology-IP-Adresse und meinem Container–Port auf und logge mich mit dem Nutzernamen "admin" und dem Passwort "admin" ein.
{{< gallery match="images/8/*.png" >}}
